using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Threading.Tasks;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.NavisionGetEmployeeLedgerEntriesServiceReference;
using Valeant.Sp.UprsWeb.NavisionCarListServiceReference;
using Valeant.Sp.UprsWeb.NavisionCreateAdvanceStatementServiceReference;

using System.Runtime.ConstrainedExecution;
using System.Runtime.InteropServices;
using System.Security;
using System.Security.Permissions;
using System.Security.Principal;
using Microsoft.Win32.SafeHandles;
using System.ServiceModel.Channels;
using System.ServiceModel;
using Valeant.Sp.UprsWeb.Controllers.Entities;

namespace Valeant.Sp.UprsWeb.Controllers.Utils
{

    
    public class NavisionClient
    {

        private const string purchaserCode = "RU-EZ";
        private const string dateFormat = "yyyy-MM-dd";

        public static string userName = "";
        public static string domain = "VALEANT";
        public static string password = "";



        private static GetEmployeeLedgerEntries_PortClient GetEmployeeLedgerEntriesClient(string serviceURL)
        {

            var binding = new BasicHttpBinding(BasicHttpSecurityMode.TransportCredentialOnly);
            binding.Security.Transport.ClientCredentialType = HttpClientCredentialType.Windows;
            binding.Security.Transport.ProxyCredentialType = HttpProxyCredentialType.Windows;

            binding.Name = "binding";
            binding.Security.Message.ClientCredentialType = BasicHttpMessageCredentialType.UserName;

            binding.MaxReceivedMessageSize = 1000000;


            EndpointAddress adress = new EndpointAddress(serviceURL);

            GetEmployeeLedgerEntries_PortClient client = new GetEmployeeLedgerEntries_PortClient(binding, adress);


            client.ClientCredentials.Windows.AllowedImpersonationLevel = TokenImpersonationLevel.Impersonation;
            client.ClientCredentials.Windows.AllowNtlm = true;
      
            client.ClientCredentials.Windows.ClientCredential.UserName = userName ;
            client.ClientCredentials.Windows.ClientCredential.Password = password;



            return client;
        }

        private static GetCarList_PortClient GetCarListClient(string serviceURL)
        {

            var binding = new BasicHttpBinding(BasicHttpSecurityMode.TransportCredentialOnly);
            binding.Security.Transport.ClientCredentialType = HttpClientCredentialType.Ntlm;
            binding.Security.Transport.ProxyCredentialType = HttpProxyCredentialType.Windows;

            binding.Name = "binding";
            binding.Security.Message.ClientCredentialType = BasicHttpMessageCredentialType.UserName;

            binding.MaxReceivedMessageSize = 2000000;


            EndpointAddress adress = new EndpointAddress(serviceURL);

            GetCarList_PortClient client = new GetCarList_PortClient(binding, adress);


            client.ClientCredentials.Windows.AllowedImpersonationLevel = TokenImpersonationLevel.Impersonation;
            client.ClientCredentials.Windows.AllowNtlm = true;
         
            client.ClientCredentials.Windows.ClientCredential.UserName = userName;
            client.ClientCredentials.Windows.ClientCredential.Password = password;



            return client;
        }

        private static SPIntegration_BindingClient GetSPIntegrationClient(string serviceURL)
        {

            var binding = new BasicHttpBinding(BasicHttpSecurityMode.TransportCredentialOnly);
            binding.Security.Transport.ClientCredentialType = HttpClientCredentialType.Windows;
            binding.Security.Transport.ProxyCredentialType = HttpProxyCredentialType.Windows;

            binding.Name = "binding";
            binding.Security.Message.ClientCredentialType = BasicHttpMessageCredentialType.UserName;

            binding.MaxReceivedMessageSize = 1000000;


            EndpointAddress adress = new EndpointAddress(serviceURL);

            SPIntegration_BindingClient client = new SPIntegration_BindingClient(binding, adress);


            client.ClientCredentials.Windows.AllowedImpersonationLevel = TokenImpersonationLevel.Impersonation;
            client.ClientCredentials.Windows.AllowNtlm = true;
           
            client.ClientCredentials.Windows.ClientCredential.UserName = userName;
            client.ClientCredentials.Windows.ClientCredential.Password = password;



            return client;
        }

        public static List<EmployeeLedgerEntry> GetEmployeeLedgerEntries(string serviceURL, string employeeID)
        {


            try
            {

                GetEmployeeLedgerEntries_Filter filter = new GetEmployeeLedgerEntries_Filter();

                filter.Criteria = employeeID;

                filter.Field = GetEmployeeLedgerEntries_Fields.Vendor_No;


                return GetEmployeeLedgerEntries(serviceURL, new GetEmployeeLedgerEntries_Filter[] { filter });


            }
            catch (AggregateException exception)
            {
                throw (exception);
            }
            catch (Exception exception)
            {
                throw (exception);
            }



        }

