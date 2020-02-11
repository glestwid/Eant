using System;
using Valeant.Sp.Uprs.Data.Domain;

namespace Valeant.Sp.Uprs.Data.Matrix {
    public class NodePropertyVersion3 : MatrixBase {
        public TokenVersion3 Token { get; private set; }
        public DocumentAccessListVersion3 AccessList { get; private set; }
        public NotificationVersion3 Notifications { get; private set; }
        public string[] Actions { get; private set; }
        public string Expression;
        public Delegate ExpressionDelegate { get; set; }
        public NodePropertyVersion3(long id, TokenVersion3 token, DocumentAccessListVersion3 accessList, NotificationVersion3 notifications, string[] actions, string expression) : base(id) {
            Token = token;
            AccessList = accessList;
            Notifications = notifications;
            Actions = actions;
            Expression = expression;
        }
        public void CallExpression(params object[] args) {
            ExpressionDelegate.DynamicInvoke(args);
        }
    }
}
