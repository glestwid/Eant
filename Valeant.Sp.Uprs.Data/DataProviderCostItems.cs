using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.Uprs.Data.Domain.Expenditure;

namespace Valeant.Sp.Uprs.Data
{
    public partial class DataProvider
    {
        public static async Task CreateExpenditureAsync(ChangeExpenditureCommand changeCommand)
        {
            var connection = new SqlConnection(ConnectionString);
            await connection.OpenAsync();

            using (var tran = connection.BeginTransaction(IsolationLevel.ReadCommitted))
            {
                try
                {
                    const string createExpenditureCommandText =
                        @"insert into [valeant].[expenditures] (Title, ApproverRoleId, GroupLimitCode, CreditGroupId, Account1GroupId, Account2GroupId)
                          values (@Title, @ApproverRoleId, @GroupLimitCode, @CreditGroupId, @Account1GroupId, @Account2GroupId);
                          select SCOPE_IDENTITY()";

                    object expenditureId;

                    using (var command = connection.CreateCommand())
                    {
                        command.Transaction = tran;
                        command.CommandText = createExpenditureCommandText;
                        command.Parameters.Add(new SqlParameter("@Title", SqlDbType.NVarChar)
                        {
                            Value = changeCommand.Title
                        });
                        command.Parameters.Add(new SqlParameter("@ApproverRoleId", SqlDbType.BigInt)
                        {
                            Value = (object)changeCommand.ApproverRoleId ?? DBNull.Value,
                            IsNullable = true
                        });
                        command.Parameters.Add(new SqlParameter("@GroupLimitCode", SqlDbType.NVarChar)
                        {
                            Value = (object)changeCommand.GroupLimitCode ?? DBNull.Value,
                            IsNullable = true
                        });
                        command.Parameters.Add(new SqlParameter("@CreditGroupId", SqlDbType.BigInt)
                        {
                            Value = (object)changeCommand.CreditGroupId ?? string.Empty,
                            IsNullable = true
                        });
                        command.Parameters.Add(new SqlParameter("@Account1GroupId", SqlDbType.BigInt)
                        {
                            Value = (object)changeCommand.Account1GroupId ?? DBNull.Value,
                            IsNullable = true
                        });
                        command.Parameters.Add(new SqlParameter("@Account2GroupId", SqlDbType.BigInt)
                        {
                            Value = (object)changeCommand.Account2GroupId ?? DBNull.Value,
                            IsNullable = true
                        });

                        expenditureId = await command.ExecuteScalarAsync();
                    }

                    const string createExpenditureDocumentsCommand =
                        @"insert into [valeant].[expenditureDocumentType] (ExpenditureId, DocumentTypeId) values (@ExpenditureId, @DocumentTypeId)";

                    foreach (var documentTypeId in changeCommand.Documents)
                    {
                        using (var command = connection.CreateCommand())
                        {
                            command.Transaction = tran;
                            command.CommandText = createExpenditureDocumentsCommand;
                            command.Parameters.Add(new SqlParameter("@ExpenditureId", SqlDbType.BigInt)
                            {
                                Value = expenditureId
                            });
                            command.Parameters.Add(new SqlParameter("@DocumentTypeId", SqlDbType.BigInt)
                            {
                                Value = documentTypeId
                            });

                            await command.ExecuteNonQueryAsync();
                        }
                    }

                    const string createLimitCommand =
                        @"insert into [valeant].[limits] (positiongroup, limit, ExpenditureId) values (@positiongroup, @limit, @ExpenditureId)";

                    foreach (var expenditureLimitDto in changeCommand.Limits)
                    {
                        using (var command = connection.CreateCommand())
                        {
                            command.Transaction = tran;
                            command.CommandText = createLimitCommand;
                            command.Parameters.Add(new SqlParameter("@positiongroup", SqlDbType.BigInt)
                            {
                                Value = expenditureLimitDto.PositionGroup
                            });
                            command.Parameters.Add(new SqlParameter("@limit", SqlDbType.Money)
                            {
                                Value = expenditureLimitDto.Limit
                            });
                            command.Parameters.Add(new SqlParameter("@ExpenditureId", SqlDbType.BigInt)
                            {
                                Value = expenditureId
                            });

                            await command.ExecuteNonQueryAsync();
                        }
                    }
                }
                catch (Exception ex)
                {
                    _logger.Error(ex, "Exception occured while creating expenditure");
                    tran.Rollback();
                    throw;
                }

                tran.Commit();
            }
        }


