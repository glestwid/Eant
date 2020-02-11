using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Xml.Linq;
using Dapper;
using Microsoft.SqlServer.Server;
using NLog;
using Valeant.Sp.Uprs.Data.Consts;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.Uprs.Data.Domain.Expenditure;
using Valeant.Sp.Uprs.Data.Matrix;
using Valeant.Sp.Uprs.Data.Query;

namespace Valeant.Sp.Uprs.Data
{
    public partial class DataProvider
    {
        private static readonly Logger _logger = LogManager.GetCurrentClassLogger();
        private static readonly ReaderWriterLockSlim Locker;
        private static long _version;
        private static Dictionary<string, Human> _humansDictionary;
        private static Dictionary<long, Human> _humansByIdDictionary;
        private static HumanCollection _humans;
        public static Dictionary<string, BuildToken> BuildTokens;
        private static readonly Dictionary<string, Dictionary<long, StateMapItemVersion2>> StateMap;
        private static readonly Dictionary<long, NotificationItem> Notification;
        private static readonly Dictionary<long, BlockAccessListVersion2> AccessListBlock;
        private static readonly Dictionary<string, string> Mime;

        static DataProvider()
        {
            try
            {
                BuildTokens = new Dictionary<string, BuildToken>
                {
                    {"D*", BuildDeputyToken},
                    {"M1*", BuildManager1StToken},
                    {"M2*", BuildManager2NdToken},
                    {"O*", BuildOwnerToken},
                    {"F*", BuildFirstLevelToken}
                };
                ConnectionString = GetConnectionString();
                Locker = new ReaderWriterLockSlim(LockRecursionPolicy.SupportsRecursion);
                _version = GetStructureVersion("Structure");
                _humans = ReadHumanCollection();
                _humansDictionary = _humans.ToDictionary(x => x.UserAccount.ToLower(), x => x);
                _humansByIdDictionary = Humans.ToDictionary(x => x.Id, x => x);
                //TokensCollection = ReadTokenMapItemCollection();
                //StateMapItemCollection = ReadStateMapItemCollection();
                //SelectorItemCollection = ReadSelectorItemCollection();
                //HistoryMapItemCollection = ReadHistoryMapItemCollection();
                Settings = ReadSettings((string)null);
                HumansPrepare();
                var documentTypes = ReadDocumentType();
                DocumentTypesByName = documentTypes.ToDictionary(x => x.Value, x => x.Key);
                Mime = ReadMime();
                Matrixs = ReadMatrix();
                _logger.Info("DataProvider initialization - DONE");
            }
            catch (Exception ex)
            {
                _logger.Error(ex);
                throw;
            }
        }

        public static string ConnectionString { get; set; }

        public static HumanCollection Humans
        {
            get
            {
                CheckStructureVersin();
                return _humans;
            }
        }

        public static Settings Settings { get; set; }

        public static Dictionary<long, MatrixVersion3> Matrixs { get; }

        public static Dictionary<string, long> DocumentTypesByName { get; }

        public static NotificationItem GetNotificationItem(long id)
        {
            return Notification.ContainsKey(id) ? Notification[id] : null;
        }

        public static BlockAccessListVersion2 GetBlockAccessListVersion2(long id)
        {
            if (AccessListBlock.ContainsKey(id))
                return AccessListBlock[id];
            return null;
        }

        public static string GetSetting(string name)
        {
            return Settings.ContainsKey(name) ? Settings[name].Value : null;
        }

        public static string GetMime(string extension)
        {
            if (Mime.ContainsKey(extension))
                return Mime[extension];
            return "application/octet-stream";
        }

        public static MatrixVersion3 GetMatrix(long documentId)
        {
            return Matrixs[documentId];
        }

        public static Dictionary<long, StateMapItemVersion2> GetStateMap(string documentType)
        {
            if (!StateMap.ContainsKey(documentType)) throw new Exception($"State map \"{documentType}\" not found.");
            return StateMap[documentType];
        }

