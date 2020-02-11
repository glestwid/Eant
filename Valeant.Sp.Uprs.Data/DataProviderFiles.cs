using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Microsoft.SqlServer.Server;
using Valeant.Sp.Uprs.Data.Domain;

namespace Valeant.Sp.Uprs.Data
{
    public partial class DataProvider
    {
        private class SqlCountry : IEnumerable<SqlDataRecord>
        {
            internal const string TypeName = "[valeant].[countryType]";
            private readonly IEnumerable<CountryType> _country;

            public SqlCountry(IEnumerable<CountryType> country)
            {
                _country = country;
            }

            public IEnumerator<SqlDataRecord> GetEnumerator()
            {
                if (_country == null || !_country.Any()) yield break;
                var record = new SqlDataRecord(new SqlMetaData("[Code]", SqlDbType.NVarChar, 20),
                    new SqlMetaData("[Name]", SqlDbType.NVarChar, 2000));
                foreach (var item in _country)
                {
                    record.SetString(0, item.Code);
                    record.SetString(1, item.Name);
                    yield return record;
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }
        }

        private class SqlOrganization : IEnumerable<SqlDataRecord>
        {
            internal const string TypeName = "[valeant].[organizationType]";
            private readonly IEnumerable<OrganizationType> _organization;

            public SqlOrganization(IEnumerable<OrganizationType> organization)
            {
                _organization = organization;
            }

            public IEnumerator<SqlDataRecord> GetEnumerator()
            {
                if (_organization == null || !_organization.Any()) yield break;
                var record = new SqlDataRecord(new SqlMetaData("Code", SqlDbType.NVarChar, 20),
                    new SqlMetaData("Value", SqlDbType.NVarChar, 2000),
                    new SqlMetaData("Country", SqlDbType.NVarChar, 20));
                foreach (var item in _organization)
                {
                    record.SetString(0, item.Code);
                    record.SetString(1, item.Value);
                    record.SetString(2, item.Country);
                    yield return record;
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }
        }

        private class SqlCostcenter : IEnumerable<SqlDataRecord>
        {
            internal const string TypeName = "[valeant].[costcenterType]";
            private readonly IEnumerable<CostcenterType> _costcenter;

            public SqlCostcenter(IEnumerable<CostcenterType> costcenter)
            {
                _costcenter = costcenter;
            }

            public IEnumerator<SqlDataRecord> GetEnumerator()
            {
                if (_costcenter == null || !_costcenter.Any()) yield break;
                var record = new SqlDataRecord(new SqlMetaData("Code", SqlDbType.NVarChar, 20),
                    new SqlMetaData("Description", SqlDbType.NVarChar, 2000));
                foreach (var item in _costcenter)
                {
                    record.SetString(0, item.Code);
                    record.SetString(1, item.Description);
                    yield return record;
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }
        }

        private class SqlDepartment : IEnumerable<SqlDataRecord>
        {
            internal const string TypeName = "[valeant].[departmentType]";
            private readonly IEnumerable<DepartmentType> _department;

            public SqlDepartment(IEnumerable<DepartmentType> department)
            {
                _department = department;
            }

            public IEnumerator<SqlDataRecord> GetEnumerator()
            {
                if (_department == null || !_department.Any()) yield break;
                var record = new SqlDataRecord(
                    new SqlMetaData("Code", SqlDbType.NVarChar, 20),
                    new SqlMetaData("Name", SqlDbType.NVarChar, 2000),
                    new SqlMetaData("Parent", SqlDbType.NVarChar, 20),
                    new SqlMetaData("Status", SqlDbType.BigInt),
                    new SqlMetaData("Organization", SqlDbType.NVarChar, 16),
                    new SqlMetaData("CostCenter", SqlDbType.NVarChar, 10)
                    );
                foreach (var item in _department)
                {
                    record.SetString(0, item.Code);
                    record.SetString(1, item.Name);
                    if (item.Parent != null)
                        record.SetString(2, item.Parent);
                    else
                        record.SetDBNull(2);
                    record.SetInt64(3, item.Status);
                    record.SetString(4, item.Organization);
                    record.SetString(5, item.CostCenter);
                    yield return record;
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }
        }

        private class SqlDepartmentCondition : IEnumerable<SqlDataRecord>
        {
            internal const string TypeName = "[valeant].[departmentconditionType]";
            private readonly IEnumerable<DepartmentConditionType> _departmentcondition;

            public SqlDepartmentCondition(IEnumerable<DepartmentConditionType> departmentcondition)
            {
                _departmentcondition = departmentcondition;
            }

            public IEnumerator<SqlDataRecord> GetEnumerator()
            {
                if (_departmentcondition == null || !_departmentcondition.Any()) yield break;
                var record = new SqlDataRecord(
                    new SqlMetaData("Code", SqlDbType.NVarChar, 20),
                    new SqlMetaData("Name", SqlDbType.NVarChar, 100),
                    new SqlMetaData("Value", SqlDbType.NVarChar, 2000)
                    );
                foreach (var item in _departmentcondition)
                {
                    record.SetString(0, item.Code);
                    record.SetString(1, item.Name);
                    record.SetString(2, item.Value);
                    yield return record;
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }
        }

