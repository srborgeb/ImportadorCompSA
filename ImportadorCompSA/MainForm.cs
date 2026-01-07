using System;
using System.Collections.Generic;
using System.Windows.Forms;
using Telerik.WinControls;
using Telerik.WinControls.UI;
using Telerik.WinControls.Data;

namespace ImportadorCompras
{
    public partial class MainForm : RadForm
    {
        private List<CompraImportada> _datosCargados;
        private readonly ExcelHelper _excelHelper;
        private readonly DatabaseManager _dbManager;

        public MainForm()
        {
            InitializeComponent();
            _excelHelper = new ExcelHelper();
            _dbManager = new DatabaseManager();

            ConfigurarGrid();
        }

        // --- SOLUCIÓN AL ERROR CS0103 ---
        // Este método es requerido porque el archivo de diseño (Designer.cs) 
        // tiene un evento "Load" vinculado. Lo agregamos para que compile correctamente.
        private void MainForm_Load(object sender, EventArgs e)
        {
            // Se deja vacío intencionalmente ya que la configuración inicial 
            // la estamos haciendo en el constructor (ConfigurarGrid).
        }
        // ---------------------------------

        private void ConfigurarGrid()
        {
            // Configuración básica de Telerik Grid
            this.radGridView1.ReadOnly = true;
            this.radGridView1.EnableGrouping = true;
            this.radGridView1.ShowGroupPanel = true;
            this.radGridView1.AutoSizeColumnsMode = GridViewAutoSizeColumnsMode.Fill;

            // Agrupación automática por CodProv al iniciar
            GroupDescriptor descriptor = new GroupDescriptor();
            descriptor.GroupNames.Add("CodProv", System.ComponentModel.ListSortDirection.Ascending);
            this.radGridView1.GroupDescriptors.Add(descriptor);
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog ofd = new OpenFileDialog())
            {
                ofd.Filter = "Excel Files|*.xlsx;*.xls";
                if (ofd.ShowDialog() == DialogResult.OK)
                {
                    txtRuta.Text = ofd.FileName;
                    CargarDatos(ofd.FileName);
                }
            }
        }

        private void CargarDatos(string path)
        {
            try
            {
                this.Cursor = Cursors.WaitCursor;
                _datosCargados = _excelHelper.LeerArchivoExcel(path);

                if (_datosCargados.Count > 0)
                {
                    radGridView1.DataSource = _datosCargados;

                    // --- AQUÍ LLAMAMOS A LA PERSONALIZACIÓN DE COLUMNAS ---
                    PersonalizarColumnas();
                    // ------------------------------------------------------

                    RadMessageBox.Show($"Se cargaron {_datosCargados.Count} registros correctamente.", "Éxito", MessageBoxButtons.OK, RadMessageIcon.Info);
                    btnProcesar.Enabled = true;
                }
                else
                {
                    RadMessageBox.Show("No se encontraron registros válidos (que contengan 'D' en la columna E).", "Advertencia", MessageBoxButtons.OK, RadMessageIcon.Exclamation);
                }
            }
            catch (Exception ex)
            {
                RadMessageBox.Show("Error cargando el archivo. Verifique el Log.", "Error", MessageBoxButtons.OK, RadMessageIcon.Error);
                Logger.LogException(ex, "MainForm.CargarDatos");
            }
            finally
            {
                this.Cursor = Cursors.Default;
            }
        }

