using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.Serialization;
using NLog;
using Valeant.Sp.Uprs.Data;
using Valeant.Sp.Uprs.Data.Consts;
using Valeant.Sp.Uprs.Data.Domain;
using Valeant.Sp.Uprs.Data.Matrix;
using Valeant.Sp.Uprs.Data.Query;
using Valeant.Sp.Uprs.Report.Data;
using Valeant.Sp.UprsWeb.Controllers.Entities;
using Valeant.Sp.UprsWeb.Controllers.Utils;
using Valeant.Sp.UprsWeb.Matrix;

namespace Valeant.Sp.UprsWeb.Helpers
{
    internal static class DocumentHelper {
        private static readonly ReaderWriterLockSlim Locker;
        private static readonly Dictionary<Type, XmlSerializer> SerializerContainer;
        private static readonly Logger Logger = LogManager.GetCurrentClassLogger();
        static DocumentHelper() {
            SerializerContainer = new Dictionary<Type, XmlSerializer>();
            Locker = new ReaderWriterLockSlim();
        }

        private static T GetDocumentContent<T>(DocumentBaseVersion3 document, Type type) {
            var serializer = GetSerializer(type);
            var builder = new StringBuilder(document.Content.ToString());
            using (var reader = new StringReader(builder.ToString()))
                return (T)serializer.Deserialize(reader);
        }

        internal static T GetDocumentContent<T>(XElement content) {
            var serializer = GetSerializer(typeof (T));
            var builder = new StringBuilder(content.ToString());
            using (var reader = new StringReader(builder.ToString()))
                return (T)serializer.Deserialize(reader);
        }

        internal static async Task<T> GetEmpty<T>(long id, string actorName, string documentName, MatrixVersion3Decorator matrix) where T : EntitiesBase, new()
        {
            var d = new T();
            var node = matrix.NodesByString["В разработке"];
            var actor = DataProvider.GetHuman(actorName);

            var actualTokensValues = actor.Tokens.Select(x => x.Value);
            var properties = node.Properties.Where(x => !x.Token.Export).Where(x =>
                    actualTokensValues.Contains(x.Token.Calc ? DataProvider.BuildTokens[x.Token.Value](actor).Value : x.Token.Value))
                    .Union(node.Properties.Where(x => x.Token.Export && actualTokensValues.Any(y => y.StartsWith(x.Token.Value)))).ToArray();
            if (!properties.Any()) return default(T);
            var p = properties.First();
            var accessList = p.AccessList.Details;
            d.AccessList = accessList.ToDictionary(x => x.Name, x => x.AccessType.Id);
            d.Actions = p.Actions;
            d.DenyReason = null;
            d.ApprovalPath = new List<string>();
            return d;
        }