        public static async Task UpdateExpenditureAsync(ChangeExpenditureCommand updateCommand)
        {
            var connection = new SqlConnection(ConnectionString);
            await connection.OpenAsync();

            using (var tran = connection.BeginTransaction(IsolationLevel.ReadCommitted))
            {
                try
                {
                    const string createExpenditureCommandText =
                        @"update [valeant].[expenditures] set Title = @Title, ApproverRoleId = @ApproverRoleId, GroupLimitCode = @GroupLimitCode, 
                                                              CreditGroupId = @CreditGroupId, Account1GroupId = @Account1GroupId, Account2GroupId = @Account2GroupId
                          where Id = @Id";

                    using (var command = connection.CreateCommand())
                    {
                        command.Transaction = tran;
                        command.CommandText = createExpenditureCommandText;
                        command.Parameters.Add(new SqlParameter("@Id", SqlDbType.BigInt)
                        {
                            Value = updateCommand.ExpenditureId
                        });
                        command.Parameters.Add(new SqlParameter("@Title", SqlDbType.NVarChar)
                        {
                            Value = updateCommand.Title
                        });
                        command.Parameters.Add(new SqlParameter("@ApproverRoleId", SqlDbType.BigInt)
                        {
                            Value = (object)updateCommand.ApproverRoleId ?? DBNull.Value,
                            IsNullable = true
                        });
                        command.Parameters.Add(new SqlParameter("@GroupLimitCode", SqlDbType.NVarChar)
                        {
                            Value = (object)updateCommand.GroupLimitCode ?? DBNull.Value,
                            IsNullable = true
                        });
                        command.Parameters.Add(new SqlParameter("@CreditGroupId", SqlDbType.BigInt)
                        {
                            Value = (object)updateCommand.CreditGroupId ?? DBNull.Value,
                            IsNullable = true
                        });
                        command.Parameters.Add(new SqlParameter("@Account1GroupId", SqlDbType.BigInt)
                        {
                            Value = (object)updateCommand.Account1GroupId ?? DBNull.Value,
                            IsNullable = true
                        });
                        command.Parameters.Add(new SqlParameter("@Account2GroupId", SqlDbType.BigInt)
                        {
                            Value = (object)updateCommand.Account2GroupId ?? DBNull.Value,
                            IsNullable = true
                        });

                        await command.ExecuteNonQueryAsync();
                    }

                    using (var command = connection.CreateCommand())
                    {
                        command.Transaction = tran;
                        command.CommandText =
                            "delete from [valeant].[expenditureDocumentType] where ExpenditureId = @ExpenditureId";
                        command.Parameters.Add(new SqlParameter("@ExpenditureId", SqlDbType.BigInt)
                        {
                            Value = updateCommand.ExpenditureId
                        });
                        await command.ExecuteNonQueryAsync();
                    }

                    foreach (var documentTypeId in updateCommand.Documents)
                    {
                        using (var command = connection.CreateCommand())
                        {
                            command.Transaction = tran;
                            command.CommandText =
                                "insert into [valeant].[expenditureDocumentType] (ExpenditureId, DocumentTypeId) values (@ExpenditureId, @DocumentTypeId)";
                            command.Parameters.Add(new SqlParameter("@ExpenditureId", SqlDbType.BigInt)
                            {
                                Value = updateCommand.ExpenditureId
                            });
                            command.Parameters.Add(new SqlParameter("@DocumentTypeId", SqlDbType.BigInt)
                            {
                                Value = documentTypeId
                            });

                            await command.ExecuteNonQueryAsync();
                        }
                    }

                    foreach (var expenditureLimitDto in updateCommand.Limits)
                    {
                        using (var command = connection.CreateCommand())
                        {
                            command.Transaction = tran;
                            command.CommandText =
                                "update [valeant].[limits] set positiongroup = @positiongroup, limit = @limit where Id = @Id";
                            command.Parameters.Add(new SqlParameter("@Id", SqlDbType.BigInt)
                            {
                                Value = expenditureLimitDto.LimitId
                            });
                            command.Parameters.Add(new SqlParameter("@positiongroup", SqlDbType.BigInt)
                            {
                                Value = expenditureLimitDto.PositionGroup
                            });
                            command.Parameters.Add(new SqlParameter("@limit", SqlDbType.Money)
                            {
                                Value = expenditureLimitDto.Limit
                            });

                            await command.ExecuteNonQueryAsync();
                        }
                    }
                }
                catch (Exception ex)
                {
                    _logger.Error(ex, "Exception occured while creating expenditure");
                    tran.Rollback();
                    throw;
                }

                tran.Commit();
            }
        }


