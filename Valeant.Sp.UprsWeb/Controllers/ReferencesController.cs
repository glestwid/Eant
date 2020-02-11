using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Globalization;
using System.Linq;
using System.Security.Principal;
using System.Threading.Tasks;
using System.Web.Mvc;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.Controllers.Entities;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Security;

namespace Valeant.Sp.UprsWeb.Controllers
{
    public class ReferencesController : JsonNetController
    {
        static ReferencesController()
        {
            DataProvider = new DataProvider();
        }

        public static DataProvider DataProvider { get; set; }

        [HttpPost]
        [Route("getAll")]
        public async Task<ActionResult> GetAll( /*[FromBody]*/ string[] types)
        {
            var claim = ((WindowsIdentity)HttpContext.User.Identity).Claims.FirstOrDefault(x => x.Type == ClaimsFiller.ValeantHumanIdClaimType);
            var humanId = long.Parse(claim.Value);
            dynamic data = new ExpandoObject();

            if (types == null)
            {
                return HttpNotFound();
            }

            foreach (var type in types)
            {
                switch (type)
                {
                    case "person":
                        {
                            data.personData = DataProvider.Humans;
                            break;
                        }
                    case "country":
                        {
                            var lst = (await DataProvider.ReadSimpleDictionaryFullAsync("Countries")).Select(x => ReferencesController.ConvertCountry(x.Value));
                            // https://ontec.tpondemand.com/entity/614
                            // Добавить Россию вверх списка выбора стран - проставлять россию по умолчанию
                            var data2 = lst.OrderBy(c => c.IsForeign).AsEnumerable();
                            data.countries = data2;
                            break;
                        }
                    case "vehicle":
                        {
                            data.vehicles = (await DataProvider.ReadSimpleDictionaryFullAsync("VehicleTypes")).Select(x => ConvertVehicleType(x.Value));
                            break;
                        }
                    case "tripAim":
                        {
                            data.tripAims = (await DataProvider.ReadSimpleDictionaryFullAsync("TripAims")).Select(x => ConvertTripAim(x.Value));
                            break;
                        }
                    case "tripType":
                        {
                            data.tripTypes = StaticData.GetTripTypeData();
                            break;
                        }
                    case "ownExpenseOption":
                        {
                            data.ownExpenseOptions = StaticData.GetOwnExpenseOptionsData();
                            break;
                        }
                    case "city":
                        {
                            data.cities = (await DataProvider.ReadSimpleDictionaryFullAsync("Cities")).Select(x => ConvertCity(x.Value));
                            break;
                        }
                    case "hotel":
                        {
                            data.hotels = (await DataProvider.ReadSimpleDictionaryFullAsync("Hotels")).Select(x => ConvertHotel(x.Value));
                            break;
                        }
                    case "costItem":
                        {
                            data.costItems = (await DataProvider.ReadCostcenterAsync()).Select(CostcenterConvert);
                            break;
                        }
                    //case "limit":
                    //{
                    //        var limits = await DataProvider.ReadLimitItemCollectionAsync(humanId);
                    //        data.limits = limits.ToDictionary(x => x.Expenditure, x => x.Limit);
                    //        break;
                    //    }
                    case "dailyLimitBase":
                        {
                            data.dailyLimitsBase = (await DataProvider.ReadSimpleDictionaryFullAsync("DailyLimits")).Select(x => ConvertDailyLimit(x.Value));
                            break;
                        }
                    case "dailyLimit":
                        {
                            data.dailyLimits = StaticData.GetDailyLimits();
                            break;
                        }
                    case "role":
                        {
                            data.roles = await DataProvider.ReadRolesAsync();
                            break;
                        }
                    case "car":
                        {
                            data.cars = await GetCarReferencesByIdAsync(humanId);
                            break;
                        }
                    case "fuelConsumption":
                        {
                            data.fuelConsumption = (await DataProvider.ReadSimpleDictionaryFullAsync("FuelConsumption")).Select(x => ConvertFuelConsumption(x.Value));
                            break;
                        }

                    case "fuelCard":
                        {
                            data.fuelCard = StaticData.GetFuelCardReferences();
                            break;
                        }
                    case "fuelCardTransaction":
                        {
                            data.fuelCardTransactions = await DataProvider.ReadFuelCradTransactionCollectionAsync(humanId,null,null);
                            break;
                        }


                    case "accountGroup":
                    {
                        data.accountGroups = (await DataProvider.ReadSimpleDictionaryFullAsync("AccountGroups")).Select(x => ConvertAccountGroup(x.Value));
                        break;
                    }
                    case "documentType":
                    {
                        data.documentTypes = (await DataProvider.ReadSimpleDictionaryFullAsync("DocumentTypes")).Select(x => ConvertDocumentType(x.Value));
                        break;
                    }
                    //case "Expenditure":
                    //{
                    //    data.Expenditure =
                    //        (await DataProvider.GetAllExpendituresAsync()).Select(
                    //            x => new ReferenceBase {Id = x.ExpenditureId, Name = x.Title});
                    //        break;
                    //}

                    default:
                        {
                            var res = await DataProvider.ReadSimpleDictionaryCollectionAsync(type);
                            ((IDictionary<string, object>)data)[type] = res.Select(x => new ReferenceBase { Id = x.Key, Name = x.Value });
                            break;
                        }
                }
            }

            return Json(data);
        }

