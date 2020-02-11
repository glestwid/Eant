using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Xml.Serialization;

namespace NavTestApp
{
    /// <summary>
    /// Summary description for GetCarList
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class GetCarList : IGetCarList_Binding
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

        [return: XmlElement("GetCarList")]
        public GetCarList Read(string No)
        {
            throw new NotImplementedException();
        }

        [return: XmlElement("GetCarList")]
        public GetCarList ReadByRecId(string recId)
        {
            throw new NotImplementedException();
        }

        [return: XmlArray("ReadMultiple_Result"), XmlArrayItem(IsNullable = false)]
        public global::GetCarList[] ReadMultiple(GetCarList_Filter[] filter, string bookmarkKey, int setSize)
        {
            return new global::GetCarList[]
            {
                new global::GetCarList
                {
                   Key = "20; 4BUAAAJ7BDAAMAAwADI = 9; 8952847370;",
                   No = "0002",
                   Description = "Автомобиль  KIA CEED",
                   Vehicle_Model = "KIA CEED",
                   Vehicle_Reg_No ="39 HB 777777",
                   Responsible_Employee ="0000001207"
                },

                new global::GetCarList
                {
                   Key = "20;4BUAAAJ7BDAAMAAwADQ=9;8952847390;",
                   No = "0002",
                   Description = "Автомобиль  KIA RIO",
                   Vehicle_Model = "KIA RIO",
                   Vehicle_Reg_No ="39 HB 777778",
                   Responsible_Employee ="0000001208"
                },
                new global::GetCarList
                {
                   Key = "20;4BUAAAJ7BDAAMAAwADQ=9;8952847391;",
                   No = "0003",
                   Description = "Автомобиль  KIA DE(JB/RIO) 0625",
                   Vehicle_Reg_No ="39 МУ 555555",
                   Responsible_Employee ="0000001207"
                },


            };


        }

        global::GetCarList IGetCarList_Binding.Read(string No)
        {
            throw new NotImplementedException();
        }

        global::GetCarList IGetCarList_Binding.ReadByRecId(string recId)
        {
            throw new NotImplementedException();
        }
    }
}
