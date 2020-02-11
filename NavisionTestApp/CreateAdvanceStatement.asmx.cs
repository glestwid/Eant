using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Xml.Serialization;
using NLog;

namespace NavTestApp
{
    /// <summary>
    /// Summary description for CreateAdvanceStatement
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class CreateAdvanceStatement : ISPIntegration_Binding
    {
        readonly Logger _logger = LogManager.GetCurrentClassLogger();

        [return: XmlElement("return_value")]
        public string CreateAdvanceStatementHeader(string employeeNo, string advancePurpose, string postingDescription,  DateTime postingDate, string purchaserCode)
        {
            _logger.Info("employeeNo {0}", employeeNo);
            _logger.Info("advancePurpose {0}", advancePurpose);
            _logger.Info("postingDescription {0}", postingDescription);
            _logger.Info("postingDate {0}",postingDate.ToShortDateString() );
            _logger.Info("purchaserCode {0}", purchaserCode);



            return (new Guid()).ToString();
        }

        [return: XmlElement("return_value")]
        public int CreateAdvanceStatementLine(string advStNo, string gLAccountNo, string vendorPostingGroup, string descriptionTxt, decimal amountInclVAT, string purchDocNo,  DateTime purchDocDate)
        {

            _logger.Info("advStNo {0}",advStNo);
            _logger.Info("gLAccountNo {0}", gLAccountNo);
            _logger.Info("vendorPostingGroup {0}", vendorPostingGroup);
            _logger.Info("amountInclVAT {0}", amountInclVAT);
            _logger.Info("purchDocNo {0}", purchDocNo);
            _logger.Info("purchDocDate {0}", purchDocDate.ToShortDateString());

            return 1000;
        }

       
    }
}
