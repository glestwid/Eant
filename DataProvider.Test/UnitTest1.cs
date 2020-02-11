using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Valeant.Sp.Uprs.Data;

namespace DataProvider.Test
{
    [TestClass]
    public class UnitTest1 {
        [TestMethod]
        public void TestMethod1() {
            var provider = new Valeant.Sp.Uprs.Data.DataProvider();
            var humans = Valeant.Sp.Uprs.Data.DataProvider.Humans;
            var human = Valeant.Sp.Uprs.Data.DataProvider.GetHuman("WIN-OU97UVALM34\\xrxAdmin");
            var dictionary = provider.ReadSimpleDictionaryCollectionAsync("Expenditure").Result;
        }
    }
}