        internal static async Task<T> Get<T>(long id, string actorName, string documentName, MatrixVersion3Decorator matrix) where T : EntitiesBase, new()
        {
            if (id == -1)
                return await GetEmpty<T>(id, actorName, documentName, matrix);

            var data = await DataProvider.ReadAdvanceVersion3Async(id, documentName, default(DateTimeOffset), default(DateTimeOffset), null);
            if (data == null || !data.Any()) return default(T);
            var d = data.First();
            var node = matrix.NodesByString[d.Status];
            var actor = DataProvider.GetHuman(actorName);
            var owner = await DataProvider.ReadAdvanceCreatorAsync(d.Id);
            var actualTokensValues = actor.AllTokens.Select(x => x.Value).Intersect(d.Tokens.Select(y => y.Value)).ToArray();
            var o = GetDocumentContent<T>(d, typeof(T));
            o.Number = d.Number;
            o.Id = d.Id;
            o.DenyReason = null;
            if (actualTokensValues.Any(x => x.Equals(RoleCode.Administrator, StringComparison.InvariantCultureIgnoreCase)))
            {
                var accesslist = node.Properties.First().AccessList.Details.ToDictionary(x => x.Name, x => 2L);
                var acts = node.Properties.SelectMany(x => x.Actions).Distinct().OrderBy(x => x).ToArray();
                o.AccessList = accesslist;
                o.Actions = acts;
            }
            else {
                NodePropertyVersion3[] properties = null;
                properties = node.Properties.Where(x => !x.Token.Export).Where(x =>
                    actualTokensValues.Contains(x.Token.Calc ? DataProvider.BuildTokens[x.Token.Value](owner).Value : x.Token.Value))
                    .Union(node.Properties.Where(x => x.Token.Export && actualTokensValues.Any(y => y.StartsWith(x.Token.Value)))).ToArray();

                if (properties != null && !properties.Any())
                    return default(T);
                var p = properties.First();
                var actions = p.Actions;
                var accessList = p.AccessList.Details;

                o.AccessList = accessList.ToDictionary(x => x.Name, x => x.AccessType.Id);
                o.Actions = actions;
            }
            var approvalPath = new List<string>();
            var intersections = matrix.Intersections.Where(x => x.ApprovalSheetItem != null && x.ApprovalSheetItem.IsSubValue(d.ProcessSubType))
                .OrderBy(x => x.ApprovalSheetItem, new ApprovalSheetItemOComparer());
            var approvals = matrix.Intersections.Where(x => x.ApprovalSheetItem != null && x.ApprovalSheetItem.IsSubValue(d.ProcessSubType))
                .Where(x => x.ApprovalSheetItem.IsPrimary).Select(x => x.ApprovalSheetItem).Distinct(new ApprovalSheetItemComparer()).OrderBy(x => x, new ApprovalSheetItemOComparer());
            if (d.ApprovalSheets == null)
            {
                approvalPath.AddRange(approvals.Select(item => intersections
                    .FirstOrDefault(x => x.ApprovalSheetItem.ToString().Equals(item.ToString(), StringComparison.CurrentCultureIgnoreCase)))
                    .Select(intersection => intersection.ApprovalSheetItem.IsEx
                        ? $"{intersection.To.State.ApprovalSheetTitle} (опционально)"
                        : intersection.To.State.ApprovalSheetTitle));
            }
            else
            {
                approvalPath.AddRange(d.ApprovalSheets.Select(item => intersections
                    .FirstOrDefault(x => x.ApprovalSheetItem.ToString().Equals(item.ToString(), StringComparison.CurrentCultureIgnoreCase)))
                    .Select(intersection => intersection.To.State.ApprovalSheetTitle));
                if (matrix.Intersections.Any(x => x.From.State.Name == d.Status))
                {
                    var lastApproval = d.ApprovalSheets.Last();
                    var other = intersections.SkipWhile(x => !lastApproval.Equals(x.ApprovalSheetItem));
                    var otherArray = other.Skip(1).Where(x => x.ApprovalSheetItem.IsPrimary).ToArray();
                    approvalPath.AddRange(otherArray.Select(item => item.ApprovalSheetItem.IsEx
                        ? $"{item.To.State.ApprovalSheetTitle} (опционально)"
                        : item.To.State.ApprovalSheetTitle));
                }
            }
            o.ApprovalPath = approvalPath;
            return o;
        }
        
        internal static async Task<T[]> GetAll<T>(string statusFilter, string dateRangeFilter, string actorName, string documentName, Func<AdvanceVersion3,T> convert) {
            try {
                var dateRange = GridFilterHelpers.GetRange(dateRangeFilter);
                var actor = DataProvider.GetHuman(actorName);
                AdvanceCollectionVersion3 data;
                if (statusFilter == null || statusFilter.Equals("Все", StringComparison.InvariantCultureIgnoreCase))
                    data = await DataProvider.ReadAdvanceVersion3Async(null, documentName, dateRange.DateStart, dateRange.DateEnd, actor.AllTokens.Where(x => x.Type == "O*").Select(x => x.Value).ToArray());
                else
                    data = await DataProvider.ReadAdvanceFilterVersion3Async(null, statusFilter, documentName, dateRange.DateStart, dateRange.DateEnd, actor.AllTokens.Where(x => x.Type == "O*").Select(x => x.Value).ToArray());
                return data?.Select(convert).ToArray();
            }
            catch (AggregateException ex) {
                var flatten = ex.Flatten();
                var inner = flatten.InnerExceptions;
                foreach (var e in inner) Logger.Error(e);
                throw flatten;
            }
            catch (Exception ex) {
                for (var e = ex; e != null; e = e.InnerException) Logger.Error(e);
                throw;
            }
        }

        internal static async Task<T[]> GetAllForReport<T>(string actorName, string documentName, Func<AdvanceVersion3, T> convert)
        {
            try
            {
                var actor = DataProvider.GetHuman(actorName);
                var data = await DataProvider.GetTripRequestsForAdvanceReport(actor.AllTokens.Where(x => x.Type == "O*").Select(x => x.Value).ToArray());
                return data?.Select(convert).ToArray();
            }
            catch (AggregateException ex)
            {
                var flatten = ex.Flatten();
                var inner = flatten.InnerExceptions;
                foreach (var e in inner) Logger.Error(e);
                throw flatten;
            }
            catch (Exception ex)
            {
                for (var e = ex; e != null; e = e.InnerException) Logger.Error(e);
                throw;
            }
        }

        internal static async Task<IEnumerable<T>> GetByQueryAsync<T>(DocumentQuery query, Func<AdvanceVersion3, T> convert)
        {
            try
            {
                var data = await DataProvider.GetDocumentsByQueryAsync(query);
                return data.Select(convert).AsEnumerable();
            }
            catch (AggregateException ex)
            {
                var flatten = ex.Flatten();
                var inner = flatten.InnerExceptions;
                foreach (var e in inner) Logger.Error(e);
                throw flatten;
            }
            catch (Exception ex)
            {
                for (var e = ex; e != null; e = e.InnerException) Logger.Error(e);
                throw;
            }
        }

