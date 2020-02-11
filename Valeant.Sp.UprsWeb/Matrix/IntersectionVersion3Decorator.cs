using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using Valeant.Sp.Uprs.Data.Matrix;
using DynamicExpression = Valeant.Sp.UprsWeb.Data.Dynamic.DynamicExpression;

namespace Valeant.Sp.UprsWeb.Matrix {
    public class IntersectionVersion3Decorator : IntersectionVersion3 {
        public Delegate CondituionDelegate { get; }
        public Delegate PostFuncDelegate { get; }
        public IntersectionVersion3Decorator(IntersectionVersion3 baseIntersection, ICollection<Type> conditionAdditionalTypes, 
            ParameterExpression[] conditionParameters, ICollection<Type> postFuncAdditionalTypes, ParameterExpression[] postFuncParameters) 
            : this(baseIntersection.Id, baseIntersection.From, baseIntersection.To, baseIntersection.Condition, 
                  baseIntersection.Document, baseIntersection.PostFunc, conditionAdditionalTypes, conditionParameters,
                  postFuncAdditionalTypes, postFuncParameters, baseIntersection.ApprovalSheetItem?.ToString(), baseIntersection.ClearApprovalSheet) {
        }

        private IntersectionVersion3Decorator(long id, NodeVersion3 @from, NodeVersion3 to, string condituion, 
            long document, string postFunc, ICollection<Type> conditionAdditionalTypes, ParameterExpression[] conditionParameters, 
            ICollection<Type> postFuncAdditionalTypes, ParameterExpression[] postFuncParameters, string approvalSheetItem, bool clearApprovalSheet) 
            : base(id, @from, to, condituion, document, postFunc, approvalSheetItem, clearApprovalSheet) {
            CondituionDelegate = DynamicExpression.ParseLambda(conditionParameters, typeof(bool), Condition, conditionAdditionalTypes, null).Compile();
            if(postFunc != null)
                PostFuncDelegate = DynamicExpression.ParseLambda(postFuncParameters, typeof(bool), postFunc, postFuncAdditionalTypes, null).Compile();
            foreach (var property in From.Properties) {
                if (property.Expression != null)
                    property.ExpressionDelegate = DynamicExpression.ParseLambda(postFuncParameters, typeof(bool), property.Expression, postFuncAdditionalTypes, null).Compile();
            }
            foreach (var property in To.Properties)
            {
                if (property.Expression != null) 
                    property.ExpressionDelegate = DynamicExpression.ParseLambda(postFuncParameters, typeof(bool), property.Expression, postFuncAdditionalTypes, null).Compile();
            }
        }

        public bool CheckCondition(params object[] args) {
            return (bool) CondituionDelegate.DynamicInvoke(args);
        }

        public void CallPostFunc(params object[] args) {
            PostFuncDelegate.DynamicInvoke(args);
        }
    }
}