        public static async Task<IEnumerable<ExpenditureInfo>> GetAllExpendituresAsync()
        {
            var sql = new StringBuilder();
            sql.AppendLine(
                @"select Id, Title, ApproverRoleId, GroupLimitCode, CreditGroupId, Account1GroupId, Account2GroupId, IsActive from valeant.expenditures where IsActive = 1");
            sql.AppendLine(@"select ExpenditureId, DocumentTypeId from valeant.expenditureDocumentType");
            sql.AppendLine(@"select Id, PositionGroup, Limit, ExpenditureId from valeant.limits");

            return await ReadObjectAsync(null, sql.ToString(), CommandType.Text, null,
                async reader =>
                {
                    var entities = new List<ExpenditureInfo>();

                    while (await reader.ReadAsync())
                    {
                        var expenditure = new ExpenditureInfo
                        {
                            ExpenditureId = reader.GetInt64(0),
                            Title = reader.GetString(1),
                            IsActive = reader.GetBoolean(7)
                        };

                        if (!reader.IsDBNull(3))
                        {
                            expenditure.GroupLimitCode = reader.GetString(3);
                        }
                        if (!reader.IsDBNull(2))
                        {
                            expenditure.ApproverRoleId = reader.GetInt64(2);
                        }
                        if (!reader.IsDBNull(4))
                        {
                            expenditure.CreditGroupId = reader.GetInt64(4);
                        }
                        if (!reader.IsDBNull(5))
                        {
                            expenditure.Account1GroupId = reader.GetInt64(5);
                        }
                        if (!reader.IsDBNull(6))
                        {
                            expenditure.Account2GroupId = reader.GetInt64(6);
                        }

                        entities.Add(expenditure);
                    }
                    if (reader.NextResult())
                    {
                        while (await reader.ReadAsync())
                        {
                            var documentType = new ExpenditureDocumentType
                            {
                                ExpenditureId = reader.GetInt64(0),
                                DocumentTypeId = reader.GetInt64(1)
                            };

                            var existExpenditure =
                                entities.FirstOrDefault(t => t.ExpenditureId == documentType.ExpenditureId);
                            existExpenditure?.Documents.Add(documentType.DocumentTypeId);
                        }
                    }
                    if (reader.NextResult())
                    {
                        while (await reader.ReadAsync())
                        {
                            var documentType = new ExpenditureLimit
                            {
                                LimitId = reader.GetInt64(0),
                                PositionGroup = reader.GetInt64(1),
                                Limit = reader.GetDecimal(2),
                                ExpenditureId = reader.GetInt64(3)
                            };

                            var existExpenditure =
                                entities.FirstOrDefault(t => t.ExpenditureId == documentType.ExpenditureId);
                            existExpenditure?.Limits.Add(documentType);
                        }
                    }

                    return entities;
                });
        }


        public static async Task<int> DeleteExpenditureAsync(long itemId)
        {
            var sql = @"update [valeant].[expenditures] set IsActive = 0 where Id = @Id";
            return await ExecuteNoQueryAsync(sql, CommandType.Text, new[] { new SqlParameter("@Id", itemId) });
        }

