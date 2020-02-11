using System;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using NLog;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.UprsWeb.TaskExtension;

namespace Valeant.Sp.UprsWeb.Mail {
    public static class Mailer
    {
        private static readonly Logger _logger = LogManager.GetCurrentClassLogger();

        private static readonly int Port;
        private static readonly string Address;
        private static readonly string Account;
        private static readonly string Password;
        static Mailer() {
            var portStr = DataProvider.GetSetting("SmtpPort");
            if (portStr != null) Port = int.Parse(portStr);
            Address = DataProvider.GetSetting("SmtpAddress");
            Account = DataProvider.GetSetting("SmtpAccountName");
            Password = DataProvider.GetSetting("SmtpPassword");
        }
        public static void Send(MailMessage mail) {
            try {
                using (var client = new SmtpClient
                                    {
                                        Port = Port,
                                        DeliveryMethod = SmtpDeliveryMethod.Network,
                                        UseDefaultCredentials = false,
                                        Credentials = new NetworkCredential(Account, Password),
                                        Host = Address
                                    }) {
                    client.Send(mail);
                }
            }
            catch (Exception ex) {
                for (var e = ex; e != null; e = e.InnerException) _logger.Error(e);
               ///throw ex;
            }
        }
    }
}