        private class SqlEmploeePosition : IEnumerable<SqlDataRecord>
        {
            internal const string TypeName = "[valeant].[employeepositionType]";
            private readonly IEnumerable<EmployeePositionType> _employeeposition;

            public SqlEmploeePosition(IEnumerable<EmployeePositionType> employeeposition)
            {
                _employeeposition = employeeposition;
            }

            public IEnumerator<SqlDataRecord> GetEnumerator()
            {
                if (_employeeposition == null || !_employeeposition.Any()) yield break;
                var record = new SqlDataRecord(
                    new SqlMetaData("Code", SqlDbType.NVarChar, 20),
                    new SqlMetaData("Value", SqlDbType.NVarChar, 2000)
                    );
                foreach (var item in _employeeposition)
                {
                    record.SetString(0, item.Code);
                    record.SetString(1, item.Value);
                    yield return record;
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }
        }

        private class SqlHuman : IEnumerable<SqlDataRecord>
        {
            internal const string TypeName = "[valeant].[humanType]";
            private readonly IEnumerable<HumanType> _human;

            public SqlHuman(IEnumerable<HumanType> human)
            {
                _human = human;
            }

            public IEnumerator<SqlDataRecord> GetEnumerator()
            {
                if (_human == null || !_human.Any()) yield break;
                var record = new SqlDataRecord(
                    new SqlMetaData("Code", SqlDbType.NVarChar, 20),
                    new SqlMetaData("FullName", SqlDbType.NVarChar, 255),
                    new SqlMetaData("Email", SqlDbType.NVarChar, 320),
                    new SqlMetaData("DocumentSeries", SqlDbType.NVarChar, 10),
                    new SqlMetaData("DocumentNumber", SqlDbType.NVarChar, 20),
                    new SqlMetaData("DocumentIssuedOn", SqlDbType.DateTime),
                    new SqlMetaData("DocumentIssuedBy", SqlDbType.NVarChar, 255),
                    new SqlMetaData("UserAccount", SqlDbType.NVarChar, 255),
                    new SqlMetaData("Birthday", SqlDbType.DateTime),
                    new SqlMetaData("City", SqlDbType.NVarChar, 255)
                    );
                foreach (var item in _human)
                {
                    record.SetString(0, item.Code);
                    record.SetString(1, item.FullName);
                    record.SetString(2, item.Email);
                    record.SetString(3, item.DocumentSeries);
                    record.SetString(4, item.DocumentNumber);
                    record.SetDateTime(5, item.DocumentIssuedOn);
                    record.SetString(6, item.DocumentIssuedBy);
                    if (string.IsNullOrEmpty(item.UserAccount))
                        record.SetDBNull(7);
                    else
                        record.SetString(7, item.UserAccount);

                    record.SetDateTime(8, item.Birthday);
                    record.SetString(9, item.City);
                    yield return record;
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }
        }

        private class SqlEmployee : IEnumerable<SqlDataRecord>
        {
            internal const string TypeName = "[valeant].[employeeType]";
            private readonly IEnumerable<EmployeeType> _employee;

            public SqlEmployee(IEnumerable<EmployeeType> employee)
            {
                _employee = employee;
            }

            public IEnumerator<SqlDataRecord> GetEnumerator()
            {
                if (_employee == null || !_employee.Any()) yield break;
                var record = new SqlDataRecord(
                    new SqlMetaData("ClockNumber", SqlDbType.NVarChar, 20),
                    new SqlMetaData("Human", SqlDbType.NVarChar, 20),
                    new SqlMetaData("Department", SqlDbType.NVarChar, 20),
                    new SqlMetaData("Position", SqlDbType.NVarChar, 20),
                    new SqlMetaData("Status", SqlDbType.BigInt),
                    new SqlMetaData("Manager1stLevel", SqlDbType.NVarChar, 20),
                    new SqlMetaData("Manager2ndLevel", SqlDbType.NVarChar, 20),
                    new SqlMetaData("CostCentre", SqlDbType.NVarChar, 20)
                    );
                foreach (var item in _employee)
                {
                    record.SetString(0, item.ClockNumber);
                    record.SetString(1, item.Human);
                    record.SetString(2, item.Department);
                    record.SetString(3, item.Position);
                    record.SetInt64(4, item.Status);
                    if (string.IsNullOrEmpty(item.Manager1StLevel))
                        record.SetDBNull(5);
                    else
                        record.SetString(5, item.Manager1StLevel);
                    if (string.IsNullOrEmpty(item.Manager2NdLevel))
                        record.SetDBNull(6);
                    else
                        record.SetString(6, item.Manager2NdLevel);
                    if (string.IsNullOrEmpty(item.CostCentre))
                        record.SetDBNull(7);
                    else
                        record.SetString(7, item.CostCentre);
                    yield return record;
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }
        }

