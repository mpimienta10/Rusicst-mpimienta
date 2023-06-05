using Microsoft.Office.Interop.Excel;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Mininterior.RusicstMVC.Servicios.Helpers
{
    public class ExcelAppFacade
    {

        class WorkbookEntry
        {
            public string filename;
            public Workbook workbook;
            public string name;
        }
        const string TEMP_LOCATION = @"C:\temp";

        static Application _APP;
        static object _APP_LOCK = new object();
        static IDictionary<string, WorkbookEntry> _WORKBOOKS = new Dictionary<string, WorkbookEntry>();

        public static Workbook Load(byte[] bytes, string name)
        {
            string filename = null;
            try
            {
                filename = _SaveBytesToTempFile(bytes);
                return Load(filename, name);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static Workbook Load(string filename, string name)
        {
            try
            {
                Application app = _GetExcelApp();
                app.ScreenUpdating = false;
                Workbook wb = app.Workbooks.Open(filename);
                WorkbookEntry entry = new WorkbookEntry()
                {
                    filename = filename,
                    name = name,
                    workbook = wb
                };
                _WORKBOOKS[name] = entry;
                return wb;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static Application _GetExcelApp()
        {
            if (_APP == null)
            {
                lock (_APP_LOCK)
                {
                    if (_APP == null)
                    {
                        _APP = new Application();
                    }
                }
            }
            return _APP;
        }

        private static string _SaveBytesToTempFile(byte[] bytes)
        {
            string path = Path.Combine(TEMP_LOCATION, String.Format("{0}.xls", Guid.NewGuid().ToString()));
            File.WriteAllBytes(path, bytes);
            return path;
        }

        public static void Close(string name)
        {
            if (_WORKBOOKS.ContainsKey(name))
            {
                WorkbookEntry e = _WORKBOOKS[name];
                e.workbook.Close(false);
                File.Delete(e.filename);
                _WORKBOOKS.Remove(name);
            }
        }

        public static void SetStringValue(Worksheet ws, int row, int col, string text)
        {
            ws.Cells[row, col] = text;
            //var range = GetRange(ws, row, col);
            //range.Value2 = text;
        }

        public static string GetStringValue(Worksheet sDef, int row, int col)
        {
            var range = GetRange(sDef, row, col);
            var value = range.Value2;
            if (value == null)
                return null;
            if (value is string)
                return value;

            return value.ToString();
        }

        public static Range GetRange(Worksheet sLayout, int row, int col)
        {
            return (Range)sLayout.Cells[row, col];
        }

        public static Workbook New()
        {
            return _GetExcelApp().Workbooks.Add();
        }

        public static void Quit()
        {
            if (_APP != null)
            {
                _APP.Quit();
                _APP = null;
            }            
        }

    }
}
