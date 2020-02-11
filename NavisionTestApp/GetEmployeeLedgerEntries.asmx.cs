using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Xml.Serialization;

namespace NavTestApp
{
    /// <summary>
    /// Summary description for GetEmployeeLedgerEntries
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class GetEmployeeLedgerEntries : IGetEmployeeLedgerEntries_Binding
    {
        [return: XmlElement("GetRecIdFromKey_Result")]
        public string GetRecIdFromKey(string Key)
        {
            throw new NotImplementedException();
        }

       
        [return: XmlElement("IsUpdated_Result")]
        public bool IsUpdated(string Key)
        {
            throw new NotImplementedException();
        }

        [return: XmlElement("GetEmployeeLedgerEntries")]
        public global::GetEmployeeLedgerEntries Read(int Entry_No)
        {
            throw new NotImplementedException();
        }

        [return: XmlElement("GetEmployeeLedgerEntries")]
        public global::GetEmployeeLedgerEntries ReadByRecId(string recId)
        {
            throw new NotImplementedException();
        }

        [return: XmlArray("ReadMultiple_Result"), XmlElement(Type = typeof(string)),XmlArrayItem(IsNullable = false)]
        public global::GetEmployeeLedgerEntries[] ReadMultiple(GetEmployeeLedgerEntries_Filter[] filter, string bookmarkKey, int setSize)
        {


            return new global::GetEmployeeLedgerEntries[] {

            new global::GetEmployeeLedgerEntries {
                Key = "12;fAEAAACHSI8E9;8863480970;",
                Entry_No =298824,
                Entry_NoSpecified =true,
                Vendor_No ="R000000В336",
                Posting_Date = DateTime.Now.AddHours(-1),
                vleDescription = "",
                vlePaymPurp    ="",
                Posting_DateSpecified = true,
                Document_Type = Document_Type._blank_,
                Document_TypeSpecified =true,
                Document_No = "БС-101",
                Entry_Type = Entry_Type.Initial_Entry,
                Entry_TypeSpecified =true,
                Amount_LCY = -4000,
                Vendor_Posting_Group ="УГ1",
                Amount_LCYSpecified =true
            },
              new global::GetEmployeeLedgerEntries {
                Key = "12;fAEAAACHbZQE9;8863494190;",
                Entry_No =300141,
                Entry_NoSpecified =true,
                Posting_Date = DateTime.Now.AddHours(-1),
                Posting_DateSpecified = true,
                vleDescription="",
                vlePaymPurp ="",
                 Vendor_No ="R000000В336",
                Document_No = "БС-101",
                Document_Type = Document_Type._blank_,
                Document_TypeSpecified =true,
                Entry_Type = Entry_Type.Initial_Entry,
                Entry_TypeSpecified =true,
                Amount_LCY = 4150,
                Vendor_Posting_Group ="УГ1",
                Amount_LCYSpecified =true
                
            }




        };



        }
    }
}
