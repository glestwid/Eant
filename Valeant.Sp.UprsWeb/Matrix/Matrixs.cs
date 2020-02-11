using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using Valeant.Sp.Uprs.Data;

namespace Valeant.Sp.UprsWeb.Matrix {
    public static class Matrixs {
        public static MatrixVersion3Decorator Get(long documentId, ICollection<Type> conditionAdditionalTypes,
            ParameterExpression[] conditionParameters, ICollection<Type> selectorConditionAdditionalTypes, ParameterExpression[] selectorConditionParameters) {
            var matrix = DataProvider.GetMatrix(documentId);
            return new MatrixVersion3Decorator(matrix.Intersections, conditionAdditionalTypes, conditionParameters, selectorConditionAdditionalTypes, selectorConditionParameters);
        }
    }
}