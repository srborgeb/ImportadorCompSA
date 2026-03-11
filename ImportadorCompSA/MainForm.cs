using FontAwesome.Sharp;
using System;
using System.Collections.Generic;
using System.Drawing; // Importante: Asegura que Bitmap, Color e Icon sean reconocidos
using System.Security.Cryptography.X509Certificates;
using System.Windows.Forms;
using Telerik.WinControls;
using Telerik.WinControls.Data;
using Telerik.WinControls.UI;
using ImportadorCompSA;
using ImportadorCompSA.Modelos;
using ImportadorCompSA.Servicios;

namespace ImportadorCompras
{
    public partial class MainForm : RadForm
    {
        private List<CompraImportada> _datosCargados;
        private readonly ExcelHelper _excelHelper;
        private readonly DatabaseManager _dbManager;
        private DateTime FechaProceso;

        public MainForm()
        {
            InitializeComponent();
            _excelHelper = new ExcelHelper();
            _dbManager = new DatabaseManager();

            ConfigurarGrid();

            // Cargamos los iconos visuales
            CargarIconos();
        }

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

        private void CargarIconos()
        {
            try
            {
                // USAMOS IconPictureBox PARA GENERAR LAS IMÁGENES DE FORMA SEGURA

                // 1. Icono del Formulario (Ventana Principal)
                using (var ipbForm = new IconPictureBox())
                {
                    ipbForm.IconChar = IconChar.FileImport;
                    // CAMBIO: Color azul brillante (DeepSkyBlue) para resaltar en barra de tareas negra
                    ipbForm.IconColor = Color.DeepSkyBlue;
                    ipbForm.IconSize = 32;

                    // Forzamos la creación de la imagen accediendo a la propiedad
                    var img = ipbForm.Image;

                    // Convertimos explícitamente a Bitmap
                    if (img is Bitmap bmp)
                    {
                        // PASO CLAVE: Obtenemos el puntero (IntPtr/nint) separadamente
                        IntPtr hIcon = bmp.GetHicon();

                        // Creamos el icono desde el puntero usando el tipo explícito System.Drawing.Icon
                        this.Icon = System.Drawing.Icon.FromHandle(hIcon);
                    }
                }

                // 2. Icono para el botón Buscar
                using (var ipbBuscar = new IconPictureBox())
                {
                    ipbBuscar.IconChar = IconChar.FolderOpen;
                    // CAMBIO: Azul acero (SteelBlue) para mejor visibilidad y estilo
                    ipbBuscar.IconColor = Color.SteelBlue;
                    ipbBuscar.IconSize = 24;

                    // Clonamos la imagen para asignarla al botón
                    if (ipbBuscar.Image != null)
                    {
                        btnBuscar.Image = (Image)ipbBuscar.Image.Clone();
                    }
                }

                btnBuscar.TextImageRelation = TextImageRelation.ImageBeforeText;
                btnBuscar.TextAlignment = ContentAlignment.MiddleCenter;
                btnBuscar.DisplayStyle = DisplayStyle.ImageAndText;

                // 3. Icono para el botón Procesar
                using (var ipbProcesar = new IconPictureBox())
                {
                    ipbProcesar.IconChar = IconChar.Database;
                    // CAMBIO: Verde más brillante (MediumSeaGreen) para que no se vea negro
                    ipbProcesar.IconColor = Color.MediumSeaGreen;
                    ipbProcesar.IconSize = 30;

                    if (ipbProcesar.Image != null)
                    {
                        btnProcesar.Image = (Image)ipbProcesar.Image.Clone();
                    }
                }

                btnProcesar.TextImageRelation = TextImageRelation.ImageBeforeText;
                btnProcesar.TextAlignment = ContentAlignment.MiddleCenter;
                btnProcesar.DisplayStyle = DisplayStyle.ImageAndText;
            }
            catch (Exception ex)
            {
                // Si falla la carga de iconos por alguna razón, no detenemos la app.
                try { Logger.Write($"No se pudieron cargar los iconos visuales: {ex.Message}", "WARN"); } catch { }
            }
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
                // Nota Arquitectónica: Aquí pasamos FechaProceso en su estado original (01/01/0001) para no romper la firma de LeerArchivoExcel.
                // Lo corregiremos en memoria justo después de la confirmación del usuario.
                _datosCargados = _excelHelper.LeerArchivoExcel(path, FechaProceso);

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

            if (this.radGridView1.Columns["CodUbic"] != null)
            {
                this.radGridView1.Columns["CodUbic"].HeaderText = "Ubicacion";
                this.radGridView1.Columns["CodUbic"].IsVisible = true;
                //this.radGridView1.Columns["CodUbic"].Width = 100;
            }

            // Ocultar columnas internas que no interesa ver (Opcional)
            if (radGridView1.Columns.Contains("NroLinea")) radGridView1.Columns["NroLinea"].IsVisible = false;
            if (radGridView1.Columns.Contains("Descrip2")) radGridView1.Columns["Descrip2"].IsVisible = false;
            if (radGridView1.Columns.Contains("Descrip3")) radGridView1.Columns["Descrip3"].IsVisible = false;
            if (radGridView1.Columns.Contains("Descrip5")) radGridView1.Columns["Descrip5"].IsVisible = false;
            if (radGridView1.Columns.Contains("NumeroD")) radGridView1.Columns["NumeroD"].IsVisible = false;

            // Reajustar anchos para que el texto nuevo quepa bien
            radGridView1.BestFitColumns();
          
        }
        // ---------------------------------------------------------

