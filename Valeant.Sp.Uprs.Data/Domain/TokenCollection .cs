using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Xml;

namespace Valeant.Sp.Uprs.Data.Domain {
    public class TokenCollection : Collection<Token> {
        public static TokenComparer Comparer = new TokenComparer();
        public TokenCollection() { }

        public TokenCollection(IEnumerable<Token> items) {
            AddRange(items);
        }
        public void AddRange(IEnumerable<Token> tokens)
        {
            foreach(var token in tokens) Add(token);
        }
    }

    public class TokenComparer : IEqualityComparer<Token> {
        public bool Equals(Token x, Token y) {
            return x.Value.Equals(y.Value, StringComparison.CurrentCultureIgnoreCase);
        }

        public int GetHashCode(Token obj) {
            return obj.Value.GetHashCode();
        }
    }
}
