using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

namespace Valeant.Sp.UprsWeb.Controllers.Utils
{
    
     public  class CSVDataSet
    {
        public static char Delimeter = ';';
        public static int Codepage = 1251;


        public static DataSet GetData(Stream input)
        {
            string strLine;
            string[] strArray;
            char[] charArray = new char[] { Delimeter };
            DataSet ds = new DataSet();
            DataTable dt = ds.Tables.Add("Data");
            StreamReader sr = new StreamReader(input, Encoding.GetEncoding(Codepage));

            try
            {
                
                strLine = sr.ReadLine();

                strArray = strLine.Split(charArray);

                int ncol = strArray.Length;

                if (ncol == 0)
                    throw (new Exception("Неверный формат входного файла."));

                for (int x = 0; x <= strArray.GetUpperBound(0); x++)
                {
                    string colName = strArray[x].Trim();
                    if (colName.Length == 0)
                        colName = String.Format("COL{0}", x);
                    dt.Columns.Add(colName);
                }

                while ((strLine = sr.ReadLine()) != null)
                {
                    strArray = strLine.Split(charArray);

                    if(strArray.Length!=ncol)
                        continue;

                    DataRow dr = dt.NewRow();
                    for (int i = 0; i <= strArray.GetUpperBound(0); i++)
                    {

                        dr[i] = strArray[i].Trim();
                    }
                    dt.Rows.Add(dr);
                   
                }
               
            }
            catch (Exception e)
            {
                throw (e);
            }

            finally
            {
                sr.Close();
            }

            
            return ds;
        }


    }
}