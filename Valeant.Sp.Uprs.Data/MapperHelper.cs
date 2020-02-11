using System;
using System.Linq;
using AutoMapper;

namespace Valeant.Sp.Uprs.Data
{
    public static class MapperHelper
    {
        public static IMappingExpression<TSource, TDestination> IgnoreAllNonExisting<TSource, TDestination>
            (this IMappingExpression<TSource, TDestination> expression, bool isUseServices = true)
        {
            Type sourceType = typeof(TSource);
            Type destinationType = typeof(TDestination);
            TypeMap existingMaps = AutoMapper.Mapper.GetAllTypeMaps().First(x => x.SourceType == sourceType && x.DestinationType == destinationType);
            foreach (string property in existingMaps.GetUnmappedPropertyNames())
            {
                expression.ForMember(property, opt => opt.Ignore());
            }

            if (isUseServices)
            {
                expression = expression.ConstructUsingServiceLocator();
            }

            return expression;
        }

        public static IMappingExpression<TSource, TDestination> IgnoreAllNonExistingService<TSource, TDestination>
            (this IMappingExpression<TSource, TDestination> expression)
        {
            return IgnoreAllNonExisting(expression, false);
        }
    }
}
