using ExcelDataReader;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using Telerik.Windows.Documents.Spreadsheet.Expressions.Functions;

namespace ImportadorCompras
{
    public class ExcelHelper
    {
        public List<CompraImportada> LeerArchivoExcel(string filePath)
        {
            var lista = new List<CompraImportada>();

            try
            {
                Logger.Write($"Iniciando lectura de archivo: {filePath}");

                using (var stream = File.Open(filePath, FileMode.Open, FileAccess.Read))
                {
                    using (var reader = ExcelReaderFactory.CreateReader(stream))
                    {
                        var result = reader.AsDataSet();
                        if (result.Tables.Count == 0) throw new Exception("El archivo Excel no contiene hojas.");

                        DataTable table = result.Tables[0];
                        Logger.Write($"Archivo leído. Total filas detectadas: {table.Rows.Count}");

                        // Según instrucciones:
                        // Fila 9 (índice 8): Mapeo SQL (Informativo para desarrollo)
                        // Fila 10 (índice 9): Encabezados visuales
                        // Fila 11 (índice 10): INICIO DE DATOS

                        int startRowIndex = 10; // Índice base 0, fila 11 es índice 10.

                        for (int i = startRowIndex; i < table.Rows.Count; i++)
                        {
                            DataRow row = table.Rows[i];

                            // Verificación básica para saltar filas totalmente vacías
                            if (row[0] == DBNull.Value && row[8] == DBNull.Value) continue;

                            // --- NUEVO FILTRO SOLICITADO ---
                            // Validar Columna E (Índice 4). Solo procesar si contiene "D".
                            // Se usa Trim() y ToUpper() para asegurar que espacios o minúsculas no afecten.
                            string valorColumnaE = row[4]?.ToString()?.Trim().ToUpper();

                            if (valorColumnaE != "D")
                            {
                                // Si no es "D", saltamos al siguiente registro sin guardar este
                                continue;
                            }
                            // -------------------------------

                            var item = new CompraImportada();

                            try
                            {
                                // Mapeo basado en observación del CSV y fila 9
                                // A=0, B=1, C=2, D=3, E=4, F=5, G=6, H=7, I=8, J=9, K=10, L=11, M=12, N=13

                                // H - CodProv (Columna 2 en encabezado erroneo, pero es Proveedor)
                                item.CodProv = row[11]?.ToString();
                                if (string.IsNullOrWhiteSpace(item.CodProv)) continue; // Sin proveedor no se procesa

                                // A - Fecha y Descrip2
                                var rawDate = row[0];
                                if (rawDate != null && DateTime.TryParse(rawDate.ToString(), out DateTime fecha))
                                {
                                    item.FechaEmision = fecha;
                                }
                                else
                                {
                                    item.FechaEmision = DateTime.Now; // Fallback si no parsea
                                }
                                item.Descrip2 = row[0]?.ToString(); // Mapeo fila 9

                                // B - Referencia y Descrip3
                                item.Referencia = row[1]?.ToString();
                                item.Descrip3 = row[1]?.ToString(); // Mapeo fila 9

                                // C - Descrip1
                                item.Descrip1 = row[2]?.ToString(); // Mapeo fila 9

                                // D - Descrip5
                                item.Descrip5 = row[3]?.ToString(); // Mapeo fila 9

                                // I - CodItem (Columna COD/SER)
                                item.CodItem = row[12]?.ToString(); // Mapeo fila 9

                                // I - CodUbic
                                item.CodUbic = row[9]?.ToString(); // Mapeo fila 9

                                // J - Notas10
                                item.Notas10 = row[10]?.ToString(); // Col J - Notas10

                                // L - Monto (Monto en $) - Ojo: Indices pueden variar si hay columnas ocultas
                                // Asumiendo L es la columna 14 o 15. En el CSV snippet "MONTO" parece ser índice 15 si contamos comas vacías
                                // Ajuste dinámico: Buscamos columna numérica relevante cerca del final
                                decimal monto = 0;
                                // Intento leer columna 15 (Monto según snippet fila 9)
                                if (row.ItemArray.Length > 12 && row[16] != DBNull.Value)
                                {
                                    decimal.TryParse(row[16].ToString(), out monto);
                                }
                                item.Monto = monto*(-1);

                                // Columnas adicionales segun fila 9
                                // DESCRIP4 (índice 14 según conteo visual del CSV raw)
                                if (row.ItemArray.Length > 11) item.Descrip4 = row[15]?.ToString();

                                // DESCRIP6 (índice 15)
                                if (row.ItemArray.Length > 13) item.Descrip6 = row[17]?.ToString();

                                lista.Add(item);
                            }
                            catch (Exception exRow)
                            {
                                Logger.Write($"Error parseando fila {i + 1}: {exRow.Message}", "WARN");
                            }
                        }
                    }
                }

                Logger.Write($"Lectura finalizada. Registros válidos (con 'D' en col E): {lista.Count}");
                return lista;
            }
            catch (Exception ex)
            {
                Logger.LogException(ex, "ExcelHelper.LeerArchivoExcel");
                throw;
            }
        }
    }
}