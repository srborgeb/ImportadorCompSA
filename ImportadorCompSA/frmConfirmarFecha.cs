using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Telerik.WinControls;
using ImportadorCompras;

namespace ImportadorCompSA
{

    public partial class frmConfirmarFecha : Telerik.WinControls.UI.RadForm
    {
        public bool FechaConfirmada { get; private set; }
        public DateTime FechaSeleccionada { get; private set; }

        public frmConfirmarFecha()
        {
            InitializeComponent();
            ConfigurarDimensionesFijas();
        }

        /// <summary>
        /// Bloquea el tamaño del formulario para evitar que el escalado de Windows (DPI) 
        /// lo modifique al abrir el diseñador en diferentes monitores.
        /// </summary>
        private void ConfigurarDimensionesFijas()
        {
            // Importante: Desactivar el escalado automático por fuente
            this.AutoScaleMode = AutoScaleMode.None;

            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.StartPosition = FormStartPosition.CenterScreen;

            // Definir tamaño fijo (Ajustar valores según su necesidad visual)
            Size tamanoFijo = new Size(330, 210);
            this.Size = tamanoFijo;
            this.MinimumSize = tamanoFijo;
            this.MaximumSize = tamanoFijo;
        }

        private void frmConfirmarFecha_Load(object sender, EventArgs e)
        {
            FechaConfirmada = false;
            dtpSeleccionarFecha.Value = DateTime.Now;
            dtpConfirmarFecha.Value = DateTime.Now.AddDays(-1);
        }

        private void radButton2_Click(object sender, EventArgs e)
        {
            if (dtpSeleccionarFecha.Value.Date == dtpConfirmarFecha.Value.Date)
            {
                FechaConfirmada = true;
                FechaSeleccionada = dtpSeleccionarFecha.Value.Date;
                this.Close();
            }
            else
            {
                MessageBox.Show("Las fechas no coinciden. Por favor, seleccione la misma fecha en ambos campos.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnVolver_Click(object sender, EventArgs e)
        {
            Logger.Write("El usuario ha cancelado la confirmación de fecha.", "INFO");
            FechaConfirmada = false;
            this.Close();
        }
    }
}
