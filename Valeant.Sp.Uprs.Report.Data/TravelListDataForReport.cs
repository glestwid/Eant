using System;

namespace Valeant.Sp.Uprs.Report.Data
{
    public class TravelListDataForReport
    {

        public Int64 Number { get; set; }

        public DateTime Date { get; set; }

        public string CodeEmployee { get; set; }

        public string FIOEmployee { get; set; }

        public string CityEmployee { get; set; }

        public string Car { get; set; }

        public string CarRegNumber { get; set; }

        public decimal RefueledByCard { get; set; }

        public decimal? RefueledNotByCard { get; set; }

        public decimal SpentSum { get; set; }

        public decimal Spent { get; set; }

        public decimal? Overspent { get; set; }

        public decimal? OverspentSum { get; set; }

        public string Status { get; set; }

        public string StatusComment { get; set; }


    }

    public class OverspentDataForReport
    {
        public DateTime Date { get; set; }

        public string CostCenter { get; set; }

        public string FIOEmployee { get; set; }

        public decimal? Overspent { get; set; }

        public decimal? OverspentSum { get; set; }


    }
}
