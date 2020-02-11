using System;
using System.Linq;
using Newtonsoft.Json;
using Valeant.Sp.Uprs.Data.Domain;

namespace Valeant.Sp.UprsWeb.Controllers.Entities {
    public class TripRequestData {
        public Int64 Id { get; set; }

        public Int64 Number { get; set; }
        public DateTime FromDate { get; set; }
        public string DocumentType { get; set; }
        public int Sum { get; set; }
        public string Status { get; set; }
        public string TripTypeName { get; set; }
        public bool ServiceVehicle { get; set; }

        public bool IsOnlyDailyCostsExist { get; set; }

        public DateTime DateStart { get; set; }


    }

    public class TripRequestDataEx : EntitiesBase {
        public TripRequestDataEx() {
            MainData = new RequestMainData();
            DestinationsData = new RowOptionsDataCollection<DistinationRow, DistinationOptions>();
            DailyCostsData = new RowOptionsDataCollection<DailyCostsRow, DailyCostsOptions>();
            TicketRequestsData = new RowOptionsDataCollection<TicketRequestRow, TicketRequestOptions>();
            HotelRequestsData = new RowOptionsDataCollection<HotelRequestRow, HotelRequestOptions>();
            TrasferRequestsData = new RowOptionsDataCollection<TransferRequestRow, TransferRequestOptions>();
            ScanPdfsData = new RowOptionsDataCollection<ScanPdfRow, ScanPdfOptions>();
            Date = DateTime.Now;
        }
        [JsonProperty(PropertyName = "requestMainData")]
        public RequestMainData MainData { get; set; }
        [JsonProperty(PropertyName = "destinationsData")]
        public RowOptionsDataCollection<DistinationRow, DistinationOptions> DestinationsData { get; set; }
        [JsonProperty(PropertyName = "dailyCostsData")]
        public RowOptionsDataCollection<DailyCostsRow, DailyCostsOptions> DailyCostsData { get; set; }
        [JsonProperty(PropertyName = "ticketRequestsData")]
        public RowOptionsDataCollection<TicketRequestRow, TicketRequestOptions> TicketRequestsData { get; set; }
        [JsonProperty(PropertyName = "hotelRequestsData")]
        public RowOptionsDataCollection<HotelRequestRow, HotelRequestOptions> HotelRequestsData { get; set; }
        [JsonProperty(PropertyName = "trasferRequestsData")]
        public RowOptionsDataCollection<TransferRequestRow, TransferRequestOptions> TrasferRequestsData { get; set; }
        [JsonProperty(PropertyName = "scanPdfsData")]
        public RowOptionsDataCollection<ScanPdfRow, ScanPdfOptions> ScanPdfsData { get; set; }
        public class DistinationRow: IRow {
            [JsonProperty(PropertyName = "index")]
            public int Order { get; set; }

            [JsonProperty(PropertyName = "country")]
            public CountryReference Country { get; set; }

            [JsonProperty(PropertyName = "city")]
            public string City { get; set; }

            [JsonProperty(PropertyName = "organization")]
            public string Organization { get; set; }

            [JsonProperty(PropertyName = "date")]
            public Range Period { get; set; }
        }
        public class DistinationOptions: IOptions
        {
            [JsonProperty(PropertyName = "before")]
            public OwnExpense Before { get; set; }
            [JsonProperty(PropertyName = "after")]
            public OwnExpense After { get; set; }
            [JsonProperty(PropertyName = "isWeekendDayTrip")]
            public bool IsWeekendDayTrip { get; set; }
        }

        public class OwnExpense
        {
            [JsonProperty(PropertyName = "ownExpense")]
            public bool OwnExpenseUsed { get; set; }

            [JsonProperty(PropertyName = "days")]
            public int Days { get; set; }
        }

        public class DailyCostsRow: IRow
        {
            [JsonProperty(PropertyName = "index")]
            public int Order { get; set; }

            [JsonProperty(PropertyName = "city")]
            public string City { get; set; }

            [JsonProperty(PropertyName = "dinner")]
            public bool IsDinner { get; set; }

            [JsonProperty(PropertyName = "supper")]
            public bool IsSupper { get; set; }

            [JsonProperty(PropertyName = "baseCost")]
            public Int64 BaseCost { get; set; }

            [JsonProperty(PropertyName = "cost")]
            public Int64 Cost { get; set; }

            [JsonProperty(PropertyName = "date")]
            public DateTime Date { get; set; }
        }
        public class DailyCostsOptions : IOptions
        {
            public DailyCostsOptions()
            {
                Sum = 0;
            }

            [JsonProperty(PropertyName = "entry")]
            public DateTime? EntryDate { get; set; }

            [JsonProperty(PropertyName = "departure")]
            public DateTime? DepartureDate { get; set; }