        public static List<EmployeeLedgerEntry> GetEmployeeLedgerEntriesInc(string serviceURL, string employeeID, long startNo)
        {


            try
            {
              


                GetEmployeeLedgerEntries_Filter filterVendor = new GetEmployeeLedgerEntries_Filter();

                filterVendor.Criteria = employeeID;

                filterVendor.Field = GetEmployeeLedgerEntries_Fields.Vendor_No;

                GetEmployeeLedgerEntries_Filter filterNo = new GetEmployeeLedgerEntries_Filter();

                filterNo.Criteria = ">"+startNo.ToString();

                filterNo.Field = GetEmployeeLedgerEntries_Fields.Entry_No;



                return GetEmployeeLedgerEntries(serviceURL, new GetEmployeeLedgerEntries_Filter[] { filterVendor,filterNo });


            }
            catch (AggregateException exception)
            {
                throw (exception);
            }
            catch (Exception exception)
            {
                throw (exception);
            }



        }



        public static List<EmployeeLedgerEntry> GetEmployeeLedgerEntries(string serviceURL)
        {
            List<EmployeeLedgerEntry> result = new List<EmployeeLedgerEntry>();

            try
            {

                GetEmployeeLedgerEntries_PortClient service = GetEmployeeLedgerEntriesClient(serviceURL);

                return GetEmployeeLedgerEntries(serviceURL, new GetEmployeeLedgerEntries_Filter[] { });


            }
            catch (AggregateException exception)
            {
                throw (exception);
            }
            catch (Exception exception)
            {
                throw (exception);
            }



        }


        private static List<EmployeeLedgerEntry> GetEmployeeLedgerEntries(string serviceURL, GetEmployeeLedgerEntries_Filter[] filter)
        {
            List<EmployeeLedgerEntry> result = new List<EmployeeLedgerEntry>();

            try
            {

                GetEmployeeLedgerEntries_PortClient service = GetEmployeeLedgerEntriesClient(serviceURL);


                GetEmployeeLedgerEntries[] entries = service.ReadMultiple(filter, "", 0);



                foreach (GetEmployeeLedgerEntries entry in entries)
                {
                    EmployeeLedgerEntry employeeLedgerEntry = new EmployeeLedgerEntry();

                    employeeLedgerEntry.Id = entry.Entry_No;
                    employeeLedgerEntry.Number = entry.Entry_No;
                    employeeLedgerEntry.VendorLedgerEntryNo = entry.Vendor_Ledger_Entry_No;
                    employeeLedgerEntry.VendorNumber = entry.Vendor_No;
                    employeeLedgerEntry.Key = entry.Key;
                    employeeLedgerEntry.DocumentNumber = entry.Document_No;
                    employeeLedgerEntry.PostingDate = entry.Posting_Date;
                    employeeLedgerEntry.Description = entry.vleDescription == null ? "" : entry.vleDescription;
                    employeeLedgerEntry.PaymentPurpose = entry.vlePaymPurp == null ? "" : entry.vlePaymPurp;
                    employeeLedgerEntry.Ammount = entry.Amount_LCY;
                    employeeLedgerEntry.PostingGroup = entry.Vendor_Posting_Group == null ? "" : entry.Vendor_Posting_Group;
                    employeeLedgerEntry.EntryType = (int)entry.Entry_Type;

                    switch (entry.Document_Type)
                    {
                        case Document_Type._blank_:
                            employeeLedgerEntry.DocumentType = "";
                            break;
                        case Document_Type.Invoice:
                            employeeLedgerEntry.DocumentType = "Ав. отчёт";
                            break;
                        case Document_Type.Payment:
                            employeeLedgerEntry.DocumentType = "Оплата";
                            break;
                        case Document_Type.Refund:
                            employeeLedgerEntry.DocumentType = "Возврат средств";
                            break;
                        case Document_Type.Credit_Memo:
                            employeeLedgerEntry.DocumentType = "Кредит";
                            break;
                        case Document_Type.Finance_Charge_Memo:
                            employeeLedgerEntry.DocumentType = "Стоимость кредита";
                            break;
                        case Document_Type.Reminder:
                            employeeLedgerEntry.DocumentType = "Напоминание";
                            break;
                        default:
                            employeeLedgerEntry.DocumentType = "";
                            break;

                    }

                    result.Add(employeeLedgerEntry);

                }


            }
            catch (FaultException exception)
            {

                return result;
            }

            catch (AggregateException exception)
            {
                throw (exception);
            }
            catch (Exception exception)
            {
                throw (exception);
            }


            return result;
        }



