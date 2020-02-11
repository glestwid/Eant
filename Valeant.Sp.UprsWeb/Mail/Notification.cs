using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
using System.Web.Hosting;
using RazorEngine;
using RazorEngine.Templating;
using Valeant.Sp.UprsWeb.Helpers;
using Encoding = System.Text.Encoding;

namespace Valeant.Sp.UprsWeb.Mail
{
    public sealed class EmailNotificationBuilder
    {
        private readonly Encoding _utf8 = new UTF8Encoding(false);

        private string CompileSubject(string templateName, string template, Type typeModel, object model)
        {
            return RazorCompile(templateName, template, typeModel, model);
        }

        private string CompileBody(string templateName, string template, Type typeeModel, object model)
        {
            return RazorCompile(templateName, template, typeeModel, model);
        }

        private string RazorCompile(string templateName, string template, Type typeModel, object model)
        {
            try
            {
                if (templateName == null)
                    return template;

                var path = HostingEnvironment.MapPath($"~/{AppSettings.NotificationTemplatesFolder}/{template}.html");
                if (path == null)
                    throw new FileNotFoundException(template);
                var templateString = File.ReadAllText(path);
                var result = Engine.Razor.RunCompile(templateString, templateName, typeModel, model);
                return result;
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        public MailMessage BuildEmailMessage(EmailNotificationBuilderData data, Type typeModel)
        {
            var msg = new MailMessage
            {
                From = data.FromMailAddress
            };
            foreach (var mailAddress in data.ToMailAddresses)
                msg.To.Add(mailAddress);
            if (data.CcMailAddresses != null && data.CcMailAddresses.Any())
                foreach (var mailAddress in data.CcMailAddresses)
                    msg.CC.Add(mailAddress);
            if (data.SubjectData != null)
                msg.Subject = CompileSubject(data.SubjectData.TemplateName, data.SubjectData.TemplatePath, typeModel,
                    data.SubjectData.Model);
            msg.IsBodyHtml = true;
            msg.AlternateViews.Add(GetHtmlView(data, typeModel));
            return msg;
        }

        private AlternateView GetHtmlView(EmailNotificationBuilderData data, Type typeModel)
        {
            try
            {
                var body = CompileBody(data.BodyData.TemplateName, data.BodyData.TemplatePath, typeModel,
                    data.BodyData.Model);
                var alternateView = AlternateView.CreateAlternateViewFromString(body, _utf8, MediaTypeNames.Text.Html);
                return alternateView;
            }
            catch (Exception exception)
            {
                throw;
            }
        }
    }

    public class EmailNotificationBuilderData
    {
        public EmailNotificationBuilderData()
        {
            SubjectData = new Subject();
            BodyData = new Body();
        }

        public MailAddress FromMailAddress { get; set; }
        public List<MailAddress> ToMailAddresses { get; set; }
        public List<MailAddress> CcMailAddresses { get; set; }

        public Subject SubjectData { get; set; }
        public Body BodyData { get; set; }

        public class Subject
        {
            public object Model { get; set; }
            public string TemplateName { get; set; }
            public string TemplatePath { get; set; }
        }

        public class Body
        {
            public object Model { get; set; }
            public string TemplateName { get; set; }
            public string TemplatePath { get; set; }
        }
    }
}