        public static LimitItemCollection ReadLimitItemCollection(string documentType, long positionGroupId)
        {
            var sql = @"select e.Id, e.Title, l.limit, r.Code, e.IsActive from valeant.documenttype dt
                        left join valeant.expenditureDocumentType edt on edt.DocumentTypeId = dt.Id
                        left join valeant.expenditures e on e.Id = edt.ExpenditureId
                        left join valeant.limits l on l.ExpenditureId = e.Id
                        left join valeant.role r on r.Id = e.ApproverRoleId
                        where e.IsActive = 1 and dt.Name = @DocumentType and l.positiongroup = @PositionGroupId";

            return ReadObject(null, sql, CommandType.Text,
                new[]
                {
                    new SqlParameter("@DocumentType", SqlDbType.NVarChar) {Value = documentType},
                    new SqlParameter("@PositionGroupId", SqlDbType.BigInt) {Value = positionGroupId}
                }
                , ReadLimitItemCollection);
        }

        public static Task<LimitItemCollection> ReadLimitItemCollectionAsync(string documentType, long positionGroupId)
        {
            var sql = @"select e.Id, e.Title, l.limit, r.Code, e.IsActive from valeant.documenttype dt
                        left join valeant.expenditureDocumentType edt on edt.DocumentTypeId = dt.Id
                        left join valeant.expenditures e on e.Id = edt.ExpenditureId
                        left join valeant.limits l on l.ExpenditureId = e.Id
                        left join valeant.role r on r.Id = e.ApproverRoleId
                        where dt.Name = @DocumentType and l.positiongroup = @PositionGroupId";

            return ReadObjectAsync(null, sql, CommandType.Text,
                new[]
                {
                    new SqlParameter("@DocumentType", SqlDbType.NVarChar) {Value = documentType},
                    new SqlParameter("@PositionGroupId", SqlDbType.BigInt) {Value = positionGroupId}
                }
                , ReadLimitItemCollectionAsync);
        }

        public static async Task<IEnumerable<ExpenditureLimit>> GetExpenditureLimitsAsync(long expenditureId)
        {
            var sql = @"select Id, PositionGroup, Limit, ExpenditureId from valeant.limits where ExpenditureId = ";
            return await ReadObjectAsync(null, sql, CommandType.Text, null,
                async reader =>
                {
                    var entities = new List<ExpenditureLimit>();

                    while (await reader.ReadAsync())
                    {
                        var expenditure = new ExpenditureLimit
                        {
                            LimitId = reader.GetInt64(0),
                            PositionGroup = reader.GetInt64(1),
                            Limit = reader.GetDecimal(2),
                            ExpenditureId = reader.GetInt64(3)
                        };

                        entities.Add(expenditure);
                    }

                    return entities;
                });
        }

        private static async Task<LimitItemCollection> ReadLimitItemCollectionAsync(SqlDataReader reader)
        {
            var result = new LimitItemCollection();
            if (!reader.HasRows) return result;
            while (await reader.ReadAsync())
            {
                result.Add(new LimitItem
                {
                    Id = reader.GetInt64(0),
                    Name = reader.GetString(1),
                    Limit = reader.GetDecimal(2),
                    RoleCode = reader.IsDBNull(3) ? null : reader.GetString(3),
                    IsActive = reader.GetBoolean(4)
                });

            }
            return result;
        }

        private static LimitItemCollection ReadLimitItemCollection(SqlDataReader reader)
        {
            var result = new LimitItemCollection();
            if (!reader.HasRows) return result;
            while (reader.Read())
            {
                result.Add(new LimitItem
                {
                    Id = reader.GetInt64(0),
                    Name = reader.GetString(1),
                    Limit = reader.GetDecimal(2),
                    RoleCode = reader.IsDBNull(3) ? null : reader.GetString(3),
                    IsActive = reader.GetBoolean(4)
                });
            }
            return result;
        }
    }
}