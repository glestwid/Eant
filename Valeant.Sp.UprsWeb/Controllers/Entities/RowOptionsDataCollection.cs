using System.Collections.Generic;
using Newtonsoft.Json;

namespace Valeant.Sp.UprsWeb.Controllers.Entities
{
    public sealed class RowOptionsDataCollection<TRow, TOptions>
        where TRow : IRow, new()
        where TOptions : IOptions, new()
    {
        public RowOptionsDataCollection()
        {
            Rows = new List<TRow>();
            Options = new TOptions();
        }

        [JsonProperty(PropertyName = "rows")]
        public List<TRow> Rows { get; set; }

        [JsonProperty(PropertyName = "options")]
        public TOptions Options { get; set; }
    }

    public interface IRow
    {
        int Order { get; set; }
    }

    public interface IOptions
    {
    }
}