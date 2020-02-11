using System;
using System.Collections.Concurrent;
using System.Threading.Tasks;
using System.Xml.Linq;
using Valeant.Sp.Uprs.Data.Domain;

namespace Valeant.Sp.UprsWeb.Helpers {
    public static class ContentFactory {
        public static ConcurrentDictionary<string, Type> Types = new ConcurrentDictionary<string, Type>();
        public static ConcurrentDictionary<string, Func<XElement, Task<object[]>>> ReportConverters = new ConcurrentDictionary<string, Func<XElement, Task<object[]>>>();
        public static ConcurrentDictionary<string, string> Reports = new ConcurrentDictionary<string, string>();
        public static void Register(string name, Type type, Func<XElement, Task<object[]>> reportConeverter, string report) {
            Types.TryAdd(name, type);
            ReportConverters.TryAdd(name, reportConeverter);
            Reports.TryAdd(name, report);
        }

        public static Type Get(string name) {
            Type type;
            Types.TryGetValue(name, out type);
            return type;
        }

        public static Task<object[]> ConvertReport(string name, XElement content) {
            Func<XElement, Task<object[]>> func;
            return ReportConverters.TryGetValue(name, out func) ? func(content) : null;
        }

        public static string Report(string name) {
            string report;
            Reports.TryGetValue(name, out report);
            return report;
        }
    }
}