        internal static async Task<T[]> GetAll<T>(string statusFilter, string dateRangeFilter, string actorName, Func<AdvanceVersion3, T> convert) {
            try {
                var dateRange = GridFilterHelpers.GetRange(dateRangeFilter);
                var actor = DataProvider.GetHuman(actorName);
                var tokens = actor.AllTokens.Where(x => x.Type != "O*").Select(x => x.Value).ToArray();
                AdvanceCollectionVersion3 data;
                if (statusFilter == null || statusFilter.Equals("Все", StringComparison.InvariantCultureIgnoreCase))
                    data = await DataProvider.ReadAllAdvanceVersion3Async(null, dateRange.DateStart, dateRange.DateEnd, tokens);
                else
                    data = await DataProvider.ReadAllAdvanceFilterVersion3Async(null, statusFilter, dateRange.DateStart, dateRange.DateEnd, tokens);

                return data?.Select(convert).ToArray();
            }
            catch (AggregateException ex) {
                var flatten = ex.Flatten();
                var inner = flatten.InnerExceptions;
                foreach (var e in inner) Logger.Error(e);
                throw flatten;
            }
            catch (Exception ex) {
                for (var e = ex; e != null; e = e.InnerException) Logger.Error(e);
                throw;
            }
        }

        /// <summary>
        /// Returns collection of all approved advances, filtered and mapped.
        /// </summary>
        /// <typeparam name="T">Mapping type.</typeparam>
        /// <returns>Collection of mapped objects.</returns>
        internal static async Task<T[]> GetAllApprovedAsync<T>(string statusName, string dateRangeFilter, string actorName, string documentType, Func<AdvanceVersion3, T> convert)
        {
            try
            {
                var dateRange = GridFilterHelpers.GetRange(dateRangeFilter);
                var actor = DataProvider.GetHuman(actorName);
                var tokens = actor.Tokens.Where(x => x.Type != "O*").Select(x => x.Value).ToArray();
                var data = await DataProvider.ReadAdvanceFilterVersion3Async(null, statusName, documentType, dateRange.DateStart, dateRange.DateEnd, tokens);
                return data?.Select(convert).ToArray();
            }
            catch (AggregateException ex)
            {
                var flatten = ex.Flatten();
                var inner = flatten.InnerExceptions;
                foreach (var e in inner) Logger.Error(e);
                throw flatten;
            }
            catch (Exception ex)
            {
                for (var e = ex; e != null; e = e.InnerException) Logger.Error(e);
                throw;
            }
        }

        internal static XElement SetDocumentContent<T>(T source, Type type) {
            var serializer = GetSerializer(type);
            var builder = new StringBuilder();
            using (var writer = new StringWriter(builder))
                serializer.Serialize(writer, source);
            var s = builder.ToString();
            XElement element;
            using (var reader = new StringReader(s))
                element = XElement.Load(reader);
            return element;
        }

        private static XmlSerializer GetSerializer(Type type) {
            Locker.EnterUpgradeableReadLock();
            try {
                if (!SerializerContainer.ContainsKey(type)) {
                    Locker.EnterWriteLock();
                    try {
                        var serializer = new XmlSerializer(type);
                        SerializerContainer.Add(type, serializer);
                        return serializer;
                    }
                    finally {
                        Locker.ExitWriteLock();
                    }
                }
                else {
                    return SerializerContainer[type];
                }
            }
            finally {
                Locker.ExitUpgradeableReadLock();
            }
        }

