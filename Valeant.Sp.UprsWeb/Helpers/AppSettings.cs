using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace Valeant.Sp.UprsWeb.Helpers
{
    public static class AppSettings
    {
        public static string ReportTemplatesFolder => ConfigurationManager.AppSettings[nameof(ReportTemplatesFolder)];

        public static string NotificationTemplatesFolder => ConfigurationManager.AppSettings[nameof(NotificationTemplatesFolder)];
    }
}