using System;
using System.Globalization;
using System.Web.Mvc;
using Newtonsoft.Json;

namespace Valeant.Sp.UprsWeb.Controllers.Utils
{
    public class JsonDotNetResult : JsonResult
    {
        private static readonly JsonSerializerSettings Settings = new JsonSerializerSettings
        {
            DateTimeZoneHandling = DateTimeZoneHandling.Utc,
            Culture = new CultureInfo("ru-Ru"),
            Formatting = Formatting.Indented
        };

        public override void ExecuteResult(ControllerContext context)
        {
            if (JsonRequestBehavior == JsonRequestBehavior.DenyGet &&
                string.Equals(context.HttpContext.Request.HttpMethod, "GET", StringComparison.OrdinalIgnoreCase))
            {
                throw new InvalidOperationException("GET request not allowed");
            }

            var response = context.HttpContext.Response;

            response.ContentType = !string.IsNullOrEmpty(ContentType) ? ContentType : "application/json";

            if (ContentEncoding != null)
            {
                response.ContentEncoding = ContentEncoding;
            }

            if (Data == null)
            {
                return;
            }

            response.Write(JsonConvert.SerializeObject(Data, Settings));
        }
    }
}