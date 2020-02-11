using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.Controllers.Utils;

namespace Valeant.Sp.UprsWeb.Controllers.Entities
{
    public class TravelListData
    {
        public Int64 Id { get; set; }

        public Int64 Number { get; set; }
        public DateTime Date { get; set; }
        public string Car { get; set; }
        public decimal Sum { get; set; }
        public String Status { get; set; }

        [JsonProperty(PropertyName = "actions")]
        public List<string> Actions { get; set; }
    }

    public class TravelListDataEx : EntitiesBase
    {
        public TravelListDataEx()
        {
            Period = new Range {StartDate = DateTime.Now.StartOfDay(), EndDate = DateTime.Now.StartOfDay()};
            Limit = 0;
            FuelStart = 0;
            FuelEnd = 0;
            RefueledByCard = 0;
            RefueledByCardSum = 0;
            RefueledNotByCard = 0;
            RefueledNotByCardSum = 0;
            SpentSum = 0;
            FuelType = new FuelConsumptionReference {CarType = "", FuelGrade = "", ConsumptionSummer = 0f, ConsumptionWinter = 0f};
        }

        [JsonProperty(PropertyName = "date")]
        public Range Period { get; set; }

        [JsonProperty(PropertyName = "carData")]
        public CarReference CarData { get; set; }

        [JsonProperty(PropertyName = "fuelType")]
        public FuelConsumptionReference FuelType { get; set; }

        [JsonProperty(PropertyName = "fuelExpense")]
        public decimal FuelExpense { get; set; }

        [JsonProperty(PropertyName = "rate")]
        public decimal Rate { get; set; }

        [JsonProperty(PropertyName = "odometerStart")]
        public decimal OdometerStart { get; set; }

        [JsonProperty(PropertyName = "odometerEnd")]
        public decimal OdometerEnd { get; set; }

        [JsonProperty(PropertyName = "fuelStart")]
        public decimal FuelStart { get; set; }

        [JsonProperty(PropertyName = "fuelEnd")]
        public decimal FuelEnd { get; set; }

        [JsonProperty(PropertyName = "refueledByCard")]
        public decimal RefueledByCard { get; set; }

        [JsonProperty(PropertyName = "refueledByCardSum")]
        public decimal RefueledByCardSum { get; set; }

        [JsonProperty(PropertyName = "refueledNotByCard")]
        public decimal? RefueledNotByCard { get; set; }

        [JsonProperty(PropertyName = "refueledNotByCardSum")]
        public decimal? RefueledNotByCardSum { get; set; }

        [JsonProperty(PropertyName = "spent")]
        public decimal Spent { get; set; }

        [JsonProperty(PropertyName = "spentSum")]
        public decimal SpentSum { get; set; }

        [JsonProperty(PropertyName = "spentByExpense")]
        public decimal SpentByExpense { get; set; }

        [JsonProperty(PropertyName = "overSpent")]
        public decimal? OverSpent { get; set; }

        [JsonProperty(PropertyName = "limit")]
        public decimal? Limit { get; set; }

       
       
    }
}