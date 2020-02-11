using System.Threading.Tasks;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.UprsWeb.Controllers.Entities;

namespace Valeant.Sp.UprsWeb.Helpers {
    public delegate Task<int> Selector(EntitiesBase document, TokenCollection tokens);
}