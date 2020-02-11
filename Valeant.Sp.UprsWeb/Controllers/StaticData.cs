using System;
using System.Collections.Generic;
using Valeant.Sp.UprsWeb.Controllers.Entities;

namespace Valeant.Sp.UprsWeb.Controllers
{
    public class StaticData
    {
        //этого спрочника нет в ТЗ -поэтому статика
        public static List<TripTypeReference> TripTypeReferences = new List<TripTypeReference>();
        public static List<OwnExpenseOptionReference> OwnExpenseOptionReferences =new List<OwnExpenseOptionReference>();

        public static List<DailyLimitReference> DailyLimitReferences = new List<DailyLimitReference>();

        public static List<FuelCardReference> FuelCardReferences = new List<FuelCardReference>();

        public static void Seed()
        {
            TripTypeReferences.AddRange(new List<TripTypeReference>
            {
                new TripTypeReference
                {
                    Id = 1,
                    Name = "Служебная поездка"
                },
                new TripTypeReference
                {
                    Id = 2,
                    Name = "Командировка"
                }
            });

            OwnExpenseOptionReferences.AddRange(new List<OwnExpenseOptionReference>
            {
                new OwnExpenseOptionReference
                {
                    Id = 1,
                    Name = "До поездки"
                },
                new OwnExpenseOptionReference
                {
                    Id = 2,
                    Name = "После поездки"
                }
            });

            DailyLimitReferences.AddRange(new List<DailyLimitReference>
            {
                new DailyLimitReference
                {
                    NumSelected = 0,
                    IsMultiplier = true,
                    Number = 1
                },
                new DailyLimitReference
                {
                    NumSelected = 1,
                    IsMultiplier = true,
                    Number = 0.5
                },
                new DailyLimitReference
                {
                    NumSelected = 2,
                    IsMultiplier = false,
                    Number = 100
                },
            });

            FuelCardReferences.AddRange(new List<FuelCardReference>
            {
                new FuelCardReference
                {
                    Id = 1,
                    HumanId = 1,
                    Number = "card-1",
                    Active = true
                },
                new FuelCardReference
                {
                    Id = 2,
                    HumanId = 2,
                    Number = "card-2",
                    Active = false
                },
                new FuelCardReference
                {
                    Id = 2,
                    HumanId = 3,
                    Number = "card-3",
                    Active = true
                }
            });
        }


        public static IEnumerable<TripTypeReference> GetTripTypeData()
        {
            return TripTypeReferences;
        }

        public static IEnumerable<OwnExpenseOptionReference> GetOwnExpenseOptionsData()
        {
            return OwnExpenseOptionReferences;
        }


        public static IEnumerable<FuelCardReference> GetFuelCardReferences()
        {
            return FuelCardReferences;
        }

        public static List<DailyLimitReference> GetDailyLimits()
        {
            return DailyLimitReferences;
        }
    }

    public class DocumentTypeReference : IdEntity
    {
        public string Name { get; set; }
    }

    public class AccountGroupReference : IdEntity
    {
        public string AccountGroupName { get; set; }
        public string AccountingRecords { get; set; }
    }

    public class GiftRecieverReference : IdEntity
    {
        public GiftRecieverReference()
        {
            PreviousGifts = new List<PreviousGiftReference>();
        }

        public string Name { get; set; }
        public string SecondName { get; set; }
        public string MiddleName { get; set; }
        public string Organization { get; set; }
        public string Position { get; set; }
        public string AgreementNumber { get; set; }
        public List<long> GiftRequestIds { get; set; }
        public List<PreviousGiftReference> PreviousGifts { get; set; }

    }

    public class FuelCardReference : IdEntity
    {
        public int HumanId { get; set; }
        public string Number { get; set; }
        public bool Active { get; set; }
    }

    public class DailyLimitsBaseReference : IdEntity
    {
        public string RateName { get; set; }
        public double Limit { get;set; }
    }

    public class DailyLimitReference
    {
        public Int32 NumSelected { get; set; }
        public bool IsMultiplier { get; set; }
        public double Number { get; set; }
    }
}