        // --- MÉTODO PARA CAMBIAR NOMBRES DE ENCABEZADOS Y FORMATO ---
        private void PersonalizarColumnas()
        {
            if (radGridView1.Columns.Count == 0) return;

            // Para cambiar un nombre, usa: radGridView1.Columns["NombrePropiedadClase"].HeaderText = "Titulo Deseado";

            if (radGridView1.Columns.Contains("CodProv"))
                radGridView1.Columns["CodProv"].HeaderText = "Proveedor";

            if (radGridView1.Columns.Contains("FechaEmision"))
            {
                radGridView1.Columns["FechaEmision"].HeaderText = "Fecha Doc.";
                radGridView1.Columns["FechaEmision"].FormatString = "{0:dd/MM/yyyy}"; // Formato solo fecha
                radGridView1.Columns["FechaEmision"].TextAlignment = System.Drawing.ContentAlignment.MiddleCenter;
            }

            if (radGridView1.Columns.Contains("Referencia"))
                radGridView1.Columns["Referencia"].HeaderText = "Nro. Referencia";

            if (radGridView1.Columns.Contains("Descrip1"))
                radGridView1.Columns["Descrip1"].HeaderText = "Descripción Principal";

            if (radGridView1.Columns.Contains("Descrip2"))
                radGridView1.Columns["Descrip2"].HeaderText = "Descripción Sec.";

            if (radGridView1.Columns.Contains("Descrip4"))
            {
                radGridView1.Columns["Descrip4"].HeaderText = "Tasa";
                radGridView1.Columns["Descrip4"].FormatString = "{0:C2}"; // Formato Moneda
                radGridView1.Columns["Descrip4"].TextAlignment = System.Drawing.ContentAlignment.MiddleRight;
            }

            if (radGridView1.Columns.Contains("Descrip6"))
                radGridView1.Columns["Descrip6"].HeaderText = "Banco.";

            if (radGridView1.Columns.Contains("CodItem"))
                radGridView1.Columns["CodItem"].HeaderText = "Cód. Artículo";

            if (radGridView1.Columns.Contains("Monto"))
            {
                radGridView1.Columns["Monto"].HeaderText = "Monto Total";
                radGridView1.Columns["Monto"].FormatString = "{0:C2}"; // Formato Moneda
                radGridView1.Columns["Monto"].TextAlignment = System.Drawing.ContentAlignment.MiddleRight;
            }

            // Ocultar columnas internas que no interesa ver (Opcional)
            if (radGridView1.Columns.Contains("NroLinea")) radGridView1.Columns["NroLinea"].IsVisible = false;
            if (radGridView1.Columns.Contains("Descrip2")) radGridView1.Columns["Descrip2"].IsVisible = false;
            if (radGridView1.Columns.Contains("Descrip3")) radGridView1.Columns["Descrip3"].IsVisible = false;
            if (radGridView1.Columns.Contains("Descrip5")) radGridView1.Columns["Descrip5"].IsVisible = false;

            // Reajustar anchos para que el texto nuevo quepa bien
            radGridView1.BestFitColumns();
        }
        // ---------------------------------------------------------

        private void btnProcesar_Click(object sender, EventArgs e)
        {
            if (_datosCargados == null || _datosCargados.Count == 0) return;

            if (RadMessageBox.Show("¿Está seguro de insertar estos registros?\nSe generarán facturas agrupadas por Proveedor.", "Confirmación", MessageBoxButtons.YesNo, RadMessageIcon.Question) == DialogResult.Yes)
            {
                try
                {
                    this.Cursor = Cursors.WaitCursor;
                    _dbManager.GuardarFacturas(_datosCargados);

                    RadMessageBox.Show("Proceso completado exitosamente.", "Finalizado", MessageBoxButtons.OK, RadMessageIcon.Info);

                    // Limpiar UI
                    radGridView1.DataSource = null;
                    _datosCargados = null;
                    btnProcesar.Enabled = false;
                    txtRuta.Text = "";
                }
                catch (Exception ex)
                {
                    RadMessageBox.Show("Ocurrió un error al guardar en base de datos.\nRevise el LOG en la carpeta del aplicativo.", "Error Crítico", MessageBoxButtons.OK, RadMessageIcon.Error);
                    Logger.LogException(ex, "MainForm.btnProcesar_Click");
                }
                finally
                {
                    this.Cursor = Cursors.Default;
                }
            }
        }
    }
}