﻿using System;

namespace Valeant.Sp.UprsWeb.Data.Dynamic
{
	public class DynamicProperty
	{
	    public DynamicProperty(string name, Type type)
		{
			if (name == null)
				throw new ArgumentNullException(nameof(name));
			if (type == null)
				throw new ArgumentNullException(nameof(type));
			Name = name;
			Type = type;
		}

		public string Name { get; }

	    public Type Type { get; }
	}

}