        public static List<Car> GetCarList(string serviceURL)
        {
            List<Car> result = new List<Car>();

            try
            {

                GetCarList_PortClient client = GetCarListClient(serviceURL);


                GetCarList[] entries = client.ReadMultiple(new GetCarList_Filter[] { }, "", 0);



                foreach (GetCarList entry in entries)
                {


                    Human human = DataProvider.ReadHumanByCode(ConvertNavisionHumanCode(entry.Responsible_Employee));

                    if (human != null)
                    {
                        Car car = new Car();

                        car.Type = entry.Vehicle_Model != null ? entry.Vehicle_Model : GetCarType(entry.Description);
                        car.Number = entry.Vehicle_Reg_No != null ? entry.Vehicle_Reg_No : "";
                        car.Human = human;
                        result.Add(car);
                    }

                }


            }
            catch (AggregateException exception)
            {
                throw (exception);
            }
            catch (Exception exception)
            {
                throw (exception);
            }


            return result;
        }


        public static async Task<string> CreateAdvanceStatementHeaderAsync(AdvanceReportEntity data, AdvanceRepresentativeReportDataEx dataEx, string serviceURL)
        {


            CreateAdvanceStatementHeaderResponse res = null;

            try
            {


                SPIntegration_BindingClient client = GetSPIntegrationClient(serviceURL);


                res = await client.CreateAdvanceStatementHeaderAsync(dataEx.MainData.Person.NavisionCode, Cut(data.Type, 30), Cut(dataEx.MainData.Comment, 50), data.Date.ToString(dateFormat), purchaserCode);


                return res.return_value;



            }
            catch (AggregateException exception)
            {
                throw (exception);
            }
            catch (Exception exception)
            {
                throw (exception);
            }
            

        }


        public static async Task<string> CreateAdvanceStatementHeaderAsync(AdvanceReportEntity data, AdvanceTripReportDataEx dataEx, string serviceURL)
        {
            CreateAdvanceStatementHeaderResponse res = null;

            try
            {

                SPIntegration_BindingClient client = GetSPIntegrationClient(serviceURL);


                res = await client.CreateAdvanceStatementHeaderAsync(dataEx.MainData.Person.NavisionCode, Cut(data.Type, 30), Cut(dataEx.MainData.Comment, 50), data.Date.ToString(dateFormat), purchaserCode);


                return res.return_value;

            }
            catch (AggregateException exception)
            {
                throw (exception);
            }
            catch (Exception exception)
            {
                throw (exception);
            }




        }


        public static async Task<int> CreateAdvanceStatementLineAsync(string advNo, CostsRow costRow, string serviceURL)
        {
            List<int> lineNumbers = new List<int>();

            try
            {

                SPIntegration_BindingClient client = GetSPIntegrationClient(serviceURL);

                CreateAdvanceStatementLineResponse res = await client.CreateAdvanceStatementLineAsync(advNo, costRow.Credit, costRow.AccountGroup.AccountGroupName, Cut(costRow.DocumentType.Name, 50), costRow.Sum, costRow.DocumentNumber.ToString(), (costRow.Date != null) ? ((DateTime)costRow.Date).ToString(dateFormat) : null);

                return res.return_value;


            }
            catch (AggregateException exception)
            {
                throw (exception);
            }
            catch (Exception exception)
            {
                throw (exception);
            }




        }

        public static async Task<int> CreateAdvanceStatementLineAsync(string advNo, TripCostsRow costRow, string serviceURL)
        {
            List<int> lineNumbers = new List<int>();

            try
            {

                SPIntegration_BindingClient client = GetSPIntegrationClient(serviceURL);


                CreateAdvanceStatementLineResponse res = await client.CreateAdvanceStatementLineAsync(advNo, costRow.Credit, costRow.AccountGroup.AccountGroupName, Cut(costRow.DocumentType.Name, 50), costRow.Sum, costRow.DocumentNumber.ToString(), (costRow.Date != null) ? ((DateTime)costRow.Date).ToString(dateFormat) : null);

                return res.return_value;


            }
            catch (AggregateException exception)
            {
                throw (exception);
            }
            catch (Exception exception)
            {
                throw (exception);
            }

        }


        public static async Task<List<EmployeeLedgerEntry>> GetEmployeeLedgerEntriesAsync(string serviceURL, string employeeID)
        {

            return await Task.Run(() =>
            {
                return GetEmployeeLedgerEntries(serviceURL, employeeID);
            });

        }

        public static async Task<List<Car>> GetCarListAsync(string serviceURL)
        {

            return await Task.Run(() =>
            {
                return GetCarList(serviceURL);
            });

        }

        private static string ConvertNavisionHumanCode(string code)
        {

            return "01-" + code.Substring(1);

        }

        private static string GetCarType(string carDescription)
        {
            string[] tokens = carDescription.Split(new char[] { ' ' });
            string res = "";

            foreach (string tok in tokens)
            {
                int num;
                if (!tok.Equals("Автомобиль") && !int.TryParse(tok, out num))
                    res += tok.ToUpper() + " ";

            }
            return res.Trim();
        }


        private static string Cut(String s, int maxLength)
        {

            return (s == null ? "" : s.Substring(0, Math.Min(maxLength, s.Length)));

        }

    }
}