namespace ImportadorCompras
{
    partial class MainForm
    {
        private System.ComponentModel.IContainer components = null;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            Telerik.WinControls.UI.TableViewDefinition tableViewDefinition1 = new Telerik.WinControls.UI.TableViewDefinition();
            radLabel1 = new Telerik.WinControls.UI.RadLabel();
            txtRuta = new Telerik.WinControls.UI.RadTextBox();
            btnBuscar = new Telerik.WinControls.UI.RadButton();
            radGridView1 = new Telerik.WinControls.UI.RadGridView();
            btnProcesar = new Telerik.WinControls.UI.RadButton();
            dtpFechaE = new Telerik.WinControls.UI.RadDateTimePicker();
            radLabel2 = new Telerik.WinControls.UI.RadLabel();
            ((System.ComponentModel.ISupportInitialize)radLabel1).BeginInit();
            ((System.ComponentModel.ISupportInitialize)txtRuta).BeginInit();
            ((System.ComponentModel.ISupportInitialize)btnBuscar).BeginInit();
            ((System.ComponentModel.ISupportInitialize)radGridView1).BeginInit();
            ((System.ComponentModel.ISupportInitialize)radGridView1.MasterTemplate).BeginInit();
            ((System.ComponentModel.ISupportInitialize)btnProcesar).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dtpFechaE).BeginInit();
            ((System.ComponentModel.ISupportInitialize)radLabel2).BeginInit();
            ((System.ComponentModel.ISupportInitialize)this).BeginInit();
            SuspendLayout();
            // 
            // radLabel1
            // 
            radLabel1.Location = new Point(12, 25);
            radLabel1.Name = "radLabel1";
            radLabel1.Size = new Size(74, 18);
            radLabel1.TabIndex = 0;
            radLabel1.Text = "Archivo Excel:";
            // 
            // txtRuta
            // 
            txtRuta.Location = new Point(100, 24);
            txtRuta.Name = "txtRuta";
            txtRuta.ReadOnly = true;
            txtRuta.Size = new Size(500, 20);
            txtRuta.TabIndex = 1;
            // 
            // btnBuscar
            // 
            btnBuscar.Location = new Point(610, 22);
            btnBuscar.Name = "btnBuscar";
            btnBuscar.Size = new Size(110, 24);
            btnBuscar.TabIndex = 2;
            btnBuscar.Text = "Examinar...";
            btnBuscar.Click += btnBuscar_Click;
            // 
            // radGridView1
            // 
            radGridView1.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            radGridView1.Location = new Point(12, 52);
            // 
            // 
            // 
            radGridView1.MasterTemplate.ViewDefinition = tableViewDefinition1;
            radGridView1.Name = "radGridView1";
            radGridView1.Size = new Size(1053, 235);
            radGridView1.TabIndex = 3;
            // 
            // btnProcesar
            // 
            btnProcesar.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
            btnProcesar.Enabled = false;
            btnProcesar.Location = new Point(905, 293);
            btnProcesar.Name = "btnProcesar";
            btnProcesar.Size = new Size(160, 30);
            btnProcesar.TabIndex = 4;
            btnProcesar.Text = "Procesar";
            btnProcesar.Click += btnProcesar_Click;
            // 
            // dtpFechaE
            // 
            dtpFechaE.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            dtpFechaE.AutoSize = false;
            dtpFechaE.Format = DateTimePickerFormat.Short;
            dtpFechaE.Location = new Point(936, 24);
            dtpFechaE.Name = "dtpFechaE";
            dtpFechaE.Size = new Size(129, 20);
            dtpFechaE.TabIndex = 5;
            dtpFechaE.TabStop = false;
            dtpFechaE.Text = "12/1/2026";
            dtpFechaE.Value = new DateTime(2026, 1, 12, 10, 0, 52, 223);
            // 
            // radLabel2
            // 
            radLabel2.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            radLabel2.Location = new Point(893, 25);
            radLabel2.Name = "radLabel2";
            radLabel2.Size = new Size(37, 18);
            radLabel2.TabIndex = 1;
            radLabel2.Text = "Fecha:";
            // 
            // MainForm
            // 
            AutoScaleBaseSize = new Size(7, 15);
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1079, 330);
            Controls.Add(radLabel2);
            Controls.Add(dtpFechaE);
            Controls.Add(radGridView1);
            Controls.Add(btnProcesar);
            Controls.Add(btnBuscar);
            Controls.Add(txtRuta);
            Controls.Add(radLabel1);
            Name = "MainForm";
            Text = "Importador de Compras Telerik";
            WindowState = FormWindowState.Maximized;
            Load += MainForm_Load;
            ((System.ComponentModel.ISupportInitialize)radLabel1).EndInit();
            ((System.ComponentModel.ISupportInitialize)txtRuta).EndInit();
            ((System.ComponentModel.ISupportInitialize)btnBuscar).EndInit();
            ((System.ComponentModel.ISupportInitialize)radGridView1.MasterTemplate).EndInit();
            ((System.ComponentModel.ISupportInitialize)radGridView1).EndInit();
            ((System.ComponentModel.ISupportInitialize)btnProcesar).EndInit();
            ((System.ComponentModel.ISupportInitialize)dtpFechaE).EndInit();
            ((System.ComponentModel.ISupportInitialize)radLabel2).EndInit();
            ((System.ComponentModel.ISupportInitialize)this).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        private Telerik.WinControls.UI.RadLabel radLabel1;
        private Telerik.WinControls.UI.RadTextBox txtRuta;
        private Telerik.WinControls.UI.RadButton btnBuscar;
        private Telerik.WinControls.UI.RadGridView radGridView1;
        private Telerik.WinControls.UI.RadButton btnProcesar;
        private Telerik.WinControls.UI.RadDateTimePicker dtpFechaE;
        private Telerik.WinControls.UI.RadLabel radLabel2;
    }
}