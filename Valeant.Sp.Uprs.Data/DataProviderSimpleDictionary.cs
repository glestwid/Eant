using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Valeant.Sp.Uprs.Data.Domain;

namespace Valeant.Sp.Uprs.Data
{
    public partial class DataProvider
    {
        public static Task<SimpleDictionaryFull> ReadSimpleDictionaryFullAsync(string dictionaryName)
        {
            return ReadObjectAsync(null, "[valeant].[ReadSimpleDictionaryFull]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@typeName", SqlDbType.NVarChar, 255) {Value = dictionaryName}
                }, ReadSimpleDictionaryFullAsync);
        }

        public Task<SimpleDictionary> ReadSimpleDictionaryCollectionAsync(string type)
        {
            return ReadObjectAsync(null, "[valeant].[ReadSimpleDictionary]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@type", SqlDbType.NVarChar, 255) {Value = type}
                }, ReadSimpleDictionaryCollectionAsync);
        }

        public static Task InsertOrUpdateSimpleDictionaryAsync(SimpleDictionaryItem item, string typeName)
        {
            return ExecuteNoQueryAsync("[valeant].[insertorupdatesimpledictionary_version_2]",
                CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = item.Id <= 0 ? DBNull.Value : (object) item.Id},
                    new SqlParameter("@typeName", SqlDbType.NVarChar, 255) {Value = typeName},
                    new SqlParameter("@value", SqlDbType.NVarChar, 1024) {Value = item.Value},
                    new SqlParameter("@advansed", SqlDbType.NVarChar) {Value = (object) item.Advanced ?? DBNull.Value},
                    new SqlParameter("@reference", SqlDbType.BigInt)
                    {
                        Value = item.Reference.HasValue ? (object) item.Reference.Value : DBNull.Value
                    },
                    new SqlParameter("@flag", SqlDbType.Bit)
                    {
                        Value = item.Flag.HasValue ? (object) item.Flag.Value : DBNull.Value
                    },
                    new SqlParameter("@flag1", SqlDbType.Bit)
                    {
                        Value = item.Flag1.HasValue ? (object) item.Flag1.Value : DBNull.Value
                    }
                });
        }

        public static Task DeleteSimpleDictionaryAsync(long id, string typeName)
        {
            return ExecuteNoQueryAsync("[valeant].[removesimpledictionary_version_2]", CommandType.StoredProcedure,
                new[]
                {
                    new SqlParameter("@id", SqlDbType.BigInt) {Value = id},
                    new SqlParameter("@typeName", SqlDbType.NVarChar, 255) {Value = typeName}
                });
        }

        private static async Task<SimpleDictionaryFull> ReadSimpleDictionaryFullAsync(SqlDataReader reader)
        {
            var result = new SimpleDictionaryFull();
            if (!reader.HasRows) return result;
            while (await reader.ReadAsync())
            {
                var id = reader.GetInt64(0);
                var item = new SimpleDictionaryItem
                {
                    Id = id,
                    Type = reader.GetInt64(1),
                    Value = reader.GetString(2),
                    Actual = reader.GetBoolean(3)
                };
                if (!reader.IsDBNull(4)) item.Advanced = reader.GetString(4);
                if (!reader.IsDBNull(5)) item.Reference = reader.GetInt64(5);
                if (!reader.IsDBNull(6)) item.Flag = reader.GetBoolean(6);
                if (!reader.IsDBNull(7)) item.Flag1 = reader.GetBoolean(7);
                result.Add(id, item);
            }
            return result;
        }

        private static async Task<SimpleDictionary> ReadSimpleDictionaryCollectionAsync(SqlDataReader reader)
        {
            var result = new SimpleDictionary();
            if (!reader.HasRows) return result;
            while (await reader.ReadAsync())
            {
                result.Add(reader.GetInt64(0), reader.GetString(1));
            }
            return result;
        }

    }
}