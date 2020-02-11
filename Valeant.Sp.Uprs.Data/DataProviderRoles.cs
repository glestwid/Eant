using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Valeant.Sp.Uprs.Data.Domain;

namespace Valeant.Sp.Uprs.Data
{
    public partial class DataProvider
    {
        public static async Task CreateRole(Role role)
        {
            var sql = "insert into [valeant].[role] ([Name],[IsAdministrator],[Code]) values (@name, @isAdmin, @code)";

            await ExecuteNoQueryAsync(sql, CommandType.Text, new[]
            {
                new SqlParameter("@name", SqlDbType.NVarChar, 255) {Value = role.Name},
                new SqlParameter("@isAdmin", SqlDbType.Bit) {Value = role.IsAdministrator},
                new SqlParameter("@code", SqlDbType.NChar, 10) {Value = role.Code}
            });
        }

        public static async Task UpdateRole(Role role)
        {
            string sql = @"update [valeant].[role] set Name = @name, IsAdministrator = @isAdmin, Code = @code where Id = @id";

            await ExecuteNoQueryAsync(sql, CommandType.Text, new[]
            {
                new SqlParameter("@id", SqlDbType.BigInt) {Value = role.Id},
                new SqlParameter("@name", SqlDbType.NVarChar, 255) {Value = role.Name},
                new SqlParameter("@isAdmin", SqlDbType.Bit) {Value = role.IsAdministrator},
                new SqlParameter("@code", SqlDbType.NChar, 10) {Value = role.Code}
            });
        }

        public static RoleCollection ReadHumanRoles(string userAccount)
        {
            var sql = @"select r.Id, r.Name, r.Code from valeant.HumanRoles r
                        left join valeant.Humans h on h.Id = r.HumanId
                        where h.UserAccount = @userAccount";

            return ReadObject(null, sql, CommandType.Text,
                new[]
                {
                    new SqlParameter("@userAccount", SqlDbType.NVarChar, 255) {Value = userAccount}
                }, ReadRoleCollection);
        }

        public static Task<RoleCollection> ReadRolesAsync()
        {
            return ReadObjectAsync(null, "[valeant].[ReadRoles]", CommandType.StoredProcedure, null,
                ReadRoleCollectionAsync);
        }

        public static RoleCollection ReadRoles()
        {
            return ReadObject(null, "[valeant].[ReadRoles]", CommandType.StoredProcedure, null, ReadRoleCollection);
        }

        private static async Task<RoleCollection> ReadRoleCollectionAsync(SqlDataReader reader)
        {
            var result = new RoleCollection();
            if (!reader.HasRows) return result;
            while (await reader.ReadAsync())
            {
                result.Add(new Role { Id = reader.GetInt64(0), Name = reader.GetString(1), Code = reader.GetString(2) });
            }
            return result;
        }

        private static RoleCollection ReadRoleCollection(SqlDataReader reader)
        {
            var result = new RoleCollection();
            if (!reader.HasRows) return result;
            while (reader.Read())
            {
                result.Add(new Role { Id = reader.GetInt64(0), Name = reader.GetString(1), Code = reader.GetString(2) });
            }
            return result;
        }
    }
}