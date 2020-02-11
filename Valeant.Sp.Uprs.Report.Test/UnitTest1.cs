using System;
using System.Linq;
using System.Drawing;
using System.Drawing.Printing;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Threading;

using Microsoft.Reporting.WebForms;
using Microsoft.VisualStudio.TestTools.UnitTesting;

using Valeant.Sp.Uprs.Report.Data;



namespace Valeant.Sp.Uprs.Report.Test
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void AdvanceReportBuild() {
            var advanceReport = new AdvancesReportData
                                {
                                    new AdvanceReportData
                                    {
                                        Date = DateTime.Now,
                                        HumanFrom = "Ковалева Владимира Юрьевича",
                                        HumanTo = "Эмиру Валеанта Коннолли Джону",
                                        PositionFrom = "протирщика хозяйских алмазов",
                                        Id = 1,
                                        SummRub = 1234,
                                        SummKop = 0
                                    }
                                };

            var advanceReportDetails = new AdvanceReportDataDetails
                                       {
                                           new AdvanceReportDataDetail
                                           {
                                               Id = 1,
                                               AdvanceId = 1,
                                               CostItem =
                                                   "Чиcтящая паста",
                                               Sum = 10000
                                           },
                                           new AdvanceReportDataDetail
                                           {
                                               Id = 2,
                                               AdvanceId = 2,
                                               CostItem = "Чистящая ветошь специальная",
                                               Sum = 2000
                                           }
                                       };

            //ReportBuilder.BuildReport(@"C:\Valeant\Valeant\Valeant.Sp.Uprs.Report\Rdlc\AdvanceReport.rdlc", advanceReport, advanceReportDetails);
        }

        [TestMethod]
        public void TestPageA4()
        {
            try
            {
                var reportViewer = new ReportViewer { ProcessingMode = ProcessingMode.Local };
                var ps = new PageSettings();
                //ps.PaperSize = new PaperSize();

                PrinterSettings psp = new PrinterSettings();
                IEnumerable<PaperSize> paperSizes = psp.PaperSizes.Cast<PaperSize>();
                PaperSize sizeA4 = paperSizes.First<PaperSize>(size => size.Kind == PaperKind.A4); // setting paper size to A4 size
                ps.PaperSize = sizeA4;
                reportViewer.SetPageSettings(ps);
            }
            catch (Exception ex)
            {
                Assert.Fail("Формат A4 не поддерживается");
            }
        }

        [TestMethod]
        public void TestPageA4Landscape()
        {
            try
            {
                var reportViewer = new ReportViewer { ProcessingMode = ProcessingMode.Local };
                var ps = new PageSettings();
                //ps.PaperSize = new PaperSize();

                PrinterSettings psp = new PrinterSettings();
                IEnumerable<PaperSize> paperSizes = psp.PaperSizes.Cast<PaperSize>();
                PaperSize sizeA4Land = paperSizes.First<PaperSize>(size => size.Kind == PaperKind.A4Rotated); // setting paper size to A4 size
                ps.PaperSize = sizeA4Land;
                reportViewer.SetPageSettings(ps);
            }
            catch (Exception ex)
            {
                Assert.Fail("Формат A4 Landscape не поддерживается");
            }
        }

        [TestMethod]
        public void TestPageA4Custom()
        {
            try
            {
                var reportViewer = new ReportViewer { ProcessingMode = ProcessingMode.Local };
                var ps = new PageSettings();
                ps.PaperSize = new PaperSize()
                {
                    PaperName = "A4Landscape",
                    Height = 897,
                    Width = 1197
                };

                reportViewer.SetPageSettings(ps);
            }
            catch (Exception ex)
            {
                Assert.Fail("Формат A4 Custom не поддерживается");
            }
        }
    }
}