        private class SqlBigintTable : IEnumerable<SqlDataRecord>
        {
            internal const string TypeName = "[valeant].[BigintTable]";
            private readonly IEnumerable<long> _ids;

            public SqlBigintTable(IEnumerable<long> ids)
            {
                _ids = ids;
            }

            public IEnumerator<SqlDataRecord> GetEnumerator()
            {
                if (_ids == null || !_ids.Any()) yield break;
                var record = new SqlDataRecord(
                    new SqlMetaData("Id", SqlDbType.BigInt)
                    );
                foreach (var item in _ids)
                {
                    record.SetInt64(0, item);
                    yield return record;
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }
        }

        private class SqlNvarchar255Table : IEnumerable<SqlDataRecord>
        {
            internal const string TypeName = "[valeant].[NVarchar255Table]";
            private readonly IEnumerable<string> _values;

            public SqlNvarchar255Table(IEnumerable<string> values)
            {
                _values = values;
            }

            public IEnumerator<SqlDataRecord> GetEnumerator()
            {
                if (_values == null || !_values.Any()) yield break;
                var record = new SqlDataRecord(
                    new SqlMetaData("value", SqlDbType.NVarChar, 255)
                    );
                foreach (var item in _values)
                {
                    record.SetString(0, item);
                    yield return record;
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }
        }

        private class SqlAttachmentsVersion2 : IEnumerable<SqlDataRecord>
        {
            internal const string TypeName = "[valeant].[attachmenttype]";
            private readonly IEnumerable<AttachmentVersion2> _attachments;

            public SqlAttachmentsVersion2(IEnumerable<AttachmentVersion2> attachments)
            {
                _attachments = attachments;
            }

            public IEnumerator<SqlDataRecord> GetEnumerator()
            {
                if (_attachments == null || !_attachments.Any()) yield break;
                var record = new SqlDataRecord(
                    new SqlMetaData("urn", SqlDbType.NVarChar, 255),
                    new SqlMetaData("content-type", SqlDbType.NVarChar, 255)
                    );
                foreach (var attachment in _attachments)
                {
                    record.SetString(0, attachment.Urn);
                    record.SetString(1, attachment.ContentType);
                    yield return record;
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }
        }

        private class SqlTokenTable : IEnumerable<SqlDataRecord>
        {
            internal const string TypeName = "[valeant].[token]";
            private readonly IEnumerable<Token> _tokens;

            public SqlTokenTable(IEnumerable<Token> tokens)
            {
                _tokens = tokens;
            }

            public IEnumerator<SqlDataRecord> GetEnumerator()
            {
                if (_tokens == null || !_tokens.Any()) yield break;
                var record = new SqlDataRecord(
                    new SqlMetaData("Token", SqlDbType.NVarChar, 15),
                    new SqlMetaData("Tokent", SqlDbType.NVarChar, 15)
                    );
                foreach (var item in _tokens)
                {
                    record.SetString(0, item.Value ?? string.Empty);
                    record.SetString(1, item.Type);
                    yield return record;
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }
        }

        private class SqlMetadataValuesCollection : IEnumerable<SqlDataRecord>
        {
            #region Static fields and constants

            public const string TypeName = "[valeant].[metadatavalues]";

            #endregion

            #region Fields

            private readonly IEnumerable<KeyValuePair<string, string>> _metadata;

            #endregion

            #region Ctor

            public SqlMetadataValuesCollection(IEnumerable<KeyValuePair<string, string>> metadata)
            {
                _metadata = metadata;
            }

            #endregion

            #region IEnumerable<SqlDataRecord> Members

            public IEnumerator<SqlDataRecord> GetEnumerator()
            {
                var record =
                    new SqlDataRecord(new SqlMetaData("Property", SqlDbType.NVarChar, 50L),
                        new SqlMetaData("Value", SqlDbType.NVarChar, 255));
                if (_metadata == null) yield break;
                foreach (var keyValuePair in _metadata)
                {
                    record.SetString(0, keyValuePair.Key);
                    if (keyValuePair.Value != null) record.SetString(1, keyValuePair.Value);
                    else record.SetDBNull(1);
                    yield return record;
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }

            #endregion
        }

        public class TwoLongKey : IEquatable<TwoLongKey>
        {
            private readonly long _keyOne;
            private readonly long _keyTwo;

            public TwoLongKey(long keyOne, long keyTwo)
            {
                _keyOne = keyOne;
                _keyTwo = keyTwo;
            }

            public bool Equals(TwoLongKey other)
            {
                return _keyOne == other._keyOne && _keyTwo == other._keyTwo;
            }

            public override int GetHashCode()
            {
                return 1000 * (int)_keyOne + (int)_keyTwo;
            }
        }
    }
}
