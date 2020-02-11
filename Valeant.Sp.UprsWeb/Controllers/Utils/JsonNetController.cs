using System;
using System.IO;
using System.Text;
using System.Web.Mvc;
using Newtonsoft.Json;
using Valeant.Sp.UprsWeb.Extensions;

namespace Valeant.Sp.UprsWeb.Controllers.Utils
{
    public abstract class JsonNetController : Controller
    {
        protected override JsonResult Json(object data, string contentType, Encoding contentEncoding, JsonRequestBehavior behavior)
        {
            return new JsonDotNetResult
            {
                Data = data,
                ContentType = contentType,
                ContentEncoding = contentEncoding,
                JsonRequestBehavior = behavior
            };
        }

        protected DateTime ToUserOffset(DateTime dt)
        {
            if (TempData.ContainsKey("TimeZoneOffset"))
            {
                var userOffset = (TimeSpan)TempData["TimeZoneOffset"];
                return dt.ToOffset(userOffset);
            }
            return dt;
        }

        protected DateTimeOffset ToUserOffset(DateTimeOffset dt)
        {
            if (TempData.ContainsKey("TimeZoneOffset"))
            {
                var userOffset = (TimeSpan)TempData["TimeZoneOffset"];
                return dt.ToOffset(userOffset);
            }
            return dt;
        }
    }

    internal class JsonNetModelBinder : IModelBinder
    {
        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            controllerContext.HttpContext.Request.InputStream.Position = 0;
            var stream = controllerContext.RequestContext.HttpContext.Request.InputStream;
            var readStream = new StreamReader(stream, Encoding.UTF8);
            var json = readStream.ReadToEnd();
            return JsonConvert.DeserializeObject(json, bindingContext.ModelType);
        }
    }

    internal class StringBinder: IModelBinder
    {
        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            controllerContext.HttpContext.Request.InputStream.Position = 0;
            var stream = controllerContext.RequestContext.HttpContext.Request.InputStream;
            var readStream = new StreamReader(stream, Encoding.UTF8);
            return readStream.ReadToEnd();
        }
    }
}