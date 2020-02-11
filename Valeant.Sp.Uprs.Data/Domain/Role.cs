using System.Data.SqlClient;

namespace Valeant.Sp.Uprs.Data.Domain {
    public class Role {
        public long Id;
        public string Name;
        public string Code;
        public bool IsAdministrator { get; set; }

        public static Role FromSqlDataReader(SqlDataReader reader)
        {
            var roleId = reader.GetInt64(0);
            var roleName = reader.GetString(1);
            var isAdministrator = reader.GetBoolean(3);
            var roleCode = reader.GetString(4);

            var r = new Role {Id = roleId, Name = roleName, IsAdministrator = isAdministrator, Code = roleCode};
            return r;
        }

        public override string ToString()
        {
            return this.Name;
        }
    }
}
