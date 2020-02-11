using System;
using System.Net.Mail;
using System.Threading.Tasks;

namespace Valeant.Sp.UprsWeb.TaskExtension {
    public static class SmtpClientExtensions {
        public static Task SendTask(this SmtpClient smtpClient, MailMessage message, object userToken) {
            return SendTaskCore(smtpClient, userToken, tcs => smtpClient.SendAsync(message, tcs));
        }

        public static Task SendTask(this SmtpClient smtpClient, string from, string recipients, string subject, string body, object userToken) {
            return SendTaskCore(smtpClient, userToken, tcs => smtpClient.SendAsync(from, recipients, subject, body, tcs));
        }

        private static Task SendTaskCore(SmtpClient smtpClient, object userToken, Action<TaskCompletionSource<object>> sendAsync) {
            if (smtpClient == null) throw new ArgumentNullException(nameof(smtpClient));
            var tcs = new TaskCompletionSource<object>(userToken);
            SendCompletedEventHandler handler = null;
            handler = (sender, e) => Common.HandleCompletion(tcs, e, () => null, () => smtpClient.SendCompleted -= handler);
            smtpClient.SendCompleted += handler;
            try {
                sendAsync(tcs);
            }
            catch (Exception exc) {
                smtpClient.SendCompleted -= handler;
                tcs.TrySetException(exc);
            }
            return tcs.Task;
        }
    }
}