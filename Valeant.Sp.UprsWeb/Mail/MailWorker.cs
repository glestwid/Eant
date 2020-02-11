using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Threading;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.UprsWeb.Helpers;
using Valeant.Sp.UprsWeb.TaskExtension;

namespace Valeant.Sp.UprsWeb.Mail {
    internal static class MailWorker
    {
        internal static void Queuing(object mailData, Type type, DocumentSaveResult.NotificationsData notificationData) {
            var emailBuilder = new EmailNotificationBuilder();
            var emailNotificationBuilderData = CreateEmailNotificationBuilderData(notificationData);
            emailNotificationBuilderData.BodyData.Model = Convert.ChangeType(mailData, type);
            emailNotificationBuilderData.SubjectData.Model = emailNotificationBuilderData.BodyData.Model;
            var message = emailBuilder.BuildEmailMessage(emailNotificationBuilderData, type);
            ThreadPool.UnsafeQueueUserWorkItem(Send, message);
        }

        private static void Send(object message) {
            Mailer.Send((MailMessage)message);
        }

        private static EmailNotificationBuilderData CreateEmailNotificationBuilderData(DocumentSaveResult.NotificationsData notificationData)
        {
            var from = DataProvider.GetSetting("SmtpSenderAddress");
            var fromName = DataProvider.GetSetting("SmtpSenderDisplayName");
            return new EmailNotificationBuilderData
            {
                BodyData = { TemplateName = notificationData.Notification.TemplateMessage, TemplatePath = notificationData.Notification.TemplateMessage },
                SubjectData = { TemplateName = notificationData.Notification.TemplateSubject, TemplatePath = notificationData.Notification.TemplateSubject },
                FromMailAddress = new MailAddress(from, fromName),
                ToMailAddresses = notificationData.Resipients.Select(x => new MailAddress(x)).ToList()
            };
        }
    }
}