        internal static async Task<List<CarReference>> GetCarReferencesAsync()
        {
            List<CarReference> list = new List<CarReference>();

            CarCollection cars = await DataProvider.ReadCarCollectionAsync();

            foreach (Car car in cars)
                list.Add(new CarReference
                {
                    Id = car.Id,
                    Type = car.Type,
                    Number = car.Number,
                    HumanId = car.Human.Id

                }
            );
            return list;

        }

        internal static async Task<List<CarReference>> GetCarReferencesByIdAsync(long humanId)
        {
            List<CarReference> list = new List<CarReference>();

            CarCollection cars = await DataProvider.ReadCarCollectionAsync();

            foreach (Car car in cars) {
                if (car.Human.Id == humanId) {
                    list.Add(new CarReference
            {
                Id = car.Id,
                Type = car.Type,
                Number = car.Number,
                HumanId = car.Human.Id

                    });
                }
              }
            
            return list;

        }

        internal static VehicleTypeReference ConvertVehicleType(SimpleDictionaryItem item)
        {
            var reference = new VehicleTypeReference
            {
                Id = item.Id,
                Name = item.Value
            };
            return reference;
        }

        internal static TripAimReference ConvertTripAim(SimpleDictionaryItem item)
        {
            var reference = new TripAimReference
            {
                Id = item.Id,
                Name = item.Value
            };
            return reference;
        }

        internal static CityReference ConvertCity(SimpleDictionaryItem item)
        {
            var reference = new CityReference
            {
                Id = item.Id,
                Name = item.Value
            };
            if (item.Reference.HasValue) reference.CountryId = item.Reference.Value;
            return reference;
        }

        internal static DocumentTypeReference ConvertDocumentType(SimpleDictionaryItem item)
        {
            var reference = new DocumentTypeReference
            {
                Id = item.Id,
                Name = item.Value
            };
            return reference;
        }

        internal static AccountGroupReference ConvertAccountGroup(SimpleDictionaryItem item)
        {
            var reference = new AccountGroupReference
            {
                Id = item.Id,
                AccountGroupName = item.Value
            };

            if (item.Advanced != null)
            {
                reference.AccountingRecords = item.Advanced;
            }

            return reference;
        }

        internal static DailyLimitsBaseReference ConvertDailyLimit(SimpleDictionaryItem item)
        {
            var reference = new DailyLimitsBaseReference
            {
                Id = item.Id,
                RateName = item.Value
            };

            if (item.Advanced != null)
            {
                double res;
                if (Double.TryParse(item.Advanced, NumberStyles.Any, CultureInfo.InvariantCulture, out res))
                    reference.Limit = res;
            }

            return reference;
        }

        internal static FuelConsumptionReference ConvertFuelConsumption(SimpleDictionaryItem item)
        {
            var reference = new FuelConsumptionReference
            {
                Id = item.Id,
                Name = item.Value
            };
            reference.ConsumptionSummer = 11.5f;
            reference.ConsumptionWinter = 12.5f;


            if (item.Advanced != null)
            {
                string[] tokens = item.Advanced.Split(new char[] { ';' });

                if (tokens.Length == 3)
                {
                  float val1, val2;

                  reference.FuelGrade = tokens[0];
                    
                    if (float.TryParse(tokens[1], out val1) & float.TryParse(tokens[2], out val2))
                    {
                        
                        reference.ConsumptionSummer = val1;
                        reference.ConsumptionWinter = val2;

                    }
                } 
            }
            
            return reference;
        }
        
        internal static CountryReference ConvertCountry(SimpleDictionaryItem item)
        {
            var reference = new CountryReference
            {
                Id = item.Id,
                Name = item.Value
            };
            if (item.Flag.HasValue) reference.IsForeign = item.Flag.Value;
            if (item.Flag1.HasValue) reference.IsCis = item.Flag1.Value;
            return reference;
        }

        internal static HotelReference ConvertHotel(SimpleDictionaryItem item)
        {
            var reference = new HotelReference
            {
                Id = item.Id,
                Name = item.Value,
                CityId = item.Reference ?? -1
            };
            return reference;
        }

        internal static CostItemReference CostcenterConvert(Costcenter costcenter)
        {
            return new CostItemReference
            {
                Id = costcenter.Id,
                Name = costcenter.Description
            };
        }
    }
}