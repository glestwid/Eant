using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Collections.ObjectModel;
using Valeant.Sp.Uprs.Data.Domain;

namespace Valeant.Sp.UprsWeb.Controllers.Entities
{
    public class ApprovalData
    {
        public long Id { get; set; }
        public long Number { get; set; }
        public DateTime Date { get; set; }
        public string Type { get; set; }
        public string Person { get; set; }
        public string Division { get; set; }
        public bool IsApproved { get; set; }
        [JsonProperty(PropertyName = "actions")]
        public List<string> Actions { get; set; }

        public string Status { get; set; }
    }

    public class PersonReference
    {
        public Int64 Id { get; set; }

        public string FullName { get; set; }
        public string Position { get; set; }
        public string CostCenter { get; set; }
        public string DepartmentName { get; set; }
        public string Tel { get; set; }
        public string Email { get; set; }
        public string Passport { get; set; }
        public string TravellingPassport { get; set; }
    }


    public class IdEntity
    {
        public Int64 Id { get; set; }
    }

    public class ReferenceBase : IdEntity
    {
        public string Name { get; set; }
    }


    public class CountryReference : ReferenceBase
    {
        public bool IsForeign { get; set; }
        public bool IsCis { get; set; }
    }

    public class VehicleTypeReference : ReferenceBase
    {
    }

    public class TripTypeReference : ReferenceBase
    {
    }

    public class TripAimReference : ReferenceBase
    {
    }

    public class OwnExpenseOptionReference : ReferenceBase
    {
    }

    public class CityReference : ReferenceBase
    {
        public long CountryId { get; set; }
    }

    public class HotelReference : ReferenceBase {
        public long CityId { get; set; }
    }

    public class CostItemReference : LimitItem
    {
        //public string RoleCode { get; set; }

        public bool Approve { get; set; }
    }

    public class CarReference
    {
        public long Id { get; set; }
        public string Number { get; set; }
        public string Type { get; set; }
        public long HumanId { get; set; }
    }

    public class CarReferenceCollection : Collection<CarReference>
    {

        public CarReferenceCollection() { }

        public CarReferenceCollection(IEnumerable<CarReference> cars)
        {
            foreach (var item in cars)
                Add(item);
        }

    }

    public class FuelConsumptionReference : ReferenceBase
    {

        [JsonProperty(PropertyName = "CarType")]
        public string CarType { get; set; }
        [JsonProperty(PropertyName = "FuelGrade")]
        public string FuelGrade { get; set; }
        [JsonProperty(PropertyName = "ConsumptionSummer")]
        public float ConsumptionSummer { get; set; }
        [JsonProperty(PropertyName = "ConsumptionWinter")]
        public float ConsumptionWinter { get; set; }
    }
}
