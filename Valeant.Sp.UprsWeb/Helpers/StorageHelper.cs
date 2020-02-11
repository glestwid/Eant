using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using Valeant.Sp.Uprs.Data;

namespace Valeant.Sp.UprsWeb.Helpers {
    public static class StorageHelper {
        private const string UrnNamespace = "urn";
        private static readonly object Locker;
        private static readonly string Path;
        private static readonly int MaxCount;
        private static readonly Regex Regex;
        private static readonly string NameFormat;
        static StorageHelper() {
            Locker = new object();
            Path = DataProvider.Settings["Storage"].Value;
            var countString = DataProvider.Settings["StorageItemCount"].Value;
            MaxCount = int.Parse(countString);
            Regex = new Regex("[0-9]{8}");
            NameFormat = "{0:" + new string('0', 16) + "}";
        }
        public static string SaveFile(string name, byte[] data) {
            lock (Locker) {
                if (!Directory.Exists(Path)) Directory.CreateDirectory(Path);
                var contentDirectories =
                    Directory.EnumerateDirectories(Path).Where(x => Regex.IsMatch(x)).OrderBy(x => x);
                string contentPath;
                int dirsCount;
                long filesCount;
                if (!contentDirectories.Any()) {
                    dirsCount = 1;
                    contentPath = System.IO.Path.Combine(Path, string.Format(NameFormat, dirsCount));
                    Directory.CreateDirectory(contentPath);
                }
                else {
                    dirsCount = contentDirectories.Count();
                    contentPath = System.IO.Path.Combine(Path, string.Format(NameFormat, dirsCount));
                    filesCount =
                        Directory.EnumerateFiles(contentPath).Where(x => Regex.IsMatch(x)).OrderBy(x => x).Count();
                    if (filesCount >= MaxCount) {
                        dirsCount++;
                        contentPath = System.IO.Path.Combine(Path, string.Format(NameFormat, dirsCount));
                        Directory.CreateDirectory(contentPath);
                    }
                }
                var fileList = Directory.EnumerateFiles(contentPath).Where(x => Regex.IsMatch(x)).OrderBy(x => x);
                filesCount = fileList.Count() + 1;
                if (filesCount != 1) {
                    filesCount = long.Parse(System.IO.Path.GetFileName(fileList.Last()).TrimStart('0')) + 1;
                }
                var fileName = System.IO.Path.Combine(contentPath, string.Format(NameFormat, filesCount));

                using (var file = new FileStream(fileName, FileMode.CreateNew, FileAccess.Write, FileShare.None))
                    file.Write(data, 0, data.Length);
                return $"urn:{dirsCount}-{filesCount}";
            }
        }

        public static byte[] Read(string urn) {
            var path = GetPath(urn);
            return File.Exists(path) ? File.ReadAllBytes(path) : null;
        }

        public static string Update(string urn, byte[] data) {
            var path = GetPath(urn);
            lock(Locker) { 
                using (var file = new FileStream(path, FileMode.Create, FileAccess.Write, FileShare.None))
                    file.Write(data, 0, data.Length);
            }
            return urn;
        }

        private static string GetPath(string urn) {
            var nix = urn.Split(':');
            if (nix.Length != 2) throw new Exception(string.Format("urn \"{0}\" error format", urn));
            if (nix[0] != UrnNamespace) throw new Exception(string.Format("urn \"{0}\" error format", urn));
            var items = nix[1].Split('-').Select(long.Parse).ToArray();
            if(items.Count() != 2) throw new Exception(string.Format("urn \"{0}\" error format", urn));
            return System.IO.Path.Combine(Path, string.Format(NameFormat, items[0]), string.Format(NameFormat, items[1]));
        }

        public static void Delete(string urn) {
            var path = GetPath(urn);
            lock(Locker) {
                if (File.Exists(path)) File.Delete(path);
            }
        }
     }
}