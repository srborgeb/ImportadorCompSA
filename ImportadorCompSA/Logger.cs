using System;
using System.IO;
using System.Text;
using System.Windows.Forms;

namespace ImportadorCompras
{
    public static class Logger
    {
        private static readonly string LogDirectory = Path.Combine(Application.StartupPath, "LOG");

        public static void Write(string message, string type = "INFO")
        {
            try
            {
                if (!Directory.Exists(LogDirectory))
                {
                    Directory.CreateDirectory(LogDirectory);
                }

                string fileName = DateTime.Now.ToString("yyyy-MM-dd") + ".txt";
                string filePath = Path.Combine(LogDirectory, fileName);
                string logLine = $"{DateTime.Now:HH:mm:ss} | {type} | {message}";

                // Usamos append para no sobrescribir
                using (StreamWriter sw = new StreamWriter(filePath, true, Encoding.UTF8))
                {
                    sw.WriteLine(logLine);
                }
            }
            catch (Exception ex)
            {
                // Si falla el log, no podemos hacer mucho más que intentar mostrarlo en consola de debug
                System.Diagnostics.Debug.WriteLine($"Error crítico al escribir log: {ex.Message}");
            }
        }

        public static void LogException(Exception ex, string context)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine($"EXCEPCION EN: {context}");
            sb.AppendLine($"Mensaje: {ex.Message}");
            sb.AppendLine($"Stack: {ex.StackTrace}");
            if (ex.InnerException != null)
            {
                sb.AppendLine($"Inner: {ex.InnerException.Message}");
            }
            Write(sb.ToString(), "ERROR");
        }
    }
}