        public Task<int> RegisterDepartmentStructure(
            IEnumerable<CountryType> country,
            IEnumerable<OrganizationType> organization,
            IEnumerable<CostcenterType> costcenter,
            IEnumerable<DepartmentType> department,
            IEnumerable<DepartmentConditionType> departmentcondition,
            IEnumerable<EmployeePositionType> emploeeposition,
            IEnumerable<HumanType> human,
            IEnumerable<EmployeeType> employee,
            string defaultRole)
        {
            return ExecuteNoQueryAsync("[valeant].[RegisterDepartmentStructure]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@country", SqlDbType.Structured)
                    {
                        TypeName = SqlCountry.TypeName,
                        Value = country != null && country.Any() ? new SqlCountry(country) : null
                    },
                    new SqlParameter("@organization", SqlDbType.Structured)
                    {
                        TypeName = SqlOrganization.TypeName,
                        Value = organization != null && organization.Any() ? new SqlOrganization(organization) : null
                    },
                    new SqlParameter("@costcenter", SqlDbType.Structured)
                    {
                        TypeName = SqlCostcenter.TypeName,
                        Value = costcenter != null && costcenter.Any() ? new SqlCostcenter(costcenter) : null
                    },
                    new SqlParameter("@department", SqlDbType.Structured)
                    {
                        TypeName = SqlDepartment.TypeName,
                        Value = department != null && department.Any() ? new SqlDepartment(department) : null
                    },
                    new SqlParameter("@departmentcondition", SqlDbType.Structured)
                    {
                        TypeName = SqlDepartmentCondition.TypeName,
                        Value =
                            departmentcondition != null && departmentcondition.Any()
                                ? new SqlDepartmentCondition(departmentcondition)
                                : null
                    },
                    new SqlParameter("@employeeposition", SqlDbType.Structured)
                    {
                        TypeName = SqlEmploeePosition.TypeName,
                        Value =
                            emploeeposition != null && emploeeposition.Any()
                                ? new SqlEmploeePosition(emploeeposition)
                                : null
                    },
                    new SqlParameter("@human", SqlDbType.Structured)
                    {
                        TypeName = SqlHuman.TypeName,
                        Value = human != null && human.Any() ? new SqlHuman(human) : null
                    },
                    new SqlParameter("@employee", SqlDbType.Structured)
                    {
                        TypeName = SqlEmployee.TypeName,
                        Value = employee != null && employee.Any() ? new SqlEmployee(employee) : null
                    },
                    new SqlParameter("@defaultRole", SqlDbType.NVarChar, 255)
                    {
                        Value = defaultRole
                    }
                });
        }

        public Task<DepartmentStatusesStrToLong> ReadDepartmentStatuses()
        {
            return ReadObjectAsync(null, "SELECT [Value], [Id] FROM [valeant].[departmentstatus]", CommandType.Text,
                null, DepartmentStatuses);
        }

        public Task<EmployeeStatusesStrToLong> ReadEmployeeStatuses()
        {
            return ReadObjectAsync(null, "SELECT [Value], [Id] FROM [valeant].[employeestatus]", CommandType.Text, null,
                EmployeeStatuses);
        }

        public static async Task<Tuple<long, long>> InsertOrUpdateAdvance(long? id, DateTimeOffset dateadvance,
            string type, decimal sum, string state,
            string datatype, XElement content, long creator, DateTimeOffset datecreate, TokenCollection tokens,
            string action,
            string comment, string approvalSheet, bool clearapprovalsheet, string processSubType,
            MetadataCollection metadata = null)
        {
            var parameterId = new SqlParameter("@id", SqlDbType.BigInt)
            {
                Value = id.HasValue ? (object)id.Value : DBNull.Value,
                Direction = ParameterDirection.InputOutput
            };
            var number = new SqlParameter("@number", SqlDbType.BigInt)
            {
                Direction = ParameterDirection.Output
            };
            await ExecuteNoQueryAsync("[valeant].[InsertOrUpdateAdvance]", CommandType.StoredProcedure,
                new[]
                {
                    parameterId,
                    number,
                    new SqlParameter("@dateadvance", SqlDbType.DateTimeOffset) {Value = dateadvance},
                    new SqlParameter("@type", SqlDbType.NVarChar, 255) {Value = type},
                    new SqlParameter("@sum", SqlDbType.Money) {Value = sum},
                    new SqlParameter("@state", SqlDbType.NVarChar, 255) {Value = state},
                    new SqlParameter("@datatype", SqlDbType.NVarChar, 1024) {Value = datatype},
                    new SqlParameter("@content", SqlDbType.Xml) {Value = content.ToString()},
                    new SqlParameter("@creator", SqlDbType.BigInt) {Value = creator},
                    new SqlParameter("@datecreate", SqlDbType.DateTimeOffset) {Value = datecreate},
                    new SqlParameter("@comment", SqlDbType.NVarChar, 7000)
                    {
                        Value = comment == null ? DBNull.Value : (object) comment
                    },
                    new SqlParameter("@action", SqlDbType.NVarChar, 1024)
                    {
                        Value = action != null ? (object) action : DBNull.Value
                    },
                    new SqlParameter("@approvalSheet", SqlDbType.NVarChar, 4000)
                    {
                        Value = approvalSheet != null ? (object) approvalSheet : DBNull.Value
                    },
                    new SqlParameter("@clearapprovalsheet", SqlDbType.Bit) {Value = clearapprovalsheet},
                    new SqlParameter("@processsubtype", SqlDbType.NVarChar, 2) {Value = processSubType},
                    new SqlParameter("@tokens", SqlDbType.Structured)
                    {
                        TypeName = SqlTokenTable.TypeName,
                        Value = tokens == null || !tokens.Any() ? null : new SqlTokenTable(tokens)
                    },
                    new SqlParameter("@metadata", SqlDbType.Structured)
                    {
                        TypeName = SqlMetadataValuesCollection.TypeName,
                        Value = metadata == null || !metadata.Any() ? null : new SqlMetadataValuesCollection(metadata)
                    }
                }
                );
            return new Tuple<long, long>((long)parameterId.Value, (long)number.Value);
        }

        public static Task<AdvanceCollectionVersion3> ReadAllAdvanceVersion3Async(long? id, DateTimeOffset dateStart,
            DateTimeOffset dateEnd, string[] tokens)
        {
            return ReadObjectAsync(null, "[valeant].[readadvanceall_version_3]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = id.HasValue ? (object) id.Value : DBNull.Value},
                    new SqlParameter("@dateStart", SqlDbType.DateTimeOffset) {Value = dateStart},
                    new SqlParameter("@dateEnd", SqlDbType.DateTimeOffset) {Value = dateEnd},
                    new SqlParameter("@tokens", SqlDbType.Structured)
                    {
                        TypeName = SqlNvarchar255Table.TypeName,
                        Value = tokens == null || !tokens.Any() ? null : new SqlNvarchar255Table(tokens)
                    }
                }, ReadAdvanceVersion3Async);
        }

        public static Task<AdvanceCollectionVersion3> ReadAdvanceVersion3Async(long? id, string advanceTypeName,
            DateTimeOffset dateStart, DateTimeOffset dateEnd, string[] tokens)
        {
            return ReadObjectAsync(null, "[valeant].[readadvance_version_3]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = id.HasValue ? (object) id.Value : DBNull.Value},
                    new SqlParameter("@documentType", SqlDbType.NVarChar, 255) {Value = advanceTypeName},
                    new SqlParameter("@dateStart", SqlDbType.DateTimeOffset) {Value = dateStart},
                    new SqlParameter("@dateEnd", SqlDbType.DateTimeOffset) {Value = dateEnd},
                    new SqlParameter("@tokens", SqlDbType.Structured)
                    {
                        TypeName = SqlNvarchar255Table.TypeName,
                        Value = tokens == null || !tokens.Any() ? null : new SqlNvarchar255Table(tokens)
                    }
                }, ReadAdvanceVersion3Async);
        }

        public static Task<AdvanceCollectionVersion3> ReadAdvanceFilterVersion3Async(long? id, string filter,
            string advanceTypeName, DateTimeOffset dateStart, DateTimeOffset dateEnd, string[] tokens)
        {
            return ReadObjectAsync(null, "[valeant].[readadvancefilter_version_3]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = id.HasValue ? (object) id.Value : DBNull.Value},
                    new SqlParameter("@documentType", SqlDbType.NVarChar, 255) {Value = advanceTypeName},
                    new SqlParameter("@statusName", SqlDbType.NVarChar, 255) {Value = filter},
                    new SqlParameter("@dateStart", SqlDbType.DateTimeOffset) {Value = dateStart},
                    new SqlParameter("@dateEnd", SqlDbType.DateTimeOffset) {Value = dateEnd},
                    new SqlParameter("@tokens", SqlDbType.Structured)
                    {
                        TypeName = SqlNvarchar255Table.TypeName,
                        Value = tokens == null || !tokens.Any() ? null : new SqlNvarchar255Table(tokens)
                    }
                }, ReadAdvanceVersion3Async);
        }

        public static Task<AdvanceCollectionVersion3> ReadAllAdvanceFilterVersion3Async(long? id, string filter,
            DateTimeOffset dateStart, DateTimeOffset dateEnd, string[] tokens)
        {
            return ReadObjectAsync(null, "[valeant].[readadvanceallfilter_version_3]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = id.HasValue ? (object) id.Value : DBNull.Value},
                    new SqlParameter("@statusName", SqlDbType.NVarChar, 255) {Value = filter},
                    new SqlParameter("@dateStart", SqlDbType.DateTimeOffset) {Value = dateStart},
                    new SqlParameter("@dateEnd", SqlDbType.DateTimeOffset) {Value = dateEnd},
                    new SqlParameter("@tokens", SqlDbType.Structured)
                    {
                        TypeName = SqlNvarchar255Table.TypeName,
                        Value = tokens == null || !tokens.Any() ? null : new SqlNvarchar255Table(tokens)
                    }
                }, ReadAdvanceVersion3Async);
        }


        public static Task<AdvanceCollectionVersion3> GetTripRequestsForAdvanceReport(string[] tokens)
        {
            return ReadObjectAsync(null, "[valeant].[GetTripRequestsForAdvanceReport]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@tokens", SqlDbType.Structured)
                    {
                        TypeName = SqlNvarchar255Table.TypeName,
                        Value = tokens == null || !tokens.Any() ? null : new SqlNvarchar255Table(tokens)
                    }
                }, ReadAdvanceVersion3Async);
        }

        public static Task<AdvanceCollectionVersion3> GetDocumentsByQueryAsync(DocumentQuery query)
        {
            var sql = @"select * from valeant.Documents d where 
                        (@StartDate is null or CreationDate >= @StartDate)
                    and (@EndDate is null or CreationDate <= @EndDate)
                    and DocumentStateName in (select * from @DocumentStates)
                    and DocumentTypeName in (select * from @DocumentTypes)
                    and (@CreatorId is null or CreatorId = @CreatorId)
                    AND (
                     SELECT TOP 1 [aa].Id
				        FROM [valeant].[advance] [aa]
				        INNER JOIN [valeant].[states_version_3] [ss] ON ss.[Id] = [aa].[state]
				        WHERE [ss].name != 'Утверждена'
				        AND aa.type  = 4
			        ) IS NOT NULL";

            return ReadObjectAsync(null, sql, CommandType.Text,
                new[]
                {
                    new SqlParameter("@StartDate", SqlDbType.DateTimeOffset) {Value = query.StartDate.HasValue ? (object) query.StartDate.Value : DBNull.Value},
                    new SqlParameter("@EndDate", SqlDbType.DateTimeOffset) {Value = query.EndDate.HasValue ? (object) query.EndDate.Value : DBNull.Value},
                    new SqlParameter("@CreatorId", SqlDbType.BigInt) {Value = query.CreatorId.HasValue ? (object) query.CreatorId.Value : DBNull.Value},
                    new SqlParameter("@DocumentTypes", SqlDbType.Structured)
                    {
                        TypeName = SqlNvarchar255Table.TypeName,
                        Value = new SqlNvarchar255Table(query.DocumentTypes)
                    },
                    new SqlParameter("@DocumentStates", SqlDbType.Structured)
                    {
                        TypeName = SqlNvarchar255Table.TypeName,
                        Value = new SqlNvarchar255Table(query.DocumentStates)
                    }

                }, ReadAdvanceVersion3Async);
        }

        public static async Task<Advance> ReadAdvanceSimple(long advanceId)
        {
            var advances = await ReadObjectAsync(null, "[valeant].[ReadAdvanceSimple]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@advanceId", SqlDbType.BigInt) {Value = advanceId}
                }, ReadAdvance);
            return advances.Any() ? advances.First() : null;
        }

        public static TokenMapItemCollection ReadTokenMapItemCollection()
        {
            return ReadObject(null, "[valeant].[ReadTokenMaps]", CommandType.StoredProcedure, null,
                ReadTokenMapItemCollection);
        }

        public static StateMapItemCollection ReadStateMapItemCollection()
        {
            return ReadObject(null, "[valeant].[ReadStateMap]", CommandType.StoredProcedure, null,
                ReadStateMapItemCollection);
        }

        public static SelectorItemCollection ReadSelectorItemCollection()
        {
            return ReadObject(null, "[valeant].[ReadSelectors]", CommandType.StoredProcedure, null,
                ReadSelectorItemCollection);
        }

        public static HistoryMapItemCollection ReadHistoryMapItemCollection()
        {
            return ReadObject(null, "[valeant].[ReadHistoryMap]", CommandType.StoredProcedure, null,
                ReadHistoryMapItemCollection);
        }

        public static Task<HistoryItemCollection> ReadHistoryItemCollectionAsync(long id, string documentName)
        {
            return ReadObjectAsync(null, "[valeant].[ReadHIstory]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = id},
                    new SqlParameter("@document", SqlDbType.NVarChar, 255) {Value = documentName}
                }, ReadHistoryItemCollectionAsync);
        }

        public static Task<ApprovedHistoryItemCollectionVersion3> ReadApprovedHistoryItemCollectionAsync(long id,
            string documentName)
        {
            return ReadObjectAsync(null, "[valeant].[readapprovedhistory_version_3]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = id},
                    new SqlParameter("@document", SqlDbType.NVarChar, 255) {Value = documentName}
                }, ReadApprovedHistoryItemCollectionAsync);
        }


        public static Task<CostcenterCollection> ReadCostcenterAsync()
        {
            return ReadObjectAsync(null, "[valeant].[ReadCostcenter]", CommandType.StoredProcedure, null, ReadCostcenterAsync);
        }


        public static Dictionary<string, string> ReadMime()
        {
            return ReadObject(null, "[valeant].[readmime_version_2]", CommandType.StoredProcedure, null, ReadMime);
        }
        public static string[] ReadParentDepartments(string departmentCode)
        {
            var list = ReadObject(null, "[valeant].[readparentdepartments]", CommandType.StoredProcedure,
                new[] {
                    new SqlParameter("@code", SqlDbType.NVarChar, 20) {Value = departmentCode}
                }, ReadStrings);
            return list.ToArray();
        }

        private static List<string> ReadStrings(SqlDataReader sqlDataReader)
        {
            var list = new List<string>();
            if (!sqlDataReader.HasRows) return list;
            while (sqlDataReader.Read()) list.Add(sqlDataReader.GetString(0));
            return list;
        }

        public static string CheckCostItem(string costName)
        {
            var result = new SqlParameter("@result", SqlDbType.NVarChar, 16)
            {
                Direction = ParameterDirection.Output,
                Value = null
            };
            ExecuteNoQuery(null, "[valeant].[CheckCostItem]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@name", SqlDbType.NVarChar, 1024) {Value = costName},
                    result
                });
            return result.Value == DBNull.Value ? null : (string)result.Value;
        }

        public static Settings ReadSettings(string name)
        {
            return ReadObject(null, "[valeant].[ReadSettings]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@name", SqlDbType.NVarChar, 50)
                    {
                        Value = name == null ? DBNull.Value : (object) name
                    }
                }, ReadSettings);
        }

        public static Task<List<string>> UpdateAttachments(long advance, IEnumerable<AttachmentVersion2> attachments)
        {
            var attachmentsList = attachments.ToList();
            return ReadObjectAsync(null, "[valeant].[updateattachments]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@advance", SqlDbType.BigInt) {Value = advance},
                    new SqlParameter("@attachment", SqlDbType.Structured)
                    {
                        TypeName = SqlAttachmentsVersion2.TypeName,
                        Value = attachmentsList.Any() ? new SqlAttachmentsVersion2(attachmentsList) : null
                    }
                }, ReadUpdateAttachments);
        }

        public static Task<AttachmentVersion2> ReadAttachment(string urn)
        {
            return ReadObjectAsync(null, "[valeant].[readattachment]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@urn", SqlDbType.NVarChar, 255) {Value = urn}
                }, ReadAttachment);
        }

        private static Dictionary<long, string> ReadDocumentType()
        {
            return ReadObject(null, "[valeant].[readdocumenttype_version_2]", CommandType.StoredProcedure, null,
                ReadDocumentType);
        }

        private static Dictionary<long, MatrixVersion3> ReadMatrix()
        {
            return ReadObject(null, "[valeant].[read_matrix_all_info_version_3]", CommandType.StoredProcedure, null,
                ReadMatrix);
        }

        public static Task<AdvanceContent> ReadAdvanceContent(long id)
        {
            return ReadObjectAsync(null, "[valeant].[readadvancecontent_version_3]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = id}
                }, ReadAdvanceContent);
        }

        private static async Task<DepartmentStatusesStrToLong> DepartmentStatuses(SqlDataReader reader)
        {
            var result = new DepartmentStatusesStrToLong();
            if (!reader.HasRows) return result;
            while (await reader.ReadAsync())
            {
                result.Add(reader.GetString(0), reader.GetInt64(1));
            }
            return result;
        }

        private static async Task<EmployeeStatusesStrToLong> EmployeeStatuses(SqlDataReader reader)
        {
            var result = new EmployeeStatusesStrToLong();
            if (!reader.HasRows) return result;
            while (await reader.ReadAsync())
            {
                result.Add(reader.GetString(0), reader.GetInt64(1));
            }
            return result;
        }



        public static async Task<CarCollection> ReadCarCollectionAsync(SqlDataReader reader)
        {
            var entities = new Dictionary<long, Car>();
            if (!reader.HasRows) return new CarCollection();
            while (await reader.ReadAsync())
            {
                var car = new Car
                {
                    Id = reader.GetInt64(0),
                    Number = reader.GetString(2),
                    Type = reader.GetString(3)
                };


                car.Human = await ReadHumanByIdAsync(reader.GetInt64(1));

                entities.Add(car.Id, car);
            }

            return new CarCollection(entities.Values);
        }

        public static Task<CarCollection> ReadUserCarsAsync(Human human)
        {
            var sql = $"SELECT * FROM [valeant].[Car] WHERE [human]={human.Id}";
            return ReadObjectAsync(null, sql, CommandType.Text, null, ReadCarCollectionAsync);
        }

        public static Task<CarCollection> ReadCarCollectionAsync()
        {
            return ReadObjectAsync(null, "[valeant].[ReadCars]", CommandType.StoredProcedure, null,
                ReadCarCollectionAsync);
        }

        public static Task<long> ReadMaxEmployeeLedgerTransactionNoAsync()
        {
            return ReadObjectAsync<long>(null, "select MAX([EntryNumber]) from[valeant].[employeeledgerentry]", CommandType.Text,
                null, ReadMaxEmployeeLedgerTransactionNoAsync);
        }

        public static async Task<long> ReadMaxEmployeeLedgerTransactionNoAsync(
            SqlDataReader reader)
        {
            if (!reader.HasRows) return 0;
            await reader.ReadAsync();

            return reader.IsDBNull(0) ? 0 : reader.GetInt32(0);
        }

        public static async Task<FuelCardTransactionCollection> ReadFuelCradTransactionCollectionAsync(
            SqlDataReader reader)
        {
            var entities = new Dictionary<long, FuelCardTransaction>();
            if (!reader.HasRows) return new FuelCardTransactionCollection();
            while (await reader.ReadAsync())
            {
                var entity = new FuelCardTransaction();

                entity.Id = reader.GetInt64(0);
                entity.CardHolder = ReadHumanById(reader.GetInt64(1));
                entity.CardHolderName = reader.IsDBNull(2) ? null : reader.GetString(2);
                entity.CardNumber = reader.GetInt64(3);
                entity.Time = reader.GetDateTime(4);
                entity.Terminal = reader.GetString(5);
                entity.Product = reader.GetString(6);
                entity.Quantity = reader.GetDecimal(7);
                entity.Ammount = reader.GetDecimal(8);
                entity.FullAmmount = reader.GetDecimal(9);
                entity.Discount = reader.GetDecimal(10);
                entities.Add(entity.Id, entity);
            }

            return new FuelCardTransactionCollection(entities.Values);
        }

        public static Task<FuelCardTransactionCollection> ReadFuelCradTransactionCollectionAsync(long? humanId,
            DateTime? from, DateTime? to)
        {
            return ReadObjectAsync(null, "[valeant].[ReadFuelCradTransactions]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@humanId", SqlDbType.BigInt) {Value = humanId},
                    new SqlParameter("@from", SqlDbType.DateTime) {Value = from},
                    new SqlParameter("@to", SqlDbType.DateTime) {Value = to}
                }
                , ReadFuelCradTransactionCollectionAsync);
        }


        private static async Task<AdvanceCollection> ReadAdvance(SqlDataReader reader)
        {
            var entities = new Dictionary<long, Advance>();
            if (!reader.HasRows) return new AdvanceCollection(entities.Values);
            while (await reader.ReadAsync())
            {
                var id = reader.GetInt64(0);
                entities.Add(
                    id,
                    new Advance
                    {
                        Id = id,
                        Number = reader.GetInt64(1),
                        Date = reader.GetDateTimeOffset(2),
                        Type = reader.GetString(3),
                        Sum = reader.GetDecimal(4),
                        Status = reader.GetString(5),
                        ContentType = reader.GetString(6),
                        Content = ReadXElement(reader.GetSqlXml(7)),
                        Creator = reader.GetInt64(8),
                        DateCreate = reader.GetDateTimeOffset(9),
                        FullName = reader.GetString(10),
                        DepartmentName = reader.GetString(11),
                        Actions = new List<string>(),
                        Tokens = new TokenCollection()
                    }
                    );
            }
            if (!reader.NextResult()) return new AdvanceCollection(entities.Values);
            while (await reader.ReadAsync())
            {
                var id = reader.GetInt64(0);
                if (entities.ContainsKey(id)) entities[id].Actions.Add(reader.GetString(1));
            }
            if (!reader.NextResult()) return new AdvanceCollection(entities.Values);
            while (await reader.ReadAsync())
            {
                var id = reader.GetInt64(0);
                var advance = entities[id];
                advance.Tokens.Add(new Token { Value = reader.GetString(1), Type = reader.GetString(2) });
            }
            return new AdvanceCollection(entities.Values);
        }

        private static async Task<AdvanceCollectionVersion3> ReadAdvanceVersion3Async(SqlDataReader reader)
        {
            var entities = new Dictionary<long, AdvanceVersion3>();
            if (!reader.HasRows) return new AdvanceCollectionVersion3(entities.Values);
            while (await reader.ReadAsync())
            {
                var id = reader.GetInt64(0);
                entities.Add(
                    id,
                    new AdvanceVersion3
                    {
                        Id = id,
                        Number = reader.GetInt64(1),
                        Date = reader.GetDateTimeOffset(2),
                        Type = reader.GetString(3),
                        Sum = reader.GetDecimal(4),
                        Status = reader.GetString(5),
                        ContentType = reader.GetString(6),
                        Content = ReadXElement(reader.GetSqlXml(7)),
                        Creator = reader.GetInt64(8),
                        DateCreate = reader.GetDateTimeOffset(9),
                        FullName = reader.GetString(10),
                        DepartmentName = reader.GetString(11),
                        ApprovalSheets = reader.IsDBNull(12) ? null : new ApprovalSheetItems(reader.GetString(12)),
                        ProcessSubType = reader.GetString(13),
                        Tokens = new TokenCollection()
                    });
            }
            if (!reader.NextResult()) return new AdvanceCollectionVersion3(entities.Values);
            while (await reader.ReadAsync())
            {
                var id = reader.GetInt64(0);
                var advance = entities[id];
                advance.Tokens.Add(new Token { Value = reader.GetString(1), Type = reader.GetString(2) });
            }
            if (await reader.NextResultAsync()) await ReadAndApplyMetadataAsync(reader, entities);
            return new AdvanceCollectionVersion3(entities.Values);
        }

        public static Task<EmployeeLedgerEntryCollection> ReadEmployeeLedgerEntry(string id, DateTime? from,
            DateTime? to)
        {
            return ReadObjectAsync(null, "[valeant].[ReadLedgerEntry]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.NVarChar) {Value = id},
                    new SqlParameter("@from", SqlDbType.DateTime) {Value = from},
                    new SqlParameter("@to", SqlDbType.DateTime) {Value = to}
                }, ReadEmployeeLedgerEntry);
        }


        public static async Task<EmployeeLedgerEntryCollection> ReadEmployeeLedgerEntry(SqlDataReader reader)
        {
            var entities = new Dictionary<long, EmployeeLedgerEntry>();
            if (!reader.HasRows) return new EmployeeLedgerEntryCollection(entities.Values);
            while (await reader.ReadAsync())
            {
                var id = reader.GetInt64(0);

                var entry = new EmployeeLedgerEntry
                {
                    Id = id,
                    Number = reader.GetInt32(1),
                    Key = reader.GetString(2),
                    VendorNumber = reader.GetString(3),
                    DocumentNumber = reader.GetString(4),
                    DocumentType = reader.GetString(5),
                    PostingDate = reader.GetDateTime(6),
                    Ammount = reader.GetSqlMoney(7).ToDecimal(),
                    Description = reader.GetString(8),
                    PaymentPurpose = reader.GetString(9),
                    PostingGroup = reader.GetString(10),
                    EntryType = reader.IsDBNull(11) ? 0 : reader.GetInt32(11),
                    AmmountSum = reader.GetSqlMoney(12).ToDecimal(),
                };

                entities.Add(id, entry);
            }

            return new EmployeeLedgerEntryCollection(entities.Values);
        }

        private static TokenMapItemCollection ReadTokenMapItemCollection(SqlDataReader reader)
        {
            var result = new TokenMapItemCollection();
            if (!reader.HasRows) return result;
            while (reader.Read())
            {
                result.Add(
                    new TokenMapItem
                    {
                        Id = reader.GetInt64(0),
                        DocumentType = reader.GetInt64(1),
                        DocumentTypeName = reader.GetString(2),
                        TokenType = reader.GetString(3),
                        State = reader.GetInt64(4),
                        StateName = reader.GetString(5)
                    }
                    );
            }
            return result;
        }

        private static StateMapItemCollection ReadStateMapItemCollection(SqlDataReader reader)
        {
            var result = new StateMapItemCollection();
            if (!reader.HasRows) return result;
            while (reader.Read())
            {
                var stateMapItem = new StateMapItem
                {
                    Id = reader.GetInt64(0),
                    DocumentId = reader.GetInt64(1),
                    DocumentName = reader.GetString(2),
                    ActionId = reader.GetInt64(3),
                    ActionName = reader.GetString(4),
                    StateId = reader.GetInt64(5),
                    StateName = reader.GetString(6),
                    Description = reader.GetString(11)
                };
                if (!reader.IsDBNull(7)) stateMapItem.NextStateId = reader.GetInt64(7);
                if (!reader.IsDBNull(8)) stateMapItem.NextStateName = reader.GetString(8);
                if (!reader.IsDBNull(9)) stateMapItem.SelectorId = reader.GetInt64(9);
                if (!reader.IsDBNull(10)) stateMapItem.SelectorName = reader.GetString(10);
                if (!reader.IsDBNull(12)) stateMapItem.NotificationId = reader.GetInt64(12);
                result.Add(stateMapItem);
            }

            if (reader.NextResult())
            {
                var notifications = new Dictionary<long, NotificationItem>();
                while (reader.Read())
                {
                    var key = reader.GetInt64(0);
                    notifications.Add(key,
                        new NotificationItem
                        {
                            Id = key,
                            TemplateSubject = reader.GetString(1),
                            TemplateMessage = reader.GetString(2),
                            AllListUrlPart = reader.GetString(3),
                            DocumentPart = reader.GetString(4)
                        });
                }
                var notificationStates = result.Where(x => x.NotificationId.HasValue);
                foreach (
                    var notificationState in
                        notificationStates.Where(
                            notificationState => notificationState.NotificationId != null && notifications.ContainsKey(notificationState.NotificationId.Value)))
                {
                    if (notificationState.NotificationId != null)
                    {
                        notificationState.Notification = notifications[notificationState.NotificationId.Value];
                    }
                }
            }
            return result;
        }


        private static SelectorItemCollection ReadSelectorItemCollection(SqlDataReader reader)
        {
            var result = new SelectorItemCollection();
            if (!reader.HasRows) return result;
            while (reader.Read())
            {
                var selectorItem = new SelectorItem
                {
                    Id = reader.GetInt64(0),
                    DocumentId = reader.GetInt64(1),
                    DocumentName = reader.GetString(2),
                    SelectorId = reader.GetInt64(3),
                    SelectorName = reader.GetString(4),
                    Result = reader.GetInt32(9)
                };
                if (!reader.IsDBNull(5)) selectorItem.NextStateId = reader.GetInt64(5);
                if (!reader.IsDBNull(6)) selectorItem.NextStateName = reader.GetString(6);
                if (!reader.IsDBNull(7)) selectorItem.NextSelectorId = reader.GetInt64(7);
                if (!reader.IsDBNull(8)) selectorItem.NextSelectorName = reader.GetString(8);
                if (!reader.IsDBNull(10)) selectorItem.NotificationId = reader.GetInt64(10);
                result.Add(selectorItem);
            }
            if (reader.NextResult())
            {
                var notifications = new Dictionary<long, NotificationItem>();
                while (reader.Read())
                {
                    var key = reader.GetInt64(0);
                    notifications.Add(key,
                        new NotificationItem
                        {
                            Id = key,
                            TemplateSubject = reader.GetString(1),
                            TemplateMessage = reader.GetString(2),
                            AllListUrlPart = reader.GetString(3),
                            DocumentPart = reader.GetString(4)
                        });
                }
                var notificationStates = result.Where(x => x.NotificationId.HasValue);
                foreach (
                    var notificationState in
                        notificationStates.Where(
                            notificationState => notificationState.NotificationId != null && notifications.ContainsKey(notificationState.NotificationId.Value)))
                {
                    if (notificationState.NotificationId != null)
                    {
                        notificationState.Notification = notifications[notificationState.NotificationId.Value];
                    }
                }
            }
            return result;
        }

        private static HistoryMapItemCollection ReadHistoryMapItemCollection(SqlDataReader reader)
        {
            var result = new HistoryMapItemCollection();
            if (!reader.HasRows) return result;
            while (reader.Read())
            {
                var historyItem = new HistoryMapItem
                {
                    Id = reader.GetInt64(0),
                    ActionId = reader.GetInt64(1),
                    DocumentId = reader.GetInt64(3),
                    DocumentName = reader.GetString(4),
                    History = reader.GetString(5)
                };
                if (!reader.IsDBNull(2)) historyItem.ActionName = reader.GetString(2);
                result.Add(historyItem);
            }
            return result;
        }

        private static async Task<HistoryItemCollection> ReadHistoryItemCollectionAsync(SqlDataReader reader)
        {
            var result = new HistoryItemCollection();
            if (!reader.HasRows) return result;
            while (await reader.ReadAsync())
            {
                var item =
                    new HistoryItem
                    {
                        Id = reader.GetInt64(0),
                        Number = reader.GetInt32(1),
                        Date = reader.GetDateTimeOffset(2).DateTime,
                        FullName = reader.GetString(3),
                        History = reader.GetString(4),
                        InReport = reader.GetBoolean(6)
                    };
                if (!reader.IsDBNull(5)) item.Comment = reader.GetString(5);
                result.Add(item);
            }
            return result;
        }

        private static async Task<ApprovedHistoryItemCollectionVersion3> ReadApprovedHistoryItemCollectionAsync(
            SqlDataReader reader)
        {
            var result = new ApprovedHistoryItemCollectionVersion3();
            if (!reader.HasRows) return result;
            while (await reader.ReadAsync())
            {
                result.Add(
                    new ApprovedHistoryItemVersion3
                    {
                        Id = reader.GetInt64(0),
                        Number = reader.GetInt32(1),
                        Date = reader.GetDateTimeOffset(2),
                        FullName = reader.GetString(3),
                        Position = reader.GetString(4)
                    });
            }
            return result;
        }

        private static async Task<CostcenterCollection> ReadCostcenterAsync(SqlDataReader reader)
        {
            var result = new CostcenterCollection();
            if (!reader.HasRows) return result;
            while (await reader.ReadAsync())
            {
                result.Add(new Costcenter
                {
                    Id = reader.GetInt64(0),
                    Code = reader.GetString(1),
                    Description = reader.GetString(2)
                });
            }
            return result;
        }





        private static Settings ReadSettings(SqlDataReader reader)
        {
            var result = new Settings();
            if (!reader.HasRows) return result;
            while (reader.Read())
            {
                var key = reader.GetString(1);
                result.Add(key, new SettingItem
                {
                    Id = reader.GetInt64(0),
                    Value = reader.GetString(2),
                    Description = reader.GetString(3)
                });
            }
            return result;
        }


        private static Dictionary<long, string> ReadDocumentType(SqlDataReader reader)
        {
            var entities = new Dictionary<long, string>();
            if (!reader.HasRows) return entities;
            while (reader.Read())
            {
                entities.Add(reader.GetInt64(0), reader.GetString(1));
            }
            return entities;
        }


        private static Dictionary<string, string> ReadMime(SqlDataReader reader)
        {
            var result = new Dictionary<string, string>();
            if (!reader.HasRows) return result;
            while (reader.Read())
            {
                result.Add(reader.GetString(0), reader.GetString(1));
            }
            return result;
        }

        private static async Task<List<string>> ReadUpdateAttachments(SqlDataReader reader)
        {
            var result = new List<string>();
            if (!reader.HasRows) return result;
            while (await reader.ReadAsync())
                result.Add(reader.GetString(0));
            return result;
        }

        private static async Task<AttachmentVersion2> ReadAttachment(SqlDataReader reader)
        {
            if (!reader.HasRows) return null;
            await reader.ReadAsync();
            return new AttachmentVersion2
            {
                Urn = reader.GetString(0),
                ContentType = reader.GetString(1)
            };
        }

        private static Dictionary<long, MatrixVersion3> ReadMatrix(SqlDataReader reader)
        {
            var statesEntities = new Dictionary<long, StateVersion3>();
            var tokensEntities = new Dictionary<long, TokenVersion3>();
            var documentBlocksEntities = new Dictionary<long, string>();
            var documentAccessListEntities = new Dictionary<long, DocumentAccessListVersion3>();
            var documentBlockAccessTypeEntities = new Dictionary<long, DocumentBlockAccessTypeVersion3>();
            var notificationsEntities = new Dictionary<long, NotificationVersion3>();
            var nodeEntities = new Dictionary<TwoLongKey, NodeVersion3>();
            var matrixEntities = new Dictionary<long, MatrixVersion3>();
            if (!reader.HasRows) throw new Exception("Ошибка чтения матрицы. Отсутствуют состояния");
            long id;
            //Состояния
            while (reader.Read())
            {
                id = reader.GetInt64(0);
                statesEntities.Add(id,
                    new StateVersion3(id, reader.GetString(1), reader.GetString(2),
                        reader.IsDBNull(3) ? null : reader.GetString(3)));
            }
            //Токены
            if (!reader.NextResult()) throw new Exception("Ошибка чтения матрицы. Отсутствуют токены");
            if (!reader.HasRows) throw new Exception("Ошибка чтения матрицы. Отсутствуют токены");
            while (reader.Read())
            {
                id = reader.GetInt64(0);
                tokensEntities.Add(id,
                    new TokenVersion3(id, reader.GetString(1), reader.GetBoolean(2), reader.GetBoolean(3)));
            }
            //Блоки
            if (!reader.NextResult())
                throw new Exception("Ошибка чтения матрицы. Отсутствуют типы доступа к блокам документов");
            if (!reader.HasRows)
                throw new Exception("Ошибка чтения матрицы. Отсутствуют типы доступа к блокам документов");
            while (reader.Read())
            {
                id = reader.GetInt64(0);
                documentBlockAccessTypeEntities.Add(id,
                    new DocumentBlockAccessTypeVersion3(id, reader.GetString(1), reader.GetString(2)));
            }
            if (!reader.NextResult())
                throw new Exception("Ошибка чтения матрицы. Отсутствуют определения блоков документов");
            if (!reader.HasRows)
                throw new Exception("Ошибка чтения матрицы. Отсутствуют определения блоков документов");
            while (reader.Read())
            {
                documentBlocksEntities.Add(reader.GetInt64(0), reader.GetString(1));
            }
            if (!reader.NextResult())
                throw new Exception("Ошибка чтения матрицы. Отсутствуют определения списков доступа");
            if (!reader.HasRows) throw new Exception("Ошибка чтения матрицы. Отсутствуют определения списков доступа");
            while (reader.Read())
            {
                id = reader.GetInt64(0);
                documentAccessListEntities.Add(id,
                    new DocumentAccessListVersion3(id, reader.GetInt64(1), reader.GetString(2), reader.GetString(3)));
            }
            if (!reader.NextResult())
                throw new Exception("Ошибка чтения матрицы. Отсутствует детализация списков доступа");
            if (!reader.HasRows) throw new Exception("Ошибка чтения матрицы. Отсутствует детализация списков доступа");
            while (reader.Read())
            {
                var accessListId = reader.GetInt64(1);
                if (!documentAccessListEntities.ContainsKey(accessListId))
                    throw new Exception($"Ошибка чтения матрицы. Список доступа {accessListId} не найден");
                var blockId = reader.GetInt64(2);
                if (!documentBlocksEntities.ContainsKey(blockId))
                    throw new Exception($"Ошибка чтения матрицы. Блок документа {blockId} не найден");
                var accessTypeId = reader.GetInt64(3);
                if (!documentBlockAccessTypeEntities.ContainsKey(accessTypeId))
                    throw new Exception($"Ошибка чтения матрицы. Тип доступа {accessTypeId} не найден");
                var accessList = documentAccessListEntities[accessListId];
                accessList.Details.Add(new DocumentBlockAccessVersion3(documentBlocksEntities[blockId],
                    documentBlockAccessTypeEntities[accessTypeId]));
            }
            if (!reader.NextResult()) throw new Exception("Ошибка чтения матрицы. Отсутствуют уведомления");
            if (!reader.HasRows) throw new Exception("Ошибка чтения матрицы. Отсутствуют уведомления");
            while (reader.Read())
            {
                id = reader.GetInt64(0);
                notificationsEntities.Add(id,
                    new NotificationVersion3(id, reader.GetString(1), reader.GetString(2), reader.GetString(3),
                        reader.GetString(4)));
            }
            if (!reader.NextResult())
                throw new Exception("Ошибка чтения матрицы. Отсутствуют определения свойства узлов");
            if (!reader.HasRows) throw new Exception("Ошибка чтения матрицы. Отсутствуют определения свойства узлов");
            while (reader.Read())
            {
                id = reader.GetInt64(0);
                var stateId = reader.GetInt64(1);
                if (!statesEntities.ContainsKey(stateId))
                    throw new Exception($"Ошибка чтения матрицы. Состояние Id:\"{stateId}\" не найдено");
                var tokenId = reader.GetInt64(2);
                if (!tokensEntities.ContainsKey(tokenId))
                    throw new Exception($"Ошибка чтения матрицы. Токен Id:\"{tokenId}\" не найден");
                var accessListId = reader.GetInt64(3);
                var documentId = reader.GetInt64(6);
                var expression = reader.IsDBNull(7) ? null : reader.GetString(7);
                if (!documentAccessListEntities.ContainsKey(accessListId))
                    throw new Exception($"Ошибка чтения матрицы. Список доступа Id:\"{accessListId}\" не найден");
                NotificationVersion3 notification;
                if (reader.IsDBNull(4)) notification = null;
                else
                {
                    var notificationId = reader.GetInt64(4);
                    if (!notificationsEntities.ContainsKey(notificationId))
                        throw new Exception($"Ошибка чтения матрицы. Уведомление Id:\"{notificationId}\" не найдено");
                    notification = notificationsEntities[notificationId];
                }
                var key = new TwoLongKey(stateId, documentId);
                if (!nodeEntities.ContainsKey(key))
                    nodeEntities.Add(key, new NodeVersion3(statesEntities[stateId]));
                nodeEntities[key].Properties.Add(new NodePropertyVersion3(id, tokensEntities[tokenId],
                    documentAccessListEntities[accessListId], notification, reader.GetString(5).Split(',').Select(x => x.Trim()).ToArray(), expression));
            }
            if (!reader.NextResult()) throw new Exception("Ошибка чтения матрицы. Матрица не найдена");
            while (reader.Read())
            {
                var fromId = reader.GetInt64(1);
                var condition = reader.GetString(3);
                var documentId = reader.GetInt64(4);
                var fromKey = new TwoLongKey(fromId, documentId);
                if (!nodeEntities.ContainsKey(fromKey))
                    throw new Exception($"Ошибка чтения матрицы. Узел Id: {fromId} не найден");
                NodeVersion3 toNode = null;
                if (!reader.IsDBNull(2))
                {
                    var toId = reader.GetInt64(2);
                    var toKey = new TwoLongKey(toId, documentId);
                    if (!nodeEntities.ContainsKey(toKey))
                        throw new Exception($"Ошибка чтения матрицы. Узел Id: {toId} не найден");
                    toNode = nodeEntities[toKey];
                }
                string selectCondition = null;
                if (!reader.IsDBNull(5)) selectCondition = reader.GetString(5);
                var approvalsheetitem = reader.IsDBNull(6) ? null : reader.GetString(6);
                var clearapprovalsheet = reader.GetBoolean(7);
                if (!matrixEntities.ContainsKey(documentId))
                    matrixEntities.Add(documentId, new MatrixVersion3(documentId));
                matrixEntities[documentId].Intersections.Add(new IntersectionVersion3(reader.GetInt64(0),
                    nodeEntities[fromKey], toNode, condition, documentId, selectCondition, approvalsheetitem,
                    clearapprovalsheet));
            }
            return matrixEntities;
        }

        private static async Task<AdvanceContent> ReadAdvanceContent(SqlDataReader reader)
        {
            if (!reader.HasRows) return null;
            await reader.ReadAsync();
            return new AdvanceContent { Content = ReadXElement(reader.GetSqlXml(0)), ContentType = reader.GetString(1) };
        }

        public static async Task<long> CreateNewTravelNumber()
        {
            var number = new SqlParameter("@number", SqlDbType.BigInt)
            {
                Direction = ParameterDirection.InputOutput,
                Value = 1
            };

            await ExecuteNoQueryAsync("[valeant].[CreateNewTravelNumber]", CommandType.StoredProcedure,
                new[]
                {
                    number
                });
            return number.Value == DBNull.Value ? 1 : (long)number.Value;
        }

        private static XElement ReadXElement(SqlXml sqlXml)
        {
            try
            {
                using (var reader = sqlXml.CreateReader())
                    return XElement.Load(reader);
            }
            catch (Exception ex)
            {
                _logger.Error(ex);
                throw;
            }
        }

        private static async Task<int> ExecuteNoQueryAsync(string commandText, CommandType commandType,
            SqlParameter[] parameters)
        {
            var connection = new SqlConnection(ConnectionString);
            try
            {
                if (connection.State != ConnectionState.Open) await connection.OpenAsync();
                using (var command = connection.CreateCommand())
                {
                    command.CommandText = commandText;
                    command.CommandType = commandType;
                    if (parameters != null) command.Parameters.AddRange(parameters);
                    var rows = await command.ExecuteNonQueryAsync();
                    return rows;
                }
            }
            catch (Exception ex)
            {
                _logger.Error(ex);
                throw;
            }
            finally
            {
                connection.Dispose();
            }
        }

        private static int ExecuteNoQuery(SqlConnection connection, string commandText, CommandType commandType,
            SqlParameter[] parameters)
        {
            var selfConnection = false;
            if (connection == null)
            {
                connection = new SqlConnection(ConnectionString);
                selfConnection = true;
            }
            try
            {
                if (connection.State != ConnectionState.Open) connection.Open();
                using (var command = connection.CreateCommand())
                {
                    command.CommandText = commandText;
                    command.CommandType = commandType;
                    if (parameters != null) command.Parameters.AddRange(parameters);
                    var rows = command.ExecuteNonQuery();
                    return rows;
                }
            }
            catch (Exception ex)
            {
                _logger.Error(ex);
                throw;
            }
            finally
            {
                if (selfConnection) connection.Dispose();
            }
        }

        public static int ClearLedgerEntries()
        {
            return ExecuteNoQuery(null, "[valeant].[ClearLedgerEntries]", CommandType.StoredProcedure, null);
        }

        public static int InsertLedgerEntry(EmployeeLedgerEntry entry)
        {
            return ExecuteNoQuery(null, "[valeant].[InsertLedgerEntry]", CommandType.StoredProcedure, new[]
            {
                new SqlParameter("@number", SqlDbType.Int) {Value = entry.Number},
                new SqlParameter("@vendorledgerentryno", SqlDbType.Int) {Value = entry.VendorLedgerEntryNo},
                new SqlParameter("@entrykey", SqlDbType.NVarChar, 255) {Value = entry.Key},
                new SqlParameter("@vendornumber", SqlDbType.NVarChar, 50) {Value = entry.VendorNumber},
                new SqlParameter("@documentnumber", SqlDbType.NVarChar, 255) {Value = entry.DocumentNumber},
                new SqlParameter("@documenttype", SqlDbType.NVarChar, 255) {Value = entry.DocumentType},
                new SqlParameter("@postingdate", SqlDbType.DateTime) {Value = entry.PostingDate},
                new SqlParameter("@ammount", SqlDbType.Money) {Value = entry.Ammount},
                new SqlParameter("@description", SqlDbType.NVarChar, 255) {Value = entry.Description},
                new SqlParameter("@paymentpurpose", SqlDbType.NVarChar, 255) {Value = entry.PaymentPurpose},
                new SqlParameter("@postinggroup", SqlDbType.NVarChar, 255) {Value = entry.PostingGroup},
                new SqlParameter("@entrytype", SqlDbType.Int) {Value = entry.EntryType}

            });
        }


        public static async Task<int> InsertOrUpdateCarAsync(Car car)
        {
            var res = await ExecuteNoQueryAsync("[valeant].[InsertOrUpdateCar]", CommandType.StoredProcedure, new[]
            {
                new SqlParameter("@number", SqlDbType.NVarChar, 50) {Value = car.Number},
                new SqlParameter("@type", SqlDbType.NVarChar, 255) {Value = car.Type},
                new SqlParameter("@human", SqlDbType.BigInt) {Value = car.Human.Id}
            });

            return res;
        }

        public static int InsertFuelCardTransaction(FuelCardTransaction transaction)
        {
            var res = ExecuteNoQuery(null, "[valeant].[InsertFuelCardTransaction]", CommandType.StoredProcedure, new[]
            {
                transaction.CardHolder != null
                    ? new SqlParameter("@cardHolderId", SqlDbType.BigInt) {Value = transaction.CardHolder.Id}
                    : new SqlParameter("@cardHolderId", DBNull.Value),
                new SqlParameter("@cardNumber", SqlDbType.BigInt) {Value = transaction.CardNumber},
                new SqlParameter("@time", SqlDbType.DateTime) {Value = transaction.Time},
                new SqlParameter("@terminal", SqlDbType.NVarChar, 255) {Value = transaction.Terminal},
                new SqlParameter("@product", SqlDbType.NVarChar, 50) {Value = transaction.Product},
                new SqlParameter("@quantity", SqlDbType.Decimal) {Value = transaction.Quantity},
                new SqlParameter("@ammount", SqlDbType.Money) {Value = transaction.Ammount},
                new SqlParameter("@fullAmmount", SqlDbType.Money) {Value = transaction.FullAmmount},
                new SqlParameter("@discount", SqlDbType.Money) {Value = transaction.Discount}
            });

            return res;
        }

        public static  Task InsertOrUpdateCostCenterAsync(Costcenter item)
        {
            return ExecuteNoQueryAsync("[valeant].[InsertOrUpdateCostCenter]",
                CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = item.Id <= 0 ? DBNull.Value : (object) item.Id},
                    new SqlParameter("@code", SqlDbType.NVarChar, 20) {Value = item.Code},
                    new SqlParameter("@description", SqlDbType.NVarChar, 2000) {Value = item.Description}
                   
                });
        }

        public static Task DeleteCostCenterAsync(Costcenter item)
        {
            return ExecuteNoQueryAsync("delete from [valeant].[costcenter] where [id]= @id",
                CommandType.Text,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = item.Id},
           
                });
        }


        public class Expenditure
        {
            
        }


        private static async Task<TObject> ReadObjectAsync<TObject>(SqlConnection connection, string commandText,
            CommandType commandType,
            SqlParameter[] parameters,
            Func<SqlDataReader, Task<TObject>> mapper)
            where TObject : new()
        {
            var selfConnection = false;
            if (connection == null)
            {
                connection = new SqlConnection(ConnectionString);
                selfConnection = true;
            }
            try
            {
                if (connection.State != ConnectionState.Open) await connection.OpenAsync();
                using (var command = connection.CreateCommand())
                {
                    command.CommandText = commandText;
                    command.CommandType = commandType;
                    if (parameters != null && parameters.Length > 0) command.Parameters.AddRange(parameters);
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        return await mapper(reader);
                    }
                }
            }
            catch (AggregateException ex)
            {
                var flatten = ex.Flatten();
                var inner = flatten.InnerExceptions;
                foreach (var e in inner) _logger.Error(e);
                throw flatten;
            }
            catch (Exception ex)
            {
                _logger.Error(ex);
                var message = ex.Message;
                throw new Exception(message);
            }
            finally
            {
                if (selfConnection) connection.Dispose();
            }
        }

        private static TObject ReadObject<TObject>(SqlConnection connection, string commandText,
            CommandType commandType,
            SqlParameter[] parameters,
            Func<SqlDataReader, TObject> mapper)
            where TObject : new()
        {
            var selfConnection = false;
            if (connection == null)
            {
                connection = new SqlConnection(ConnectionString);
                selfConnection = true;
            }
            try
            {
                if (connection.State != ConnectionState.Open) connection.Open();
                using (var command = connection.CreateCommand())
                {
                    command.CommandText = commandText;
                    command.CommandType = commandType;
                    if (parameters != null && parameters.Length > 0) command.Parameters.AddRange(parameters);
                    using (var reader = command.ExecuteReader())
                    {
                        return mapper(reader);
                    }
                }
            }
            catch (AggregateException ex)
            {
                var flatten = ex.Flatten();
                var inner = flatten.InnerExceptions;
                foreach (var e in inner) _logger.Error(e);
                throw flatten;
            }
            catch (Exception ex)
            {
                _logger.Error(ex);
                var message = ex.Message;
                throw new Exception(message);
            }
            finally
            {
                if (selfConnection) connection.Dispose();
            }
        }

        private static long GetStructureVersion(string name)
        {
            var outputParameter = new SqlParameter("@version", SqlDbType.BigInt) { Direction = ParameterDirection.Output };
            ExecuteNoQuery(null, "[valeant].[GetVersion]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@name", SqlDbType.NVarChar, 255) {Value = name},
                    outputParameter
                });
            return (long)outputParameter.Value;
        }

        private static void CheckStructureVersin()
        {
            Locker.EnterUpgradeableReadLock();
            try
            {
                var version = GetStructureVersion("Structure");
                if (version == _version) return;
                Locker.EnterWriteLock();
                try
                {
                    _humans = ReadHumanCollection();
                    _humansDictionary = _humans.ToDictionary(x => x.UserAccount.ToLower(), x => x);
                    _humansByIdDictionary = _humans.ToDictionary(x => x.Id, x => x);
                    HumansPrepare();
                    _version = version;
                }
                finally
                {
                    Locker.ExitWriteLock();
                }
            }
            finally
            {
                Locker.ExitUpgradeableReadLock();
            }
        }

        private static void HumansPrepare()
        {
            Human director = null;
            foreach (var item in _humans)
            {
                //Owner
                item.Tokens.Add(BuildOwnerToken(item));
                //член ролей
                item.Tokens.AddRange(item.Roles.Select(role => new Token { Type = "R", Value = role.Code }));
                //руководитель 1 уровня
                if (item.ManagerId.HasValue)
                {
                    if (_humansByIdDictionary.ContainsKey(item.ManagerId.Value))
                    {
                        var manager = _humansByIdDictionary[item.ManagerId.Value];
                        var token = BuildManager1StToken(item);
                        if (!manager.Tokens.Contains(token))
                            manager.Tokens.Add(token);
                    }
                }
                else
                {
                    //Главный
                    director = item;
                    item.IsCeo = true;
                    item.Tokens.Add(new Token { Value = "G-00000001", Type = "G" });
                }
                //руководитель 2 уровня
                if (item.Manager2NdId.HasValue)
                {
                    if (_humansByIdDictionary.ContainsKey(item.Manager2NdId.Value))
                    {
                        var manager = _humansByIdDictionary[item.Manager2NdId.Value];
                        var token = BuildManager2NdToken(item);
                        if (!manager.Tokens.Contains(token))
                            manager.Tokens.Add(token);
                    }
                }
                //Заместитель
                if (!item.DeputyId.HasValue) continue;
                if (_humansByIdDictionary.ContainsKey(item.DeputyId.Value))
                {
                    var deputy = _humansByIdDictionary[item.DeputyId.Value];
                    var token = BuildDeputyToken(item);
                    if (!deputy.Tokens.Contains(token))
                        deputy.Tokens.Add(token);
                }
            }
            if (director != null)
            {
                //Подчиненные директора имеющие подчиненных.
                var firstLevelHumans = _humans.Where(x => x.ManagerId.HasValue && x.ManagerId == director.Id
                                                          &&
                                                          _humans.FirstOrDefault(
                                                              y => y.ManagerId.HasValue && y.ManagerId == x.Id) != null);
                foreach (var firstLevelHuman in firstLevelHumans)
                {
                    firstLevelHuman.IsFirstLevel = true;
                    var downs = _humans.Where(x => x.ManagerId.HasValue && x.ManagerId == firstLevelHuman.Id);
                    SetFirstLevelHumans(downs, firstLevelHuman);
                }
            }
            _humans.ToList().ForEach(
                x =>
                    x.FlagOne =
                        !x.IsCeo && !x.ContainsTokens(new[] { RoleCode.CommercialDirector, RoleCode.FinanceDirector })
                );

        }

        private static void SetFirstLevelHumans(IEnumerable<Human> humans, Human firstLevelHuman)
        {
            foreach (var human in humans)
            {
                firstLevelHuman.Tokens.Add(BuildFirstLevelToken(human));
                var downs = _humans.Where(x => x.ManagerId.HasValue && x.ManagerId == human.Id).ToArray();
                if (downs.Any()) SetFirstLevelHumans(downs, firstLevelHuman);
            }
        }

        protected static async Task ReadAndApplyMetadataAsync<T>(SqlDataReader sqlReader,
            IReadOnlyDictionary<long, T> entities) where T : IContainsMetadata
        {
            if (sqlReader == null) throw new ArgumentNullException("sqlReader");
            if (entities == null) throw new ArgumentNullException("entities");
            while (await sqlReader.ReadAsync())
            {
                var key = sqlReader.GetInt64(0);
                var str = sqlReader.GetString(1);
                var str2 = sqlReader.IsDBNull(2) ? null : sqlReader.GetString(2);
                var local = entities[key];
                if (local.Metadata == null)
                    local.Metadata = new MetadataCollection();
                local.Metadata.Add(str, str2);
            }
        }


        public static Token BuildOwnerToken(Human human)
        {
            return new Token { Type = "O*", Value = $"O-{human.Code}" };
        }

        public static Token BuildRoToken(string code)
        {
            return new Token { Type = "RO", Value = $"RO-{code}" };
        }

        private static Token BuildManager1StToken(Human human)
        {
            return new Token { Type = "M1*", Value = $"M1-{human.Code}" };
        }

        private static Token BuildManager2NdToken(Human human)
        {
            return new Token { Type = "M2*", Value = $"M2-{human.Code}" };
        }

        private static Token BuildFirstLevelToken(Human human)
        {
            return new Token { Type = "F*", Value = $"F-{human.Code}" };
        }

        private static Token BuildDeputyToken(Human human)
        {
            return new Token { Type = "D", Value = $"D-{human.Code}" };
        }

        private static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["Valeant"].ConnectionString;
        }


        public static async Task<IEnumerable<PrepaymentRequestReportLine>> GetPrepaymentRequestsReportAsync()
        {
            try
            {
                return
                    await
                        ReadObjectAsync(null, "valeant.spGetPrepaymentRequestsReport", CommandType.StoredProcedure,
                        new SqlParameter[]
                        {
                            new SqlParameter("@type", SqlDbType.BigInt) {Value = 1},
                        },
                            async reader =>
                            {
                                var entities = new List<PrepaymentRequestReportLine>();
                                if (!reader.HasRows)
                                {
                                    return new List<PrepaymentRequestReportLine>();
                                }
                                while (await reader.ReadAsync())
                                {
                                    var entity = new PrepaymentRequestReportLine();
                                    entity.Id = reader.GetInt64(0);
                                    entity.Number = reader.GetInt64(1);
                                    entity.RequestDate = reader.GetDateTimeOffset(2).DateTime;
                                    entity.CreatorCode = reader.IsDBNull(3) ? null : reader.GetString(3);
                                    entity.CreatorFullName = reader.GetString(4);
                                    entity.CreatorCity = reader.IsDBNull(5) ? null : reader.GetString(5);
                                    entity.Summa = reader.GetDecimal(6);
                                    entity.RequestStatus = reader.GetString(7);
                                    entity.StatusComment = reader.IsDBNull(8) ? null : reader.GetString(8);
                                    entities.Add(entity);
                                }

                                return entities;
                            });
            }
            catch (Exception ex)
            {
                _logger.Error(ex);
                throw;
            }
        }

        public static async Task<IEnumerable<PrepaymentRequestReportLine>> GetTravelListsReportAsync(int type,
            DateTimeOffset start, DateTimeOffset end)
        {
            try
            {
                return
                    await
                        ReadObjectAsync(null, "valeant.spGetTravelListsReportFilter", CommandType.StoredProcedure,
                            new[]
                            {
                                new SqlParameter("@type", SqlDbType.Int) {Value = type},
                                new SqlParameter("@start", SqlDbType.DateTimeOffset) {Value = start},
                                new SqlParameter("@end", SqlDbType.DateTimeOffset) {Value = end}
                            },
                            async reader =>
                            {
                                var entities = new List<PrepaymentRequestReportLine>();
                                if (!reader.HasRows)
                                {
                                    return new List<PrepaymentRequestReportLine>();
                                }
                                while (await reader.ReadAsync())
                                {
                                    var entity = new PrepaymentRequestReportLine();
                                    entity.Id = reader.GetInt64(0);
                                    entity.Number = reader.GetInt64(1);
                                    entity.RequestDate = reader.IsDBNull(2) ? DateTime.MinValue : reader.GetDateTimeOffset(2).DateTime;
                                    entity.CreatorCode = reader.IsDBNull(3) ? null : reader.GetString(3);
                                    entity.CreatorFullName = reader.GetString(4);
                                    entity.CreatorCity = reader.IsDBNull(5) ? null : reader.GetString(5);
                                    entity.Summa = reader.GetDecimal(6);
                                    entity.RequestStatus = reader.GetString(7);
                                    entity.StatusComment = reader.IsDBNull(8) ? null : reader.GetString(8);
                                    entities.Add(entity);
                                }

                                return entities;
                            });
            }
            catch (Exception ex)
            {
                _logger.Error(ex);
                throw;
            }
        }


        public static async Task<IEnumerable<T>> ReadViaDapper<T>(string procName, DateTimeOffset dateStart,
            DateTimeOffset dateEnd)
        {
            var conn = new SqlConnection(ConnectionString);
            try
            {
                if (conn.State != ConnectionState.Open) await conn.OpenAsync();
                var res = await conn.QueryAsync<T>(procName,
                    //    new SqlParameter[]
                    //{
                    //    new SqlParameter("@dateStart", SqlDbType.DateTimeOffset) {Value = dateStart},
                    //    new SqlParameter("@dateEnd", SqlDbType.DateTimeOffset) {Value = dateEnd},
                    //},
                    commandType: CommandType.StoredProcedure);
                return res;

                //using (var command = conn.CreateCommand())
                //{
                //    command.CommandText = procName;
                //    command.CommandType = CommandType.StoredProcedure;
                //    if (parameters != null) command.Parameters.AddRange(parameters);
                //    var rows = await command.ExecuteNonQueryAsync();
                //    return rows;
                //}
            }
            catch (Exception ex)
            {
                _logger.Error(ex);
                throw;
            }
            finally
            {
                conn.Dispose();
            }
        }








        #region Human functions

        public static Human GetHuman(string accountName)
        {
            var normalizeAccountName = accountName.ToLower();
            CheckStructureVersin();
            return _humansDictionary.ContainsKey(normalizeAccountName) ? _humansDictionary[normalizeAccountName] : null;
        }

        public static Human GetHuman(long accountId)
        {
            CheckStructureVersin();
            return _humansByIdDictionary.ContainsKey(accountId) ? _humansByIdDictionary[accountId] : null;
        }


        public static Human ReadHumanByCode(string code)
        {
            var sql = @"select * from valeant.Humans where EmployeeStatus != 2 and Code = @code; 
                        select * from valeant.HumanRoles where HumanCode = @code";

            var humans = ReadObject(null, sql, CommandType.Text,
                new[]
                {
                    new SqlParameter("@code", SqlDbType.NVarChar, 255) {Value = code}
                }, ReadHumanCollection);
            return humans.Any() ? humans.First() : null;
        }

        public static async Task<Human> ReadAdvanceCreatorAsync(long documentId)
        {
            var sql = @"select h.* from valeant.advance a
                        left join valeant.Humans h on h.Id = a.creator
                        where a.Id = @documentId";

            var humans = await ReadObjectAsync(null, sql, CommandType.Text,
                new[]
                {
                    new SqlParameter("@documentId", SqlDbType.BigInt) {Value = documentId}
                }, ReadHumanCollectionAsync);
            var m = humans.FirstOrDefault();
            if (m != default(Human))
            {
                return Humans.FirstOrDefault(x => x.Id == m.Id);
            }
            return null;
        }

        public static Human ReadHumanById(long id)
        {
            var sql = @"select * from valeant.Humans where EmployeeStatus != 2 and Id = @id; 
                        select * from valeant.HumanRoles where HumanId = @id";

            var humans = ReadObject(null, sql, CommandType.Text,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = id}
                }, ReadHumanCollection);
            return humans.FirstOrDefault();
        }

        public static async Task<Human> ReadHumanByIdAsync(long id)
        {
            var sql = @"select * from valeant.Humans where EmployeeStatus != 2 and Id = @id; 
                        select * from valeant.HumanRoles where HumanId = @id";

            var humans = await ReadObjectAsync(null, sql, CommandType.Text,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = id}
                }, ReadHumanCollectionAsync);
            return humans.FirstOrDefault();
        }


        public static HumanCollection ReadHumanCollection()
        {
            var sql = @"select * from valeant.Humans where EmployeeStatus != 2; 
                        select * from valeant.HumanRoles";
            
            return ReadObject(null, sql, CommandType.Text, null, ReadHumanCollection);
        }

        private static HumanCollection ReadHumanCollection(SqlDataReader reader)
        {
            var entities = new Dictionary<long, Human>();
            if (!reader.HasRows)
            {
                return new HumanCollection();
            }

            while (reader.Read())
            {
                if (reader.IsDBNull(6)) continue;
                var human = Human.FromSqlDataReader(reader);

                entities.Add(human.Id, human);
            }
            if (!reader.NextResult()) return new HumanCollection(entities.Values);
            while (reader.Read())
            {
                var humanId = reader.GetInt64(2);
                if (!entities.ContainsKey(humanId)) continue;
                var h = entities[humanId];
                h.Roles.Add(Role.FromSqlDataReader(reader));
            }
            return new HumanCollection(entities.Values);
        }

        private static async Task<HumanCollection> ReadHumanCollectionAsync(SqlDataReader reader)
        {
            var entities = new Dictionary<long, Human>();
            if (!reader.HasRows) return new HumanCollection();
            while (await reader.ReadAsync())
            {
                if (reader.IsDBNull(6)) continue;
                var human = Human.FromSqlDataReader(reader);

                entities.Add(human.Id, human);
            }
            if (!await reader.NextResultAsync()) return new HumanCollection(entities.Values);
            while (await reader.ReadAsync())
            {
                var humanId = reader.GetInt64(2);
                if (!entities.ContainsKey(humanId)) continue;
                var h = entities[humanId];
                h.Roles.Add(Role.FromSqlDataReader(reader));
            }
            return new HumanCollection(entities.Values);
        }

        public static Task<int> UpdateHuman(Human human)
        {
            return ExecuteNoQueryAsync("[valeant].[UpdateHuman]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = human.Id},
                    new SqlParameter("@assistantId", SqlDbType.BigInt)
                    {
                        Value =
                            !human.AssistantId.HasValue || human.AssistantId == 0
                                ? DBNull.Value
                                : (object) human.AssistantId
                    },
                    new SqlParameter("@deputyId", SqlDbType.BigInt)
                    {
                        Value = !human.DeputyId.HasValue || human.DeputyId == 0 ? DBNull.Value : (object) human.DeputyId
                    },
                    new SqlParameter("@deputyDateStart", SqlDbType.DateTimeOffset)
                    {
                        Value =
                            human.DeputyRange.StartDate == default(DateTimeOffset)
                                ? DBNull.Value
                                : (object) human.DeputyRange.StartDate
                    },
                    new SqlParameter("@deputyDateEnd", SqlDbType.DateTimeOffset)
                    {
                        Value =
                            human.DeputyRange.EndDate == default(DateTimeOffset)
                                ? DBNull.Value
                                : (object) human.DeputyRange.EndDate
                    },
                    new SqlParameter("@roles", SqlDbType.Structured)
                    {
                        TypeName = SqlBigintTable.TypeName,
                        Value = new SqlBigintTable(human.Roles.Select(x => x.Id))
                    }
                });
        }


        public static Task<int> UpdateHumanProfile(Human human)
        {
            return ExecuteNoQueryAsync("[valeant].[UpdateHumanProfile]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = human.Id},
                    new SqlParameter("@tel", SqlDbType.NVarChar, 16) {Value = human.Tel},
                    new SqlParameter("@LoyaltyCards", SqlDbType.NVarChar, 250) {Value = human.LoyaltyCards},
                    new SqlParameter("@InternationalPassportFirstName", SqlDbType.NVarChar, 250)
                    {
                        Value = human.InternationalPassport != null ? human.InternationalPassport.FirstName : null
                    },
                    new SqlParameter("@InternationalPassportLastName", SqlDbType.NVarChar, 250)
                    {
                        Value = human.InternationalPassport != null ? human.InternationalPassport.LastName : null
                    },
                    new SqlParameter("@InternationalPassportBirthPlace", SqlDbType.NVarChar, 250)
                    {
                        Value = human.InternationalPassport != null ? human.InternationalPassport.BirthPlace : null
                    },
                    new SqlParameter("@NumberInternationalPassport", SqlDbType.NVarChar, 250)
                    {
                        Value = human.InternationalPassport != null ? human.InternationalPassport.Number : null
                    },
                    new SqlParameter("@InternationalPassportIssueDate", SqlDbType.DateTime)
                    {
                        Value = human.InternationalPassport != null ? human.InternationalPassport.IssueDate : null
                    },
                    new SqlParameter("@InternationalPassportExpiryDate", SqlDbType.DateTime)
                    {
                        Value = human.InternationalPassport != null ? human.InternationalPassport.ExpiryDate : null
                    },
                    new SqlParameter("@FuelCard", SqlDbType.BigInt) {Value = human.FuelCard}
                });
        }


        public static Task<int> UpdateHumanLastLoginTime(string userAccount)
        {
            return ExecuteNoQueryAsync("[valeant].[UpdateHumanLastLoginTime]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@userAccount", SqlDbType.NVarChar, 255) {Value = userAccount}
                });
        }

        #endregion
    }
}