            [JsonProperty(PropertyName = "sum")]
            public decimal Sum { get; set; }
        }
        public class TicketRequestRow: IRow
        {
            [JsonProperty(PropertyName = "index")]
            public int Order { get; set; }

            [JsonProperty(PropertyName = "date")]
            public DateTime Date { get; set; }

            [JsonProperty(PropertyName = "from")]
            public string From { get; set; }

            [JsonProperty(PropertyName = "to")]
            public string To { get; set; }

            [JsonProperty(PropertyName = "ticketDescription")]
            public string TicketDescription { get; set; }

            [JsonProperty(PropertyName = "noBaggage")]
            public bool NoBaggage { get; set; }

            [JsonProperty(PropertyName = "comment")]
            public string Comment { get; set; }
        }
        public class TicketRequestOptions : IOptions
        {
            [JsonProperty(PropertyName = "isNeed")]
            public bool IsNeed { get; set; }
        }
        public class HotelRequestRow : IRow
        {
            [JsonProperty(PropertyName = "index")]
            public int Order { get; set; }

            [JsonProperty(PropertyName = "country")]
            public CountryReference Country { get; set; }

            [JsonProperty(PropertyName = "city")]
            public string City { get; set; }

            [JsonProperty(PropertyName = "hotel")]
            public string Hotel { get; set; }

            [JsonProperty(PropertyName = "startDate")]
            public DateTime StartDate { get; set; }

            [JsonProperty(PropertyName = "endDate")]
            public DateTime EndDate { get; set; }
        }
        public class HotelRequestOptions : IOptions
        {
            [JsonProperty(PropertyName = "isNeed")]
            public bool IsNeed { get; set; }
        }
        public class TransferRequestRow : IRow
        {
            [JsonProperty(PropertyName = "index")]
            public int Order { get; set; }

            [JsonProperty(PropertyName = "date")]
            public DateTime Date { get; set; }

            [JsonProperty(PropertyName = "from")]
            public string From { get; set; }

            [JsonProperty(PropertyName = "to")]
            public string To { get; set; }
        }
        public class TransferRequestOptions : IOptions
        {
            [JsonProperty(PropertyName = "isNeed")]
            public bool IsNeed { get; set; }
        }
        public class ScanPdfRow : IRow {
            [JsonProperty(PropertyName = "index")]
            public int Order { get; set; }

            [JsonProperty(PropertyName = "name")]
            public string Name { get; set; }

            [JsonProperty(PropertyName = "data")]
            public byte[] Data { get; set; }

            [JsonProperty(PropertyName = "url")]
            public string Url { get; set; }

            [JsonProperty(PropertyName = "mime")]
            public string Mime { get; set; }

            [JsonProperty(PropertyName = "urn")]
            public string Urn { get; set; }

            [JsonProperty(PropertyName = "key")]
            public int Key { get; set; }
        }
        public class ScanPdfOptions : IOptions
        {
            [JsonProperty(PropertyName = "comment")]
            public string Comment { get; set; }

            [JsonProperty(PropertyName = "overLimit")]
            public bool OverLimit { get; set; }
        }
        public class RequestMainData
        {
            public RequestMainData()
            {
                OrderData = new OrderData();
            }
            
            [JsonProperty(PropertyName = "tripType")]
            public TripTypeReference TripType { get; set; }

            [JsonProperty(PropertyName = "tripAim")]
            public TripAimReference TripAim { get; set; }

            [JsonProperty(PropertyName = "vehicle")]
            public VehicleTypeReference VahicleType { get; set; }

            [JsonProperty(PropertyName = "comment")]
            public string Comment { get; set; }

            [JsonProperty(PropertyName = "person")]
            public Human Person { get; set; }

            [JsonProperty(PropertyName = "orderData")]
            public OrderData OrderData { get; set; }
        }
        public class OrderData
        {
            [JsonProperty(PropertyName = "orderNum")]
            public Int64? OrderNumber { get; set; }

            [JsonProperty(PropertyName = "date")]
            public DateTime? Date { get; set; }

            [JsonProperty(PropertyName = "isApproved")]
            public bool IsApproved { get; set; }
        }
        [JsonProperty(PropertyName = "flagTravelCoordinator")]
        public bool FlagTravelCoordinator { get; set; }

        public bool UpdateFlagTravelCoordinator(bool flag) {
            FlagTravelCoordinator = flag;
            return flag;
        }

        public bool IsForeignCountry(Human owner) {
            return !DestinationsData.Rows.Any(x => x.Country.Name.Equals(owner.Country, StringComparison.CurrentCultureIgnoreCase));
        }
        public bool IsDateGr(int interval) {
            var first = DestinationsData.Rows.First().Period.StartDate;
            return (first.Value - DateTimeOffset.Now).Days > 14;
        }
    }
}