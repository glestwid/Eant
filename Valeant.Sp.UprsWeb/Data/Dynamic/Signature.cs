using System;
using System.Collections.Generic;
using System.Linq;

namespace Valeant.Sp.UprsWeb.Data.Dynamic
{
	internal class Signature : IEquatable<Signature>
	{
		public DynamicProperty[] Properties;
		public readonly int HashCode;

		public Signature(IEnumerable<DynamicProperty> properties)
		{
		    var dynamicProperties = properties as DynamicProperty[] ?? properties.ToArray();
		    Properties = dynamicProperties.ToArray();
			HashCode = 0;
			foreach (var p in dynamicProperties)
			{
				HashCode ^= p.Name.GetHashCode() ^ p.Type.GetHashCode();
			}
		}

		public override int GetHashCode()
		{
			return HashCode;
		}

		public override bool Equals(object obj)
		{
			return obj is Signature && Equals((Signature)obj);
		}

		public bool Equals(Signature other)
		{
			if (Properties.Length != other.Properties.Length)
				return false;
		    return !Properties.Where((t, i) => t.Name != other.Properties[i].Name || t.Type != other.Properties[i].Type).Any();
		}
	}
}
