using System;
using System.Windows.Forms;
using ImportadorCompras; // IMPORTANTE: Esta línea conecta con el formulario que diseñamos

namespace ImportadorCompSA
{
    internal static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            // --- CORRECCIÓN DEL ERROR DE ENCODING 1252 ---
            // Esto habilita las codificaciones antiguas de Windows necesarias para leer Excel.
            // Requiere el paquete NuGet: System.Text.Encoding.CodePages
            System.Text.Encoding.RegisterProvider(System.Text.CodePagesEncodingProvider.Instance);

            // Inicialización estándar para .NET 6, 7 y 8
            // Configura estilos visuales, renderizado de texto y High DPI automáticamente
            ApplicationConfiguration.Initialize();

            // Ejecutamos el formulario real (el que hereda de RadForm)
            Application.Run(new MainForm());
        }
    }
}