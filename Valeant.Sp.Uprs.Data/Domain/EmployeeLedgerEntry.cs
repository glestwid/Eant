using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Valeant.Sp.Uprs.Data.Domain
{

    public enum EntryType
    {

        /// <remarks/>
        Initial_Entry,

        /// <remarks/>
        Application,

        /// <remarks/>
        Unrealized_Loss,

        /// <remarks/>
        Unrealized_Gain,

        /// <remarks/>
        Realized_Loss,

        /// <remarks/>
        Realized_Gain,

        /// <remarks/>
        Payment_Discount,

        /// <remarks/>
        Payment_Discount_VAT_Excl,

        /// <remarks/>
        Payment_Discount_VAT_Adjustment,

        /// <remarks/>
        Appln_Rounding,

        /// <remarks/>
        Correction_of_Remaining_Amount,

        /// <remarks/>
        Payment_Tolerance,

        /// <remarks/>
        Payment_Discount_Tolerance,

        /// <remarks/>
        Payment_Tolerance_VAT_Excl,

        /// <remarks/>
        Payment_Tolerance_VAT_Adjustment,

        /// <remarks/>
        Payment_Discount_Tolerance_VAT_Excl,

        /// <remarks/>
        Payment_Discount_Tolerance_VAT_Adjustment,

        /// <remarks/>
        US_GAAP_Unrealized_Loss,

        /// <remarks/>
        US_GAAP_Unrealized_Gain,

        /// <remarks/>
        US_GAAP_Realized_Loss,

        /// <remarks/>
        US_GAAP_Realized_Gain,
    }


    public class EmployeeLedgerEntry
    {

            public Int64 Id { get; set; }

            public Int64 Number { get; set; }

            public Int64 VendorLedgerEntryNo { get; set; }

            public String Key { get; set; }
           
            public DateTime PostingDate { get; set; }

            public String Description { get; set; }

            public String PaymentPurpose { get; set; }

            public String PostingGroup { get; set; }

            public string VendorNumber { get; set; }

            public String DocumentNumber { get; set; }

            public String DocumentType { get; set; }
        
            public decimal Ammount { get; set; }

            public decimal AmmountSum { get; set; }

            public int EntryType;

            public string EmployeeName {
            get{
                string clockNumber = "01-" + VendorNumber.Substring(1);

                var humans = DataProvider.Humans.Where(x => x.ClockNumber.Equals(clockNumber));

                    if (humans.Any())
                      return humans.ElementAt(0).FullName;
                    else
                     return null;
            }
          }

        public string FormatedDate
        {
            get
            {
               
               return PostingDate.ToShortDateString();
            }
        }


    }
    
}
