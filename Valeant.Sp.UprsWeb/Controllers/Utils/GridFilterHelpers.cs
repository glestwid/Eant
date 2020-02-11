using System;

namespace Valeant.Sp.UprsWeb.Controllers.Utils
{
    public static class GridFilterHelpers
    {
        public static FilterRange GetRange(string dateRangeFilter)
        {
            DateTimeOffset dateStart;
            DateTimeOffset dateEnd;
            var currentDate = DateTimeOffset.Now;
            var quarter = (int)Math.Ceiling(currentDate.Month / 3.0);
            switch (dateRangeFilter.ToLower())
            {
                case "месяц":
                    dateStart = new DateTimeOffset(new DateTime(currentDate.Year, currentDate.Month, 1));
                    dateEnd = dateStart.AddMonths(1).AddTicks(-1);
                    break;
                case "квартал":
                    dateStart = new DateTimeOffset(new DateTime(currentDate.Year, (3 * quarter) - 2, 1));
                    dateEnd = dateStart.AddMonths(3).AddTicks(-1);
                    break;
                case "год":
                    return GetCurrentYear(currentDate);
                default:
                    dateStart = new DateTimeOffset(new DateTime(1900, 1, 1));
                    dateEnd = DateTimeOffset.MaxValue;
                    break;
            }

            return new FilterRange
            {
                DateStart = dateStart,
                DateEnd = dateEnd
            };
        }

        public static FilterRange GetCurrentYear(this DateTimeOffset current)
        {
            var dateStart = new DateTimeOffset(new DateTime(current.Year, 1, 1));
            var dateEnd = dateStart.AddYears(1).AddTicks(-1);
            return new FilterRange
            {
                DateStart = dateStart,
                DateEnd = dateEnd
            };
        }
        
        public class FilterRange
        {
            public DateTimeOffset DateStart { get; set; }
            public DateTimeOffset DateEnd { get; set; }
        }

        public static DateTime EndOfDay(this DateTime date)
        {
            return new DateTime(date.Year, date.Month, date.Day, 23, 59, 59, 999);
        }

        public static DateTime StartOfDay(this DateTime date)
        {
            return new DateTime(date.Year, date.Month, date.Day, 0, 0, 0, 0);
        }
    }
}