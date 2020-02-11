using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using Valeant.Sp.Uprs.Data.Matrix;

namespace Valeant.Sp.UprsWeb.Matrix  {
    public class MatrixVersion3Decorator {
        public MatrixVersion3Decorator(IEnumerable<IntersectionVersion3> intersections, ICollection<Type> conditionAdditionalTypes,
            ParameterExpression[] conditionParameters, ICollection<Type> postFuncAdditionalTypes, ParameterExpression[] postFuncParameters) {
            Intersections = new List<IntersectionVersion3Decorator>();
            Intersections.AddRange(intersections.Select(x => new IntersectionVersion3Decorator(x, conditionAdditionalTypes, conditionParameters,
                postFuncAdditionalTypes, postFuncParameters)));
            NodesByString = Intersections.Select(x => x.From).Union(Intersections.Select(x => x.To)).Distinct().ToDictionary(x => x.State.Name, x=>x);
            NodesByLong = Intersections.Select(x => x.From).Union(Intersections.Select(x => x.To)).Distinct().ToDictionary(x => x.State.Id, x => x);
        }
        public List<IntersectionVersion3Decorator> Intersections { get; }
        public Dictionary<string, NodeVersion3> NodesByString { get; }
        private Dictionary<long, NodeVersion3> NodesByLong { get; }
    }
}