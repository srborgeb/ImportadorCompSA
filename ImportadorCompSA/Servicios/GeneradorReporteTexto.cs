using ImportadorCompras;
using ImportadorCompSA.Modelos;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace ImportadorCompSA.Servicios
{
    /// <summary>
    /// Servicio encargado de generar archivos de texto plano para auditoría de importación.
    /// </summary>
    public static class GeneradorReporteTexto
    {
        /// <summary>
        /// Agrupa la información en memoria, escribe el TXT en la carpeta Resultados y lo abre automáticamente.
        /// </summary>
        /// <param name="registros">Lista de DTOs recolectados durante la inserción en base de datos.</param>
        public static void GenerarYAbrirReporte(List<DtoReporteAgrupado> registros)
        {
            try
            {
                if (registros == null || !registros.Any())
                {
                    Logger.Write("No hay registros para generar el reporte de texto.", "ADVERTENCIA");
                    return;
                }

                // 1. Configurar y crear directorio de Resultados
                string directorioResultados = Path.Combine(Application.StartupPath, "Resultados");
                if (!Directory.Exists(directorioResultados))
                {
                    Directory.CreateDirectory(directorioResultados);
                }

                // 2. Construir nombre del archivo con formato AAAAMMDD_hhmmssampm
                string sufijoAmPm = DateTime.Now.ToString("tt").ToLower();
                string fechaHora = DateTime.Now.ToString("yyyyMMdd_hhmmss");
                string nombreArchivo = $"Importacion_{fechaHora}{sufijoAmPm}.txt";
                string rutaCompleta = Path.Combine(directorioResultados, nombreArchivo);

                // 3. Procesamiento y Agrupación mediante LINQ
                StringBuilder sb = new StringBuilder();
                sb.AppendLine("Proveedor".PadRight(20) + "Documento");

                var registrosValidos = ObtenerRegistrosValidos(registros);

                var agrupamiento = registrosValidos
                    .GroupBy(r => r.Proveedor)
                    .OrderBy(g => g.Key);

                foreach (var grupoProveedor in agrupamiento)
                {
                    // Obtener documentos únicos del proveedor y ordenarlos (asumiendo que puedan ser numéricos o alfanuméricos)
                    var documentosOrdenados = grupoProveedor
                        .Select(x => x.Documento)
                        .Distinct()
                        .OrderBy(d => d);

                    foreach (var documento in documentosOrdenados)
                    {
                        // Alineación estricta de columnas a 20 caracteres
                        sb.AppendLine($"{grupoProveedor.Key.PadRight(20)}{documento}");
                    }
                }

                // 4. Escritura en disco estricta (UTF-8)
                File.WriteAllText(rutaCompleta, sb.ToString(), Encoding.UTF8);
                Logger.Write($"Reporte de importación generado exitosamente en: {rutaCompleta}", "INFO");

                // 5. Apertura del archivo a nivel de Sistema Operativo
                Process.Start(new ProcessStartInfo
                {
                    FileName = rutaCompleta,
                    UseShellExecute = true // Requerido en .NET Core / .NET 8 para abrir con aplicación por defecto
                });
            }
            catch (Exception ex)
            {
                Logger.LogException(ex, "GeneradorReporteTexto.GenerarYAbrirReporte");
                MessageBox.Show("Ocurrió un error al generar el archivo de reporte. Revise el archivo LOG.", "Error de Reporte", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        /// <summary>
        /// Filtra registros corruptos usando FluentValidation antes de imprimir.
        /// </summary>
        private static List<DtoReporteAgrupado> ObtenerRegistrosValidos(List<DtoReporteAgrupado> registros)
        {
            var validador = new ValidadorDtoReporteAgrupado();
            var listaValida = new List<DtoReporteAgrupado>();

            foreach (var reg in registros)
            {
                var resultadoValidacion = validador.Validate(reg);
                if (resultadoValidacion.IsValid)
                {
                    listaValida.Add(reg);
                }
                else
                {
                    Logger.Write($"Registro excluido del reporte por datos inválidos. Proveedor: {reg.Proveedor}, Doc: {reg.Documento}", "ADVERTENCIA");
                }
            }
            return listaValida;
        }
    }
}