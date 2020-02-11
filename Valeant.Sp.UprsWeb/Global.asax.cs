using System;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Xml.Linq ;
using System.Xml.XPath;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Script.Serialization;

using NLog;
using System.Monads;
using AutoMapper;

using Valeant.Sp.UprsWeb.Controllers;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.Controllers.Entities;
using Valeant.Sp.Uprs.Report.Data;
using Valeant.Sp.UprsWeb.Security;



namespace Valeant.Sp.UprsWeb
{
    public class MvcApplication : System.Web.HttpApplication
    {
        private readonly Logger _logger = LogManager.GetCurrentClassLogger();


        protected void Application_Start()
        {
            Thread.CurrentThread.CurrentCulture = new CultureInfo("ru-RU");
            Thread.CurrentThread.CurrentUICulture = new CultureInfo("ru-RU");

            var stopWatchTimer = new Stopwatch();
            stopWatchTimer.Start();
            var pad = new String('#', 80);

            try
            {
                _logger.Info(pad);
                _logger.Info("Valeant Application Start");
                _logger.Info(Assembly.GetExecutingAssembly().FullName);
                _logger.Info("IsTraceEnabled {0}, IsDebugEnabled: {1}, IsInfoEnabled {2}, IsInfoEnabled {3}, IsErrorEnabled {4}, IsFatalEnabled {5}", _logger.IsTraceEnabled, _logger.IsDebugEnabled, _logger.IsInfoEnabled, _logger.IsInfoEnabled, _logger.IsErrorEnabled, _logger.IsFatalEnabled);
                _logger.Info(pad);

                AreaRegistration.RegisterAllAreas();
                FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
                RouteConfig.RegisterRoutes(RouteTable.Routes);
                BundleConfig.RegisterBundles(BundleTable.Bundles);
                StaticData.Seed();

                #region Fix for big files - http://stackoverflow.com/questions/26773830/during-ajax-post-in-mvc4-with-huge-data-the-system-throws-system-argumentexcepti
                JsonValueProviderFactory jsonValueProviderFactory = null;
                foreach (var factory in ValueProviderFactories.Factories)
                {
                    if (factory is JsonValueProviderFactory)
                    {
                        jsonValueProviderFactory = factory as JsonValueProviderFactory;
                    }
                }
                //remove the default JsonVAlueProviderFactory
                if (jsonValueProviderFactory != null) ValueProviderFactories.Factories.Remove(jsonValueProviderFactory);
                //add the custom one
                ValueProviderFactories.Factories.Add(new CustomJsonValueProviderFactory());
                #endregion

                Mapper.CreateMap<Human, HumanLight>()
                .ForMember (dest => dest.Code, e => e.MapFrom(s => s.ClockNumber))
                .ForMember(dest => dest.Roles, o => o.ResolveUsing( fa =>
                {
                    var rs = "";
                    var src= fa.Context.SourceValue as Human;
                    foreach ( var r in src.Roles   )
                    {
                        rs = rs + r.Name + ", ";
                    }
                    return rs;
                }))
                .ForMember (dest => dest.LastLoginTime, o=> o.ResolveUsing( fa =>
                {
                    var rs = "";
                    var src = fa.Context.SourceValue as Human;
                    if (src.LastLoginTime.HasValue )
                        rs = src.LastLoginTime.Value .ToString("dd.MM.yyyy HH:mm:ss");
                    return rs;
                }))
                .IgnoreAllNonExisting();

                Mapper.CreateMap<Advance, BusinessTripReportData>()
                    .ForMember(dest => dest.DocDate, opts => opts.MapFrom(src => src.Date.Date))
                    .ForMember(dest => dest.DocNum, opts => opts.MapFrom(src => src.Number))
                    .ForMember(dest => dest.FIO, opts => opts.MapFrom(src => src.FullName))
                    .ForMember(dest => dest.TabNum, opts => opts.ResolveUsing(fa =>
                    {
                        var rs = "";
                        var src = fa.Context.SourceValue as Advance;
                        var human = DataProvider.Humans.Where(x => x.Id == src.Creator ).SingleOrDefault();
                        rs = human.ClockNumber;
                        return rs;
                    }))
                    .ForMember(dest => dest.Destinations, opts => opts.ResolveUsing(fa =>
                    {
                        var rs = new List<BusinessTripReportDataDetails>();
                        var src = fa.Context.SourceValue as Advance;
                        var human = DataProvider.Humans.Where(x => x.Id == src.Creator).SingleOrDefault();
                        var dsts = src.Content.Descendants("DistinationRow");
                        var pos = src.Content.XPathSelectElement("MainData/Person/Position").Value;
                        foreach ( var xe in dsts)
                        {
                            var bd = DateTime.Parse(xe.XPathSelectElement("Period/xmlStartDate").Value);
                            var ed = DateTime.Parse(xe.XPathSelectElement("Period/xmlEndDate").Value);
                            rs.Add(new BusinessTripReportDataDetails() {
                                Position =pos,
                                BegDate = bd,
                                EndDate = ed,
                                NumOfDays = (ed-bd).Days,
                                EmployeeID = human.Id.ToString(),
                                DestinationLocation = xe.XPathSelectElement("City").Value + " " + xe.XPathSelectElement("Country/Name").Value,
                                Department = human.DepartmentName,
                                DestinationOrganization= xe.XPathSelectElement("Organization").Value,
                                Payee = "ООО «Валеант»",
                                Reason = "Приказ"
                            });
                        }
                        return rs;
                    })).IgnoreAllNonExisting();

                //https://github.com/AutoMapper/AutoMapper/issues/227
                //Mapper.CreateMap<GiftRequestMetadata, GiftRequestMetadataForReport>()
                //    .ForMember(dest => dest.Date, opts => opts.MapFrom(src => src.Date.HasValue))
                //    .ForMember(dest => dest.CodeEmployee, o => o.ResolveUsing((GiftRequestMetadata fa) =>
                //    {
                //        return "";
                //    }))
                //    .ForMember(dest => dest.FIOEmployee, opts => opts.MapFrom(src => src.Fio))
                //    .ForMember(dest => dest.CityEmployee, o => o.ResolveUsing((GiftRequestMetadata fa) =>
                //    {
                //        return "";
                //    }))
                //    .ForMember(dest => dest.FIOPerson, opts => opts.MapFrom(src => src.Fio))
                //    .ForMember(dest => dest.CompanyPerson, opts => opts.MapFrom(src => src.Organization))
                //    .ForMember(dest => dest.SumGift, opts => opts.MapFrom(src => src.Sum.ToString( )))
                //    .ForMember(dest => dest.Comments, o => o.ResolveUsing((GiftRequestMetadata fa) =>
                //    {
                //        return "";
                //    }))
                //    .IgnoreAllNonExisting();
                Mapper.CreateMap<AdvanceTripReportDataEx, MemorandumReportData>()
                    .ForMember(dest => dest.FIO, opts => opts.ResolveUsing((AdvanceTripReportDataEx fa) => {
                        var src = fa;
                        return src.MainData.Person.FullName;
                    }
                    ))
                    .ForMember(dest => dest.Position, opts => opts.ResolveUsing((AdvanceTripReportDataEx fa) => {
                        var src = fa;
                        return src.MainData.Person.Position;
                    }
                    ))
                    .ForMember(dest => dest.ServiceVehicle, opts => opts.ResolveUsing(fa =>
                    {
                        var src = fa.Context.SourceValue as AdvanceTripReportDataEx;
                        return src.MainData.ServiceVehicle;
                    }
                    ))
                    .ForMember(dest => dest.Scans, opts => opts.ResolveUsing(fa =>
                    {
                        var res = new MemorandumScans();
                        var src = fa.Context.SourceValue as AdvanceTripReportDataEx;
                        src.With(x1 => x1.ScanPdfsData).With(x2 => x2.Rows).ForEach(x3 =>
                        {
                            var t= Mapper.Map<TripRequestDataEx.ScanPdfRow, ScanPdfRowReportData>(x3);
                            res.Add(t);
                        });
                        //src.Content.With(r => r.XPathSelectElement("MainData/ScanPdfsData/Rows")).With(t => t.DescendantNodes()).Do(x =>
                        //{
                        //    res.Add(x.XPathSelectElement("Name").Value);
                        //});
                        return res;
                    }
                    ))
                    .IgnoreAllNonExisting();
                Mapper.CreateMap<TripRequestDataEx.ScanPdfRow, ScanPdfRowReportData>()
                    .IgnoreAllNonExisting();
                Mapper.CreateMap<Advance, MemorandumReportData>()
                    .ForMember(dest => dest.FIO, opts => opts.MapFrom(src => src.FullName))
                    .ForMember(dest => dest.Position, opts => opts.ResolveUsing(fa =>
                    {
                        var src = fa.Context.SourceValue as Advance;
                        var pos = src.Content.XPathSelectElement("MainData/Person/Position").Value;
                        return pos;
                    }
                    ))
                    .ForMember(dest => dest.OrderDate, opts => opts.ResolveUsing(fa =>
                    {
                        var src = fa.Context.SourceValue as Advance;
                        var ds = src.Content.XPathSelectElement("MainData/OrderData/Date").Value;
                        var d = DateTime.Parse(ds);
                        return d;
                    }
                    ))
                    .ForMember(dest => dest.OrderNo, opts => opts.ResolveUsing(fa =>
                    {
                        var src = fa.Context.SourceValue as Advance;
                        var ds = src.Content.XPathSelectElement("MainData/OrderData/OrderNumber").Value;
                        return ds;
                    }
                    ))
                    .ForMember(dest => dest.TripLocations, opts => opts.ResolveUsing(fa =>
                    {
                        var src = fa.Context.SourceValue as Advance;
                        var res = new StringBuilder();
                        src.Content.Descendants("DistinationRow").Do(xe =>
                                {
                                    res.AppendFormat("{0}, {1}, ", xe.XPathSelectElement("City").Value, xe.XPathSelectElement("Country/Name").Value);
                                });
                        return res.ToString ();
                    }
                    ))
                    //.ForMember(dest => dest.Scans, opts => opts.ResolveUsing(fa => {
                    //    var res = new List<string>();
                    //    var src = fa.Context.SourceValue as Advance;
                    //    src.Content.With(r => r.XPathSelectElement("MainData/ScanPdfsData/Rows")).With( t => t.DescendantNodes()).Do( x =>
                    //    {
                    //        res.Add(x.XPathSelectElement("Name").Value);
                    //    });
                    //    return res;
                    //}
                    //))
                    .IgnoreAllNonExisting();

                Mapper.CreateMap<TripRequestFullReportData, DestinationRowReportData>()
                    .IgnoreAllNonExisting();
                Mapper.CreateMap<DestinationRowReportData, TripRequestReportData>()
                    .ForMember(dest => dest.Destinations, opts => opts.ResolveUsing(fa =>
                    {
                        var src = fa.Context.SourceValue as DestinationRowReportData;
                        var ds = src.City + ", " + src.Country ;
                        return ds;
                    }
                    ))
                    .ForMember(dest => dest.FromToDate, opts => opts.ResolveUsing(fa =>
                    {
                        var src = fa.Context.SourceValue as DestinationRowReportData;
                        var ds = src.With (x => x.StartDate).With( x => x.Value ).DateTime.ToString("dd.MM.yyyy")  + " - " + src. With(x => x.EndDate).With(x => x.Value).DateTime.ToString("dd.MM.yyyy");
                        return ds;
                    }
                    ))
                    .IgnoreAllNonExisting();
                Mapper.CreateMap<TripRequestFullReportData, TripRequestReportData>()
                    .IgnoreAllNonExisting();

                Mapper.AssertConfigurationIsValid();

                _logger.Info("Application was successfully initialized");
            }
            catch (Exception ex)
            {
                _logger.Fatal(ex);
                throw;
            }
            finally
            {
                stopWatchTimer.Stop();
                _logger.Info("Elapsed time for application initialization (milliseconds): {0}",
                    stopWatchTimer.ElapsedMilliseconds);
                _logger.Info(pad);
            }
        }