        private void btnProcesar_Click(object sender, EventArgs e)
        {
            if (_datosCargados == null || _datosCargados.Count == 0) return;

            using (frmConfirmarFecha ventanaValidacion = new frmConfirmarFecha())
            {
                ventanaValidacion.ShowDialog();

                if (!ventanaValidacion.FechaConfirmada)
                {
                    Logger.Write("Importación abortada: El usuario no confirmó la fecha de operación.", "WARN");
                    RadMessageBox.Show("La fecha no ha sido confirmada. El proceso de importación ha sido abortado por seguridad.",
                        "Validación Requerida", MessageBoxButtons.OK, RadMessageIcon.Exclamation);
                    return;
                }
                else
                {
                    FechaProceso = ventanaValidacion.FechaSeleccionada;
                    Logger.Write($"Fecha de proceso confirmada por el usuario: {FechaProceso:dd/MM/yyyy}", "INFO");

                    // --- SOLUCIÓN ARQUITECTÓNICA APLICADA AQUÍ ---
                    // Sincronizamos la fecha confirmada a todos los registros en memoria ANTES de enviarlos a la BD.
                    // Esto evita la excepción de SqlDateTime overflow (01/01/0001).
                    foreach (var registro in _datosCargados)
                    {
                        registro.FechaEmision = FechaProceso;
                    }
                    // ---------------------------------------------
                }
            }

            if (RadMessageBox.Show("¿Está seguro de insertar estos registros?\nSe generarán facturas agrupadas por Proveedor.", "Confirmación", MessageBoxButtons.YesNo, RadMessageIcon.Question) == DialogResult.Yes)
            {
                try
                {
                    this.Cursor = Cursors.WaitCursor;

                    // Asegúrate de que GuardarFacturas actualice la propiedad NumeroD 
                    // de los objetos dentro de la lista _datosCargados
                    _dbManager.GuardarFacturas(_datosCargados);

                    List<DtoReporteAgrupado> datosParaReporte = new List<DtoReporteAgrupado>();
                    foreach (var item in _datosCargados)
                    {
                        datosParaReporte.Add(new DtoReporteAgrupado
                        {
                            Proveedor = item.CodProv,
                            Documento = item.NumeroD?.ToString() ?? "N/A"
                        });
                    }

                    // Llamada al servicio que agrupa, crea el TXT y lo abre
                    GeneradorReporteTexto.GenerarYAbrirReporte(datosParaReporte);

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