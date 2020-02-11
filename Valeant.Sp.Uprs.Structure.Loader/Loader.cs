using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Schema;
using System.Xml.Serialization;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;

namespace Valeant.Sp.Uprs.Structure.Loader
{
    public static class Loader {
        public static bool Validate(string targetNamespace, Stream xsdSource, Stream xmlSource, ValidationEventHandler validationEventHandler)
        {
            var schemas = new XmlSchemaSet();
            schemas.Add(targetNamespace, XmlReader.Create(xsdSource));
            var document = XDocument.Load(xmlSource);
            var errors = false;
            document.Validate(schemas, (sender, args) =>
            {
                errors = true;
                if (validationEventHandler != null) validationEventHandler(sender, args);
            });
            return !errors;
        }

        public static Domain.Valeant LoadStructure(Stream xmlSource)
        {
            var serializer = new XmlSerializer(typeof(Domain.Valeant), new XmlRootAttribute("valeant"));
            return (Domain.Valeant)serializer.Deserialize(xmlSource);
        }

        public static void Convert(Domain.Valeant valeant, DepartmentStatusesStrToLong departmentstatus, EmployeeStatusesStrToLong employeestatus, bool isFirst,
            out IEnumerable<CountryType> country,
            out IEnumerable<OrganizationType> organization,
            out IEnumerable<CostcenterType> costcenter,
            out IEnumerable<DepartmentType> department,
            out IEnumerable<DepartmentConditionType> departmentcondition,
            out IEnumerable<EmployeePositionType> emploeeposition,
            out IEnumerable<HumanType> human,
            out IEnumerable<EmployeeType> employee
            )
        {
            //страна
            var countryArr = new CountryType[1];
            countryArr[0] = new CountryType { Code = valeant.Country.Code, Name = valeant.Country.Name };

            //Организация
            var organizationArr = new OrganizationType[1];
            organizationArr[0] = new OrganizationType { Code = valeant.Country.Organization.Code, Country = valeant.Country.Code, Value = valeant.Country.Organization.Value };

            //департаменты
            var departments = new List<DepartmentType>();
            //косты
            var costCerters = new Dictionary<string, CostcenterType>();
            //состояния
            var departmentConditions = new List<DepartmentConditionType>();
            foreach (var item in valeant.Country.Organization.Department)
            {
                //состояния
                departmentConditions.AddRange(
                    item.Condition.Where(y => y.Name != null).Select(x => new DepartmentConditionType { Code = item.Code, Name = x.Name, Value = x.Value })
                    );
                //косты
                if (item.CostCenter != null && !string.IsNullOrEmpty(item.CostCenter.Code) && !costCerters.ContainsKey(item.CostCenter.Code))
                    costCerters.Add(item.CostCenter.Code, new CostcenterType { Code = item.CostCenter.Code, Description = item.CostCenter.Description });
                if (!departmentstatus.ContainsKey(item.Status)) throw new Exception("Status департамента не найден в справочниеке статусов");
                departments.Add(new DepartmentType
                {
                    Code = item.Code,
                    CostCenter = item.CostCenter.Code,
                    Name = item.Name,
                    Organization = organizationArr[0].Code,
                    Parent = item.Parent,
                    Status = departmentstatus[item.Status]
                });
            }
            //должности
            var employeePositions = new Dictionary<string, EmployeePositionType>();
            var humans = new Dictionary<string, HumanType>();
            var employees = new List<EmployeeType>();
            foreach (var item in valeant.Country.Organization.Employee
                .Where(item => !isFirst || item.Status != "Уволен")
                .Where(item => item.Contract.Sort == "Основное место работы" || item.Contract.Sort == "Внешнее совместительство"))
            {
                //косты
                if (item.CostCenter != null && !string.IsNullOrEmpty(item.CostCenter.Code) &&
                    !costCerters.ContainsKey(item.CostCenter.Code))
                    costCerters.Add(item.CostCenter.Code,
                        new CostcenterType { Code = item.CostCenter.Code, Description = item.CostCenter.Description });
                //должности
                if (item.Position != null && !employeePositions.ContainsKey(item.Position.Code))
                    employeePositions.Add(item.Position.Code,
                        new EmployeePositionType { Code = item.Position.Code, Value = item.Position.Value });
                //физлица
                if (!humans.ContainsKey(item.Code))
                    humans.Add(item.Code,
                        new HumanType
                        {
                            Code = item.Code,
                            FullName = $"{item.LastName} {item.FirstName} {item.Patronymic}",
                            Birthday = DateTime.ParseExact(item.Birthday, "dd.MM.yyyy", null),
                            City = item.City,
                            Email = item.Email,
                            DocumentSeries = item.Document.Series,
                            DocumentNumber = item.Document.Number,
                            DocumentIssuedOn = DateTime.ParseExact(item.Document.IssuedOn, "dd.MM.yyyy", null),
                            DocumentIssuedBy = item.Document.IssuedBy,
                            UserAccount = item.Useraccount
                        });
                //сотрудники
                if (!employeestatus.ContainsKey(item.Status))
                    throw new Exception("Status сотрудника не найден в справочниеке статусов");
                var currentEmployee = new EmployeeType
                {
                    Human = item.Code,
                    ClockNumber = item.ClockNumber,
                    Department = item.Department,
                    Position = item.Position.Code,
                    Status = employeestatus[item.Status],
                    Manager1StLevel = item.ManagerCode,
                };
                if (item.CostCenter != null)
                    currentEmployee.CostCentre = item.CostCenter.Code;
                if (!string.IsNullOrEmpty(item.Contract.ExpireDate))
                    currentEmployee.ExpireDate = DateTime.ParseExact(item.Contract.ExpireDate, "dd.MM.yyyy", null);
                employees.Add(currentEmployee);
            }
            var badStatus = employeestatus["Уволен"];
            foreach (var employeeItem in employees)
            {
                //Ищем манагера
                if (!humans.ContainsKey(employeeItem.Manager1StLevel))
                    //throw new Exception("Не найден менеджер 1 уровня");
                    continue;
                var humanManager = humans[employeeItem.Manager1StLevel];
                //Ищем сотрудников привязаных к манагеру
                var humanManagerEmployees = employees.Where(x => x.Human == humanManager.Code).ToArray();
                if (!humanManagerEmployees.Any())
                    throw new Exception("Не найден менеджер 1 уровня");
                if (humanManagerEmployees.Count() == 1) //Если таковой один, то он и есть
                    employeeItem.Manager2NdLevel = humanManagerEmployees.First().Manager1StLevel;
                else
                {
                    //Ищем активного
                    var activeManagerEmployee = humanManagerEmployees.FirstOrDefault(x => x.Status != badStatus);
                    if (activeManagerEmployee != null)
                        employeeItem.Manager2NdLevel = activeManagerEmployee.Manager1StLevel;
                    else
                    {
                        //Все уволены. Извлекаем последнюю дату увольнения
                        var lastdate = humanManagerEmployees.Max(x => x.ExpireDate.Value);
                        var lastdateEmployee = humanManagerEmployees.FirstOrDefault(x => x.ExpireDate == lastdate);
                        employeeItem.Manager2NdLevel = lastdateEmployee.Manager1StLevel;
                    }
                }
            }
            country = countryArr;
            organization = organizationArr;
            costcenter = costCerters.Values.ToArray();
            department = departments;
            departmentcondition = departmentConditions;
            emploeeposition = employeePositions.Values.ToArray();
            human = humans.Values.ToArray();
            employee = employees;
        }

        public static void Load(string xmlName, bool isFirst, string defaultRole)
        {
            using (var source = File.OpenRead(xmlName))
            {
                Load(source, isFirst, defaultRole).Wait();
            }
        }

        public static async Task<int> Load(Stream xmlSource, bool isFirst, string defaultRole)
        {
            var valeant = LoadStructure(xmlSource);
            var provider = new DataProvider();
            var departmentstatus = await provider.ReadDepartmentStatuses();
            var employeestatus = await provider.ReadEmployeeStatuses();
            IEnumerable<CountryType> country;
            IEnumerable<OrganizationType> organization;
            IEnumerable<CostcenterType> costcenter;
            IEnumerable<DepartmentType> department;
            IEnumerable<DepartmentConditionType> departmentcondition;
            IEnumerable<EmployeePositionType> emploeeposition;
            IEnumerable<HumanType> human;
            IEnumerable<EmployeeType> employee;
            Convert(valeant, departmentstatus, employeestatus, isFirst, out country, out organization, out costcenter, out department, out departmentcondition, out emploeeposition, out human, out employee);
            return await provider.RegisterDepartmentStructure(country, organization, costcenter, department, departmentcondition, emploeeposition, human, employee, defaultRole);
        }
    }
}
