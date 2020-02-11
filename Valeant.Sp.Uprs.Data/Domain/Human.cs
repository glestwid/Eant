using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Xml.Serialization;

using Newtonsoft.Json;

using Valeant.Sp.Uprs.Data.Consts;



namespace Valeant.Sp.Uprs.Data.Domain
{
    public class Human
    {
        private static readonly TokenComparer _tokenComparer = new TokenComparer();
        private readonly Lazy<bool> _isAdministrator;
        private readonly Lazy<string[]> _departmentParentsCode;
 
        public Human() {
            _isAdministrator = new Lazy<bool>(GetIsAdministrator);
            _departmentParentsCode = new Lazy<string[]>(ReadDepartmentParentsCode);
            DeputyRange = new Range();
            Passport = new Passport();
            InternationalPassport = new InternationalPassport();
            IsCeo = false;
            IsFirstLevel = false;
        }

        public long Id { get; set; }
        public string Code { get; set; }
        public string FullName { get; set; }
        public string ClockNumber { get; set; }
        public string EmployeeStatus { get; set; }
        public string DepartmentStatus { get; set; }
        public string DepartmentCode { get; set; }
        public string[] DepartmentParentsCodes => _departmentParentsCode.Value;
        public string DepartmentName { get; set; }
        public string Email { get; set; }
        public string UserAccount { get; set; }
        public long? AssistantId { get; set; }
        public long? DeputyId { get; set; }
        public long? ManagerId { get; set; }
        public string AssistantName { get; set; }
        public string DeputyName { get; set; }
        public string ManagerName { get; set; }
        public string Manager2NdName { get; set; }
        public long? Manager2NdId { get; set; }
        public Range DeputyRange { get; set; }
        public string Position { get; set; }
        public string Costcenter { get; set; }
        public string CostcenterCode { get; set; }

        public long PositionId { get; set; }

        public long PositionGroupId { get; set; }

        public DateTime Birthday { get; set; }

        public string City { get; set; }

        /// <summary>
        /// Паспорт
        /// </summary>
        public Passport Passport { get; set; }

        /// <summary>
        /// Международный паспорт
        /// </summary>
        public InternationalPassport InternationalPassport { get; set; }

        public string Tel { get; set; }

        public string LoyaltyCards { get; set; }

        public long? FuelCard { get; set; }

        public string Organization { get; set; }

        public string Country { get; set; }

        [JsonIgnore]
        public bool IsCeo { get; set; }

        [JsonIgnore]
        public bool IsFirstLevel { get; set; }

        [JsonIgnore]
        public bool IsSimple => !IsCeo && !IsFirstLevel;

        [JsonIgnore]
        public List<Token> Tokens { get; set; } = new List<Token>();

        [JsonIgnore]
        public List<Token> AllTokens => GetAllTokens();

        public bool IsAdministrator => _isAdministrator.Value;

        public bool IsAccountant => Roles.Any(r => r.Code == RoleCode.Accountant);

        public bool IsSeniorAccountant => Roles.Any(r => r.Code == RoleCode.SeniorAccountant);

        public bool IsTravelCoordinator => Roles.Any(r => r.Code == RoleCode.TravelCoordinator);

        public bool IsHr => Roles.Any(r => r.Code == RoleCode.Hr);

        public RoleCollection Roles { get; set; }

        public bool FlagOne { get; set; }

        public DateTime? LastLoginTime { get; set; }


        [JsonIgnore]
        [XmlIgnore]
        public string NavisionCode {
            get {
                string[] tok = this.ClockNumber.Split(new char[] { '-' });
                return "R" + tok[1];
            }
        }

        private bool GetIsAdministrator()
        {
            return Roles.Any(x => x.IsAdministrator);
        }

        private string[] ReadDepartmentParentsCode() {
            return DataProvider.ReadParentDepartments(DepartmentCode);
        }

        public bool ContainsToken(string token)
        {
            return Tokens.Exists(x => x.Value.Equals(token, StringComparison.InvariantCultureIgnoreCase));
        }

        public bool ContainsTokens(IEnumerable<string> tokens)
        {
            return Tokens.Select(x => x.Value).Intersect(tokens).Any();
        }

