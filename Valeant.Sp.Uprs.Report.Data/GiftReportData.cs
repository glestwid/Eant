using System;


namespace Valeant.Sp.Uprs.Report.Data
{
    public class GiftReportData
    {
        //public long Id { get; set; }
        public long Number { get; set; }
        public DateTime Date { get; set; }
        
        public string Reason { get; set; }
        public string Description { get; set; }
        public string GiftReciever { get; set; }
        public string AgreementNumber { get; set; }
        public string Position { get; set;  }
        public DateTime? GiftDate { get; set; }
        public string HumanFrom { get; set; }
        public decimal Sum { get; set; }
        public string Organization { get; set; }

        public string Inn { get; set; }

        public bool OtherGiftsExist { get; set; }
        public string OtherGiftsComment { get; set; }

        public string ApprovedList { get; set; }
    }
}