        void Application_PostAuthenticateRequest()
        {
            if (Request.IsAuthenticated) {
                var id = System.Security.Claims.ClaimsPrincipal.Current;
                ClaimsFiller.FillAsync(id, Request);
                DataProvider.UpdateHumanLastLoginTime(id.Identity.Name);
            }
        }

        //protected void Application_AuthorizeRequest(Object sender, EventArgs e)
        //{
        //    var id = System.Security.Claims.ClaimsPrincipal.Current;
        //}

        protected void Application_Error(object sender, EventArgs e)
        {
            _logger.Fatal("Critical error was caught at global application error. Service Host Application was terminated. Sender: {0}",
                sender.GetType().Name);
            var lastError = Server.GetLastError();
            if (null != lastError)
                _logger.Fatal(lastError);
            Server.ClearError();
        }

        public sealed class CustomJsonValueProviderFactory : ValueProviderFactory
        {

            private static void AddToBackingStore(Dictionary<string, object> backingStore, string prefix, object value)
            {
                IDictionary<string, object> d = value as IDictionary<string, object>;
                if (d != null)
                {
                    foreach (KeyValuePair<string, object> entry in d)
                    {
                        AddToBackingStore(backingStore, MakePropertyKey(prefix, entry.Key), entry.Value);
                    }
                    return;
                }

                IList l = value as IList;
                if (l != null)
                {
                    for (int i = 0; i < l.Count; i++)
                    {
                        AddToBackingStore(backingStore, MakeArrayKey(prefix, i), l[i]);
                    }
                    return;
                }

                // primitive
                backingStore[prefix] = value;
            }