        /// <summary>
        ///     Создает Human из БД
        /// </summary>
        /// <param name="reader"></param>
        /// <remarks>
        ///     Завист от хранимок [valeant].[ReadHumanById], [valeant].[ReadHuman], [valeant].[ReadHumans]
        ///     и[valeant].[ReaAdvanceCreator]
        /// </remarks>
        /// <returns></returns>
        public static Human FromSqlDataReader(SqlDataReader reader)
        {
            var human = new Human
            {
                Code = reader.GetString(0),
                FullName = reader.GetString(1),
                ClockNumber = reader.GetString(2),
                DepartmentStatus = reader.GetString(3),
                DepartmentCode = reader.GetString(4),
                DepartmentName = reader.GetString(5),
                UserAccount = reader.GetString(6),
                Email = reader.GetString(7),
                Id = reader.GetInt64(8),
                Position = reader.GetString(17),
                Costcenter = reader.GetString(18),
                Passport = new Passport
                {
                    DocumentIssuedBy = reader.GetString(19),
                    DocumentIssuedOn = reader.GetDateTime(20),
                    DocumentNumber = reader.GetString(21),
                    DocumentSeries = reader.GetString(22)
                },
                Organization = reader.GetString(25),
                Country = reader.GetString(26),
                Roles = new RoleCollection(),
                Tokens = new List<Token>()
            };
            if (!reader.IsDBNull(9)) human.AssistantId = reader.GetInt64(9);
            if (!reader.IsDBNull(10)) human.DeputyId = reader.GetInt64(10);
            if (!reader.IsDBNull(11)) human.AssistantName = reader.GetString(11);
            if (!reader.IsDBNull(12)) human.DeputyName = reader.GetString(12);
            if (!reader.IsDBNull(13)) human.ManagerName = reader.GetString(13);
            if (!reader.IsDBNull(14)) human.ManagerId = reader.GetInt64(14);
            if (!reader.IsDBNull(15)) human.Manager2NdName = reader.GetString(15);
            if (!reader.IsDBNull(16)) human.Manager2NdId = reader.GetInt64(16);
            human.InternationalPassport = new InternationalPassport();
            if (!reader.IsDBNull(23)) human.InternationalPassport.Number = reader.GetString(23);
            if (!reader.IsDBNull(24)) human.InternationalPassport.IssueDate = reader.GetDateTime(24);

            // часть профиля
            if (!reader.IsDBNull(27)) human.Tel = reader.GetString(27);
            if (!reader.IsDBNull(28)) human.LoyaltyCards = reader.GetString(28);
            if (!reader.IsDBNull(29)) human.InternationalPassport.FirstName = reader.GetString(29);
            if (!reader.IsDBNull(30)) human.InternationalPassport.LastName = reader.GetString(30);
            if (!reader.IsDBNull(31)) human.InternationalPassport.BirthPlace = reader.GetString(31);
            if (!reader.IsDBNull(32)) human.InternationalPassport.ExpiryDate = reader.GetDateTime(32);
            if (!reader.IsDBNull(33)) human.FuelCard = reader.GetInt64(33);

            if (!reader.IsDBNull(34)) human.CostcenterCode = reader.GetString(34);
            if (!reader.IsDBNull(35)) human.LastLoginTime = reader.GetDateTime(35);

            human.PositionId = reader.GetInt64(36);
            human.PositionGroupId = reader.GetInt64(37);

            //38 - EmployeeStatusId
            human.EmployeeStatus = reader.GetString(39);

            if (!reader.IsDBNull(40)) human.DeputyRange.StartDate = reader.GetDateTimeOffset(40);
            if (!reader.IsDBNull(41)) human.DeputyRange.EndDate = reader.GetDateTimeOffset(41);

            if (!reader.IsDBNull(42)) human.Birthday = reader.GetDateTime(42);
            if (!reader.IsDBNull(43)) human.City = reader.GetString(43);

            return human;
        }        

        private IEnumerable<Token> GetDinamicToken() {
            var dateNow = DateTimeOffset.Now;
            var deps = DataProvider.Humans.Where(
                x => x.DeputyId == Id &&
                     x.DeputyRange.StartDate.HasValue &&
                     x.DeputyRange.EndDate.HasValue &&
                     dateNow >= x.DeputyRange.StartDate.Value &&
                     dateNow <= x.DeputyRange.EndDate.Value);
            return deps.SelectMany(x => x.Tokens.Where(y => !y.Type.Equals("O*", StringComparison.CurrentCultureIgnoreCase)));
        }

        private List<Token> GetAllTokens() {
            return Tokens.Union(GetDinamicToken()).Distinct(_tokenComparer).ToList();
        }

        private class TokenComparer : IEqualityComparer<Token> {
            public bool Equals(Token x, Token y) {
                return x.Value.Equals(y.Value);
            }

            public int GetHashCode(Token obj) {
                return obj.Value.GetHashCode();
            }
        }
    }

    public class Passport
    {
        public string DocumentIssuedBy { get; set; }
        public DateTime DocumentIssuedOn { get; set; }
        public string DocumentNumber { get; set; }
        public string DocumentSeries { get; set; }
    }

    public class InternationalPassport
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Number { get; set; }
        public DateTime? IssueDate { get; set; }
        public DateTime? ExpiryDate { get; set; }
        public string BirthPlace { get; set; }
    }

    public class Range
    {
        private const string TimeFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'sszzz";

        [JsonIgnore]
        [XmlElement("xmlStartDate")]
        public string XmlStartDate
        {
            get
            {
                if (StartDate.HasValue) return StartDate.Value.ToString(TimeFormat);
                return null;
            }
            set { StartDate = DateTimeOffset.ParseExact(value, TimeFormat, null); }
        }

        [JsonIgnore]
        [XmlElement("xmlEndDate")]
        public string XmlEndDate
        {
            get
            {
                if (EndDate.HasValue) return EndDate.Value.ToString(TimeFormat);
                return null;
            }
            set { EndDate = DateTimeOffset.ParseExact(value, TimeFormat, null); }
        }


        [XmlIgnore]
        [JsonProperty(PropertyName = "startDate")]
        public DateTimeOffset? StartDate { get; set; }

        [XmlIgnore]
        [JsonProperty(PropertyName = "endDate")]
        public DateTimeOffset? EndDate { get; set; }
    }
}