        internal static async Task<DocumentSaveResult> ProcessDocument(EntitiesBase data, string documentName, DateTimeOffset advanceDate, 
                decimal sum, string documentType, string actionName, Human actor, string baseUrl, string comment, MatrixVersion3Decorator matrix, 
                Func<Human, string> subProcessResolver, MetadataCollection metadata = null) {
            var owner = actor;
            var processSubType = subProcessResolver(owner);
            long? id = null;
            var state = "В разработке";
            var tokensCollection = new TokenCollection();
            actionName = actionName.Trim();
            AdvanceVersion3 advance = null;

            if (data.Status != null) {
                var advancec = await DataProvider.ReadAdvanceVersion3Async(data.Id, documentName, default(DateTimeOffset), default(DateTimeOffset), null);
                advance = advancec.First();
                state = advance.Status;
                owner = await DataProvider.ReadAdvanceCreatorAsync(data.Id);
                id = data.Id;
                data.Number = advance.Number;
            }

            if (matrix.NodesByString.ContainsKey(state)) {
                var node = matrix.NodesByString[state];
                var properties = node.Properties.Where(x => x.Actions.Any(z => z == actionName) && actor.AllTokens.Select(y => y.Type).Contains(x.Token.Value)).ToArray();
                if (properties.Any()) {
                    var property = properties.First();
                    if (property.ExpressionDelegate != null) {
                        property.CallExpression(data, actionName, owner, actor);
                    }
                }
            }

            var intersections = matrix.Intersections.Where(x => x.From.State.Name == state && x.CheckCondition(actionName, owner, actor, data, matrix, tokensCollection)).ToArray();
            var approvalSheet = advance?.ApprovalSheets?.ToString();

            if (!intersections.Any()) throw new Exception("Переход не найден");
            if (intersections.Length > 1) throw new Exception("Переход не однозначен");
            var intersection = intersections.First();
            if (intersection.PostFuncDelegate != null)
                intersection.CallPostFunc(data, actionName, owner, actor);
            //Куда
            //Набираем токены
            if (intersection.To.Properties.Exists(x => x.Token.Value == "SYSTEM")) {
                intersection = RunSystemStep(intersection.To, matrix, owner, actor, data, tokensCollection);
            }

            var toNode = intersection.To;
            var tokens = toNode.Properties.Select(x => x.Token);
            tokensCollection.AddRange(tokens.Where(x => !x.Export).Select(x => new Token { Type = x.Value, Value = x.Calc ? DataProvider.BuildTokens[x.Value](owner).Value : x.Value }));
            if(!tokensCollection.Any(x => x.Value.Equals(RoleCode.Administrator, StringComparison.InvariantCultureIgnoreCase)))
                tokensCollection.Add(new Token { Value = RoleCode.Administrator, Type = RoleCode.Administrator });
            var type = data.GetType().FullName;
            data.Status = toNode.State.Name;
            var element = SetDocumentContent(data, data.GetType());

            if (intersection.ApprovalSheetItem != null) {
                var tmp = intersection.ApprovalSheetItem.ToString();
                approvalSheet = approvalSheet == null ? tmp : $"{approvalSheet},{tmp}";
            }

            tokensCollection = new TokenCollection(tokensCollection.Distinct(TokenCollection.Comparer));

            var documentData = await DataProvider.InsertOrUpdateAdvance(id, advanceDate, documentType, sum, toNode.State.Name, type, element, actor.Id, 
                            DateTimeOffset.Now, tokensCollection, actionName, comment, approvalSheet, intersection.ClearApprovalSheet, processSubType, metadata);

            var result = new DocumentSaveResult
                         {
                             Id = documentData.Item1,
                             Number = documentData.Item2,
                             Notifications = intersection.To.Properties.Where(x => x.Notifications != null).Where(y => !y.Token.Export).Select(x =>
                                 new DocumentSaveResult.NotificationsData
                                 {
                                     Notification = x.Notifications,
                                     Resipients = GetMailAddress(x.Token.Calc ? DataProvider.BuildTokens[x.Token.Value](owner).Value : x.Token.Value).ToList()
                                 }).ToList()
                         };

            return result;
        }

        private static IntersectionVersion3Decorator RunSystemStep(NodeVersion3 node, MatrixVersion3Decorator matrix, Human owner, Human actor, EntitiesBase data, TokenCollection tokens) {
            var intersections = matrix.Intersections.Where(x => x.From.State.Name == node.State.Name);// && x.CheckCondition("Empty", owner, actor, data, matrix, tokens)).ToArray();
            IntersectionVersion3Decorator intersection = null;
            foreach (var item in intersections) {
                var tempTokenCollection = new TokenCollection();
                if (!item.CheckCondition("Empty", owner, actor, data, matrix, tempTokenCollection)) continue;
                if(intersection != null) throw new Exception("Переход не однозначен");
                tokens.AddRange(tempTokenCollection);
                intersection = item;
            }

            if (intersection == null) throw new Exception("Переход не найден");
            if (intersection.PostFuncDelegate != null) intersection.CallPostFunc(data, owner, actor);
            return intersection.To.Properties.Exists(x => x.Token.Value == "SYSTEM") ? RunSystemStep(intersection.To, matrix, owner, actor, data, tokens) : intersection;
        }

        private static IEnumerable<string> GetMailAddress(string token)
        {
            return DataProvider.Humans.Where(x => x.AllTokens.Select(y => y.Value).Contains(token)).Select(z => z.Email);
        }

        public static async Task< IEnumerable<GiftRequestMetadataForReport>> ReadAllGiftRequestMetadataForReport(string dateRangeFilter)
        {
            var dateRange = GridFilterHelpers.GetRange(dateRangeFilter);
            var res = await DataProvider.ReadViaDapper< GiftRequestMetadataForReport>("valeant.ReadAllGiftRequestMetadataForReport", dateRange.DateStart, dateRange.DateEnd);
            return res;
        }
    }
}