            private static object GetDeserializedObject(ControllerContext controllerContext)
            {
                if (!controllerContext.HttpContext.Request.ContentType.StartsWith("application/json", StringComparison.OrdinalIgnoreCase))
                {
                    // not JSON request
                    return null;
                }

                StreamReader reader = new StreamReader(controllerContext.HttpContext.Request.InputStream);
                string bodyText = reader.ReadToEnd();
                if (String.IsNullOrEmpty(bodyText))
                {
                    // no JSON data
                    return null;
                }

                JavaScriptSerializer serializer = new JavaScriptSerializer();
                serializer.MaxJsonLength = int.MaxValue; //increase MaxJsonLength.  This could be read in from the web.config if you prefer
                object jsonData = serializer.DeserializeObject(bodyText);
                return jsonData;
            }

            public override IValueProvider GetValueProvider(ControllerContext controllerContext)
            {
                if (controllerContext == null)
                {
                    throw new ArgumentNullException("controllerContext");
                }

                object jsonData = GetDeserializedObject(controllerContext);
                if (jsonData == null)
                {
                    return null;
                }

                Dictionary<string, object> backingStore = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                AddToBackingStore(backingStore, String.Empty, jsonData);
                return new DictionaryValueProvider<object>(backingStore, CultureInfo.CurrentCulture);
            }

            private static string MakeArrayKey(string prefix, int index)
            {
                return prefix + "[" + index.ToString(CultureInfo.InvariantCulture) + "]";
            }

            private static string MakePropertyKey(string prefix, string propertyName)
            {
                return (String.IsNullOrEmpty(prefix)) ? propertyName : prefix + "." + propertyName;
            }
        }

    }
}
