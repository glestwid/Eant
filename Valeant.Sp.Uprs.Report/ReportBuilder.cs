using System;
using System.Linq;
using System.Drawing;
using System.Drawing.Printing;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Threading;

using Microsoft.Reporting.WebForms;


namespace Valeant.Sp.Uprs.Report {
    public static class ReportBuilder {
        public static Tuple<string, byte[]> BuildReport(string rdlcName, IEnumerable<object> data, string format, bool useA4Landscape = false) {
            var currentCulture = Thread.CurrentThread.CurrentCulture;
            var c = CultureInfo.GetCultureInfo("RU-ru");
            Thread.CurrentThread.CurrentCulture = c;
            Warning[] warnings;
            string[] streamIds;
            string mimeType;
            string encoding;
            string extension;
            var reportViewer = new ReportViewer {ProcessingMode = ProcessingMode.Local};
            if (useA4Landscape)
            {
                var ps = new PageSettings();
                ps.PaperSize = new PaperSize()
                {
                    PaperName = "A4Landscape",
                    Height = 897,
                    Width = 1197
                };

                // НЕ НАХОДИТ A4 Landscape СРЕДИ СТАНДАРТНЫХ РАЗМЕРОВ БУМАГИ
                //PrinterSettings psp = new PrinterSettings();
                //IEnumerable<PaperSize> paperSizes = psp.PaperSizes.Cast<PaperSize>();
                //PaperSize sizeA4Land = paperSizes.First<PaperSize>(size => size.Kind == PaperKind.A4Rotated); // setting paper size to A4 size
                //PaperSize sizeA4 = paperSizes.First<PaperSize>(size => size.Kind == PaperKind.A4); // setting paper size to A4 size
                //if (useA4Landscape)
                //    ps.PaperSize = sizeA4Land;
                //else
                //    ps.PaperSize = sizeA4;
                reportViewer.SetPageSettings(ps);
            }
            reportViewer.LocalReport.ReportPath = rdlcName;
            int i = 0;
            var sn = reportViewer.LocalReport.GetDataSourceNames();
            foreach (var d  in data)
            {
                if (d is IEnumerable)
                    reportViewer.LocalReport.DataSources.Add(
                        new ReportDataSource(sn[i], d));
                i++;
            }
            if (sn.Count == 1)
                reportViewer.LocalReport.DataSources.Add( new ReportDataSource(sn[0], data));
            var res = reportViewer.LocalReport.Render(format, null, out mimeType, out encoding, out extension, out streamIds, out warnings);
            Thread.CurrentThread.CurrentCulture = currentCulture;
            return new Tuple<string, byte[]>(mimeType, res);
        }
    }
}
