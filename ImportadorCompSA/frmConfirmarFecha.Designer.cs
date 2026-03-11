namespace ImportadorCompSA
{
    partial class frmConfirmarFecha
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            dtpSeleccionarFecha = new Telerik.WinControls.UI.RadDateTimePicker();
            dtpConfirmarFecha = new Telerik.WinControls.UI.RadDateTimePicker();
            radLabel1 = new Telerik.WinControls.UI.RadLabel();
            radLabel2 = new Telerik.WinControls.UI.RadLabel();
            btnVolver = new Telerik.WinControls.UI.RadButton();
            btnConfirmar = new Telerik.WinControls.UI.RadButton();
            ((System.ComponentModel.ISupportInitialize)dtpSeleccionarFecha).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dtpConfirmarFecha).BeginInit();
            ((System.ComponentModel.ISupportInitialize)radLabel1).BeginInit();
            ((System.ComponentModel.ISupportInitialize)radLabel2).BeginInit();
            ((System.ComponentModel.ISupportInitialize)btnVolver).BeginInit();
            ((System.ComponentModel.ISupportInitialize)btnConfirmar).BeginInit();
            ((System.ComponentModel.ISupportInitialize)this).BeginInit();
            SuspendLayout();
            // 
            // dtpSeleccionarFecha
            // 
            dtpSeleccionarFecha.Format = DateTimePickerFormat.Short;
            dtpSeleccionarFecha.Location = new Point(180, 26);
            dtpSeleccionarFecha.Name = "dtpSeleccionarFecha";
            dtpSeleccionarFecha.Size = new Size(123, 20);
            dtpSeleccionarFecha.TabIndex = 0;
            dtpSeleccionarFecha.TabStop = false;
            dtpSeleccionarFecha.Text = "28/2/2026";
            dtpSeleccionarFecha.Value = new DateTime(2026, 2, 28, 14, 24, 0, 669);
            // 
            // dtpConfirmarFecha
            // 
            dtpConfirmarFecha.Format = DateTimePickerFormat.Short;
            dtpConfirmarFecha.Location = new Point(180, 72);
            dtpConfirmarFecha.Name = "dtpConfirmarFecha";
            dtpConfirmarFecha.Size = new Size(123, 20);
            dtpConfirmarFecha.TabIndex = 1;
            dtpConfirmarFecha.TabStop = false;
            dtpConfirmarFecha.Text = "28/2/2026";
            dtpConfirmarFecha.Value = new DateTime(2026, 2, 28, 14, 24, 0, 669);
            // 
            // radLabel1
            // 
            radLabel1.Location = new Point(29, 73);
            radLabel1.Name = "radLabel1";
            radLabel1.Size = new Size(90, 18);
            radLabel1.TabIndex = 2;
            radLabel1.Text = "Confirmar Fecha:";
            // 
            // radLabel2
            // 
            radLabel2.Location = new Point(29, 27);
            radLabel2.Name = "radLabel2";
            radLabel2.Size = new Size(97, 18);
            radLabel2.TabIndex = 3;
            radLabel2.Text = "Seleccionar Fecha:";
            // 
            // btnVolver
            // 
            btnVolver.Location = new Point(186, 125);
            btnVolver.Name = "btnVolver";
            btnVolver.Size = new Size(117, 39);
            btnVolver.TabIndex = 5;
            btnVolver.Text = "Volver";
            btnVolver.Click += btnVolver_Click;
            // 
            // btnConfirmar
            // 
            btnConfirmar.Location = new Point(29, 125);
            btnConfirmar.Name = "btnConfirmar";
            btnConfirmar.Size = new Size(117, 39);
            btnConfirmar.TabIndex = 6;
            btnConfirmar.Text = "Confirmar";
            btnConfirmar.Click += radButton2_Click;
            // 
            // frmConfirmarFecha
            // 
            AutoScaleBaseSize = new Size(7, 15);
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(323, 179);
            Controls.Add(btnConfirmar);
            Controls.Add(btnVolver);
            Controls.Add(radLabel2);
            Controls.Add(radLabel1);
            Controls.Add(dtpConfirmarFecha);
            Controls.Add(dtpSeleccionarFecha);
            Name = "frmConfirmarFecha";
            Text = "frmConfirmarFecha";
            Load += frmConfirmarFecha_Load;
            ((System.ComponentModel.ISupportInitialize)dtpSeleccionarFecha).EndInit();
            ((System.ComponentModel.ISupportInitialize)dtpConfirmarFecha).EndInit();
            ((System.ComponentModel.ISupportInitialize)radLabel1).EndInit();
            ((System.ComponentModel.ISupportInitialize)radLabel2).EndInit();
            ((System.ComponentModel.ISupportInitialize)btnVolver).EndInit();
            ((System.ComponentModel.ISupportInitialize)btnConfirmar).EndInit();
            ((System.ComponentModel.ISupportInitialize)this).EndInit();
            ResumeLayout(false);
            PerformLayout();

        }

        #endregion

        private Telerik.WinControls.UI.RadDateTimePicker dtpSeleccionarFecha;
        private Telerik.WinControls.UI.RadDateTimePicker dtpConfirmarFecha;
        private Telerik.WinControls.UI.RadLabel radLabel1;
        private Telerik.WinControls.UI.RadLabel radLabel2;
        private Telerik.WinControls.UI.RadButton btnVolver;
        private Telerik.WinControls.UI.RadButton btnConfirmar;
    }
}
