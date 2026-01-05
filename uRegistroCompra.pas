 unit uRegistroCompra;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, System.ImageList,
  Vcl.ImgList, Vcl.StdCtrls, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DBGridEh, Vcl.Mask, DBCtrlsEh, DBLookupEh, EhLibVCL, GridsEh,
  DBAxisGridsEh, Data.DB, Data.Win.ADODB, Vcl.ComCtrls, scExcelExport,
  XLSSheetData5, XLSReadWriteII5;

type
  enumColumna = (Codigo, Nombre, Cantidad, Precio, IdNumerico);

  TformRegistroCompra = class(TForm)
    Buscar: TButton;
    btnCancelar: TButton;
    txtCodigo: TEdit;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    txtID: TEdit;
    Label1: TLabel;
    txtDocumento: TEdit;
    Label2: TLabel;
    cmbProveedor: TDBLookupComboboxEh;
    GroupBox2: TGroupBox;
    txtTasaCambio: TEdit;
    txtFlete: TEdit;
    Grid: TDBGridEh;
    txtCantidad: TEdit;
    txtPrecio: TEdit;
    txtImpuesto: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    DS: TDataSource;
    Query: TADOQuery;
    Query2: TADOQuery;
    Button1: TButton;
    btnNuevo: TButton;
    btnGuardar: TButton;
    txtExpediente: TEdit;
    Label8: TLabel;
    dpFecha: TDateTimePicker;
    Label9: TLabel;
    txtFechaAprobacion: TEdit;
    lblFechaAprobacion: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    txtImportacion: TEdit;
    txtTotalImpuesto: TEdit;
    txtTotalMercancia: TEdit;
    txtSeguro: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    DSProv: TDataSource;
    QueryProv: TADOQuery;
    Label12: TLabel;
    txtValorem: TEdit;
    btnImportar: TButton;
    OP: TOpenDialog;
    Excel: TXLSReadWriteII5;

    function ValidarCampos: Boolean;
    function ExisteID(Numero: Integer): Boolean;
    function ProximoID: Integer;
    function BuscarCodigo(Codigo: string): Boolean;
    function BuscarUltimoNumero: Integer;
    procedure txtCantidadKeyPress(Sender: TObject; var Key: Char);
    procedure txtPrecioKeyPress(Sender: TObject; var Key: Char);
    procedure txtImpuestoKeyPress(Sender: TObject; var Key: Char);
    procedure txtCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure InicializarVariables;
    procedure CargarDatos(Numero: Integer);
    procedure Button1Click(Sender: TObject);
    procedure txtDocumentoKeyPress(Sender: TObject; var Key: Char);
    procedure cmbProveedorExit(Sender: TObject);
    procedure txtExpedienteKeyPress(Sender: TObject; var Key: Char);
    procedure dpFechaExit(Sender: TObject);
    procedure txtTasaCambioKeyPress(Sender: TObject; var Key: Char);
    procedure txtFleteKeyPress(Sender: TObject; var Key: Char);
    procedure txtImportacionKeyPress(Sender: TObject; var Key: Char);
    procedure txtSeguroKeyPress(Sender: TObject; var Key: Char);
    procedure btnNuevoClick(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    Procedure AplicarProrrateo(Numero: Integer; ParaAprobar: Boolean);
    procedure GuardarEncabezado(ID: Integer;
                                Documento: String;
                                Proveedor: String;
                                Fecha: String;
                                FechaAprobacion: String;
                                Aprobado: Integer;
                                Expediente: String;
                                TasaCambio: Double;
                                Impuesto: Double;
                                TotalMercancia: Double;
                                Flete: Double;
                                Importacion: Double;
                                Otros: Double);
    procedure GuardarMovimiento(ID_Compra: Integer;
                                Codigo: String;
                                Nombre: String;
                                Costo: Double;
                                CostoProrrateado: Double;
                                Impuesto: Double;
                                Cantidad: Double;
                                Valorem: Double);
    procedure FormShow(Sender: TObject);
    procedure txtTasaCambioExit(Sender: TObject);
    procedure txtImportacionExit(Sender: TObject);
    procedure txtFleteExit(Sender: TObject);
    procedure txtSeguroExit(Sender: TObject);
    procedure txtTotalImpuestoExit(Sender: TObject);
    procedure txtCantidadExit(Sender: TObject);
    procedure txtPrecioExit(Sender: TObject);
    procedure txtImpuestoExit(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure txtTasaCambioEnter(Sender: TObject);
    procedure txtFleteEnter(Sender: TObject);
    procedure txtImportacionEnter(Sender: TObject);
    procedure txtSeguroEnter(Sender: TObject);
    procedure txtCantidadEnter(Sender: TObject);
    procedure txtPrecioEnter(Sender: TObject);
    procedure txtImpuestoEnter(Sender: TObject);
    procedure txtTotalMercanciaEnter(Sender: TObject);
    procedure txtTotalMercanciaChange(Sender: TObject);
    procedure txtTotalImpuestoChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure txtCodigoExit(Sender: TObject);
    procedure AplicarAprobacion(Numero: Integer);
    procedure EliminarRegistro(Numero: Integer; Codigo: string);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BuscarClick(Sender: TObject);
    procedure txtValoremEnter(Sender: TObject);
    procedure txtValoremExit(Sender: TObject);
    procedure txtValoremKeyPress(Sender: TObject; var Key: Char);
    procedure btnImportarClick(Sender: TObject);

    function ExisteDocumento(Numero : integer): Boolean;

  private
    { Private declarations }
  public
    { Public declarations }
  end;
  function RegistrarArticulo(Codigo: String; Descripcion: string; Instancia: string; IVA: String): Boolean;
var
  formRegistroCompra    : TformRegistroCompra;
  strConexionPrincipal  : String;
  NombreArticulo        : String;
  Archivo               : string;

implementation

uses
  uComun, uConfiguradorDB, uAcercaDe, uCrearArticulo, uCatalogoCompras;

{$R *.dfm}
//--------------------------------------------------------------------------------------------------------
function TformRegistroCompra.ValidarCampos;
begin
  Result := True;
  if Trim(txtDocumento.Text)= EmptyStr then Result := False;
  if Trim(txtTasaCambio.Text)= EmptyStr then Result := False;
  if Trim(txtFlete.Text)= EmptyStr then Result := False;
  if Trim(txtExpediente.Text)= EmptyStr then Result := False;
  if Trim(txtImportacion.Text)= EmptyStr then Result := False;
  if Trim(txtTotalImpuesto.Text)= EmptyStr then Result := False;
  if Trim(txtTotalMercancia.Text)= EmptyStr then Result := False;
  if Trim(txtSeguro.Text)= EmptyStr then Result := False;
  if Grid.DataRowCount = 0 then Result := False;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtCantidadEnter(Sender: TObject);
begin
  txtCantidad.SelText;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtCantidadExit(Sender: TObject);
begin
  if txtCantidad.Text = EmptyStr then
    txtCantidad.Text := '0';
  txtCantidad.Text := FormatearNumero2d(txtCantidad.Text);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtCantidadKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(integer(enumTecla.Enter)) then
    txtPrecio.SetFocus;
  Key := SoloDecimalEnCaja(txtCantidad, Key);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtCodigoExit(Sender: TObject);
begin
  if  Length(trim(txtCodigo.Text)) <> 0  then
  begin
    if Not BuscarCodigo(Trim(txtCodigo.Text)) then
    begin
      ShowMessage('El codigo del producto no existe.');
      frmCrearArticulo.ShowModal;
      txtCodigo.SetFocus;
      Abort;
    end;
  end;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtCodigoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(integer(enumTecla.Espacio)) then
    Key := #0;
  if Key = chr(integer(enumTecla.Enter)) then
    txtCantidad.SetFocus;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtDocumentoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = chr(integer(enumTecla.Enter)) then
    cmbProveedor.SetFocus;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtExpedienteKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = chr(integer(enumTecla.Enter)) then
    dpFecha.SetFocus;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtFleteEnter(Sender: TObject);
begin
  txtFlete.SelText;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtFleteExit(Sender: TObject);
begin
  if txtFlete.Text = EmptyStr then
    txtFlete.Text := '0';
  txtFlete.Text := FormatearNumero4d(txtFlete.Text)
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtFleteKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(integer(enumTecla.Enter)) then
    txtImportacion.SetFocus;
  Key := SoloDecimalEnCaja(txtFlete, Key);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtImportacionEnter(Sender: TObject);
begin
  txtImportacion.SelText;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtImportacionExit(Sender: TObject);
begin
  if txtImportacion.Text = EmptyStr then
    txtImportacion.Text := '0';
  txtImportacion.Text := FormatearNumero4d(txtImportacion.Text);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtImportacionKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = chr(integer(enumTecla.Enter)) then
    txtSeguro.SetFocus;
  Key := SoloDecimalEnCaja(txtImportacion, Key);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtImpuestoEnter(Sender: TObject);
begin
  txtImpuesto.SelText;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtImpuestoExit(Sender: TObject);
begin
  if txtImpuesto.Text = EmptyStr then
    txtImpuesto.Text := '0';
  txtImpuesto.Text := FormatearNumero4d(txtImpuesto.Text);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtImpuestoKeyPress(Sender: TObject; var Key: Char);
var
  ID : Integer;
begin
  if trim(txtCodigo.Text) = EmptyStr then
  begin
    txtCodigo.SetFocus;
    Abort;
  end;

  if Trim(txtCantidad.Text)= EmptyStr then
  begin
    txtCantidad.SetFocus;
    Abort;
  end;

  if Trim(txtPrecio.Text)= EmptyStr then
  begin
    txtPrecio.SetFocus;
    Abort;
  end;

  if (Trim(txtImpuesto.Text)= EmptyStr) and (Key = chr(integer(enumTecla.Enter))) then
  begin
    txtImpuesto.SetFocus;
    Abort;
  end;

  if Key = chr(integer(enumTecla.Enter)) then
  begin
    if Trim(txtID.Text) <> EmptyStr then
    begin
      IF ExisteID(StrToInt(txtID.Text)) Then
      begin
        ID := StrToInt(txtID.Text)
      end
        else
        begin
          ID := ProximoID;
        end;
    end
      else
      begin
        ID := ProximoID;
      end;

    GuardarEncabezado(ID, Trim(txtDocumento.Text), cmbProveedor.KeyValue, DateToStr(dpFecha.Date),
                      '01/01/2000', 0, Trim(txtExpediente.text),
                      StrToFloat(trim(StringReplace(txtTasaCambio.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                      StrToFloat(trim(StringReplace(txtTotalImpuesto.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                      StrToFloat(trim(StringReplace(txtTotalMercancia.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                      StrToFloat(trim(StringReplace(txtFlete.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                      StrToFloat(trim(StringReplace(txtImportacion.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                      StrToFloat(trim(StringReplace(txtSeguro.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))));

    GuardarMovimiento(ID, trim(txtCodigo.Text), NombreArticulo,
                      StrToFloat(trim(StringReplace(txtPrecio.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                      0,
                      StrToFloat(trim(StringReplace(txtImpuesto.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                      StrToFloat(trim(StringReplace(txtCantidad.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                      StrToFloat(trim(StringReplace(txtValorem.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))));
    CargarDatos(ID);
    txtCodigo.Text := EmptyStr;
    txtPrecio.Text := EmptyStr;
    txtImpuesto.Text := EmptyStr;
    txtCantidad.Text := EmptyStr;
    txtValorem.Text := EmptyStr;
    txtCodigo.SetFocus;
  end;
  Key := SoloDecimalEnCaja(txtImpuesto, Key);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtPrecioEnter(Sender: TObject);
begin
  txtPrecio.Text := txtPrecio.SelText;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtPrecioExit(Sender: TObject);
begin
  if txtPrecio.Text = EmptyStr then
    txtPrecio.Text := '0';
  txtPrecio.Text := FormatearNumero4d(txtPrecio.Text);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtPrecioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(integer(enumTecla.Enter)) then
    txtValorem.SetFocus;
  Key := SoloDecimalEnCaja(txtPrecio, Key);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.btnCancelarClick(Sender: TObject);
begin
  InicializarVariables;
  CargarDatos(ProximoID-1);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.btnGuardarClick(Sender: TObject);
var
  I         : Integer;
  ID        : Integer;
  Aprobado  : Integer;
  Respuesta : Integer;
  Aprobar   : Boolean;

begin
  if not ValidarCampos then
  begin
    ShowMessage('Existen datos que aun no han sido ingresados');
    Abort;
  end;

  if Trim(txtID.Text) <> EmptyStr then
  begin
    IF ExisteID(StrToInt(txtID.Text)) Then
    begin
      ID := StrToInt(txtID.Text)
    end
      else
      begin
        ID := ProximoID;
      end;
  end
    else
    begin
      ID := ProximoID;
    end;

  Respuesta := MessageBox(Handle, 'Desea cerra la compra?', 'Confirmacion', MB_YESNO+mb_ICONQUESTION);
  if Respuesta = IDNO then
  begin
    Aprobado := 0;
    Aprobar  := False;
  end
    else
    begin
      Aprobado := 1;
      Aprobar  := True;
    end;

  GuardarEncabezado(ID, Trim(txtDocumento.Text), cmbProveedor.KeyValue, DateToStr(dpFecha.Date),
                    '01/01/2000', Aprobado, Trim(txtExpediente.text),
                    StrToFloat(trim(StringReplace(txtTasaCambio.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtTotalImpuesto.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtTotalMercancia.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtFlete.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtImportacion.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtSeguro.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))));
  if not ExisteDocumento(ID) then
  begin
    if not Grid.DataSource.DataSet.Eof then
    begin
      with Grid.DataSource do
      begin
        DataSet.First;
        while not DataSet.Eof do
        begin
          GuardarMovimiento(ID, DataSet.FieldByName('Codigo').Value, DataSet.FieldByName('Nombre').Value,
                            DataSet.FieldByName('Costo').Value, DataSet.FieldByName('CostoProrrateado').Value,
                            DataSet.FieldByName('Impuesto').Value, DataSet.FieldByName('Cantidad').Value,
                            DataSet.FieldByName('Valorem').Value / DataSet.FieldByName('Cantidad').Value);
          DataSet.Next;
        end;
      end;
    end;
  end;

  txtCodigo.Text := EmptyStr;
  txtPrecio.Text := EmptyStr;
  txtImpuesto.Text := EmptyStr;
  txtCantidad.Text := EmptyStr;
  txtValorem.Text := EmptyStr;
  txtCodigo.SetFocus;

  if Aprobar then
  begin
    AplicarProrrateo(ID, True);
  end
    else
    begin
      AplicarProrrateo(ID, False);
    end;

  CargarDatos(ID);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.btnImportarClick(Sender: TObject);
var
  Linea     : Integer;
  ID        : Integer;
  Codigo    : string;
  Nombre    : string;
  Costo     : Double;
  Prorrateo : Double;
  Impuesto  : Double;
  Cantidad  : Double;
  Valorem   : Double;
begin
  OP.Filter := 'Excel|*.xls;*.xlsx';
  if OP.Execute then
  begin
    Archivo := OP.FileName;
    Excel.Filename := Archivo;
    Excel.Read;
    Excel[0].CalcDimensions;
    if Trim(txtID.Text) <> EmptyStr then
      begin
        IF ExisteID(StrToInt(txtID.Text)) Then
        begin
          ID := StrToInt(txtID.Text)
        end
          else
          begin
            ID := ProximoID;
            GuardarEncabezado(ID, Trim(txtDocumento.Text), cmbProveedor.KeyValue, DateToStr(dpFecha.Date),
                    '01/01/2000', 0, Trim(txtExpediente.text),
                    StrToFloat(trim(StringReplace(txtTasaCambio.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtTotalImpuesto.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtTotalMercancia.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtFlete.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtImportacion.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtSeguro.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))));
          end;
      end
        else
        begin
           ID := ProximoID;
           GuardarEncabezado(ID, Trim(txtDocumento.Text), cmbProveedor.KeyValue, DateToStr(dpFecha.Date),
                    '01/01/2000', 0, Trim(txtExpediente.text),
                    StrToFloat(trim(StringReplace(txtTasaCambio.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtTotalImpuesto.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtTotalMercancia.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtFlete.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtImportacion.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtSeguro.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))));
        end;

    Grid.StartLoadingStatus('Espere mientras cargamos su informacion',3);
    for Linea := Excel[0].FirstRow + 1 to Excel[0].LastRow do
    Begin
      Codigo := Excel[0].AsString[integer(enumColumna.Codigo),Linea];
      Nombre := Excel[0].AsString[integer(enumColumna.Nombre),Linea];
      Costo := Excel[0].AsFloat[integer(enumColumna.Precio),Linea];
      Prorrateo := 0;
      Impuesto := 0;
      Cantidad := Excel[0].AsFloat[integer(enumColumna.Cantidad),Linea];
      Valorem := 0;

      Costo := Costo ;// * StrToFloat(trim(StringReplace(txtTasaCambio.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase])));
      Impuesto := 0;

      if RegistrarArticulo(Codigo,Nombre,'2','16') then
        GuardarMovimiento(ID, Codigo, Nombre, Costo, Prorrateo, Impuesto,Cantidad, Valorem);
    End;
    Grid.FinishLoadingStatus(2);
    CargarDatos(ID);
    GuardarEncabezado(ID, Trim(txtDocumento.Text), cmbProveedor.KeyValue, DateToStr(dpFecha.Date),
                    '01/01/2000', 0, Trim(txtExpediente.text),
                    StrToFloat(trim(StringReplace(txtTasaCambio.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtTotalImpuesto.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtTotalMercancia.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtFlete.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtImportacion.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))),
                    StrToFloat(trim(StringReplace(txtSeguro.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]))));

  end;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.btnNuevoClick(Sender: TObject);
begin
  InicializarVariables;
  txtFechaAprobacion.Visible := False;
  txtFechaAprobacion.Enabled := False;
  lblFechaAprobacion.Visible := False;
  txtFlete.Enabled := True;
  txtDocumento.Enabled := True;
  txtTasaCambio.Enabled := True;
  txtCantidad.Enabled := True;
  txtPrecio.Enabled := True;
  txtImpuesto.Enabled := True;
  txtExpediente.Enabled := True;
  txtImportacion.Enabled := True;
  txtSeguro.Enabled := True;
  cmbProveedor.Enabled := True;

  btnGuardar.Enabled := True;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.Button1Click(Sender: TObject);
begin
  Application.Terminate;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.FormCreate(Sender: TObject);
begin
  AdaptarFormAreaDeTrabajo(Self);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.FormShow(Sender: TObject);
var
  SQL : String;
begin
  strConexionPrincipal := LeerXML_BD;
  InicializarVariables;
  Query.ConnectionString := strConexionPrincipal;
  Query2.ConnectionString := strConexionPrincipal;

  if not ExisteTablaSQL('COMPRAS',strConexionPrincipal,False) then
  Begin
    SQL := 'CREATE TABLE [dbo].[COMPRAS](  ' + chr(10) + chr(13) +
           '  [ID] [int] NOT NULL,' + chr(10) + chr(13) +
           '  [Documento] [varchar](20) NOT NULL,' + chr(10) + chr(13) +
           '  [Proveedor] [varchar](20) NOT NULL,' + chr(10) + chr(13) +
           '  [Fecha] [datetime] NOT NULL,' + chr(10) + chr(13) +
           '  [FechaAprobacion] [datetime] NULL,' + chr(10) + chr(13) +
           '  [Aprobado] [int] NOT NULL,' + chr(10) + chr(13) +
           '  [Expediente] [varchar](20) NOT NULL,' + chr(10) + chr(13) +
           '  [TasaCambio] [numeric](24, 4) NOT NULL,' + chr(10) + chr(13) +
           '  [Impuesto] [numeric](24, 4) NOT NULL,' + chr(10) + chr(13) +
           '  [TotalMercancia] [numeric](24, 4) NOT NULL,' + chr(10) + chr(13) +
           '  [Flete] [numeric](24, 4) NOT NULL,' + chr(10) + chr(13) +
           '  [Importacion] [numeric](24, 4) NOT NULL,' + chr(10) + chr(13) +
           '  [Otros] [numeric](24, 4) NOT NULL,' + chr(10) + chr(13) +
           ' CONSTRAINT [PK_COMPRAS] PRIMARY KEY CLUSTERED' + chr(10) + chr(13) +
           '([ID] ASC' + chr(10) + chr(13) +
           ')WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,' + chr(10) + chr(13) +
           'ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]' + chr(10) + chr(13) +
           ') ON [PRIMARY] ';
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Text := SQL;
    Query2.ExecSQL;

    SQL := 'ALTER TABLE [dbo].[COMPRAS] ADD  CONSTRAINT [DF_COMPRAS_Aprobado]  DEFAULT ((0)) FOR [Aprobado] ';
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Text := SQL;
    Query2.ExecSQL;

    SQL := 'ALTER TABLE [dbo].[COMPRAS]  WITH CHECK ADD  CONSTRAINT [FK_COMPRAS_COMPRAS] FOREIGN KEY([ID]) ' +
           'REFERENCES [dbo].[COMPRAS] ([ID])';
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Text := SQL;
    Query2.ExecSQL;

    SQL := 'ALTER TABLE [dbo].[COMPRAS] CHECK CONSTRAINT [FK_COMPRAS_COMPRAS] ';
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Text := SQL;
    Query2.ExecSQL;
  End;

  if not ExisteTablaSQL('COMPRAS_MOV',strConexionPrincipal,False) then
  Begin
    SQL := 'CREATE TABLE [dbo].[COMPRAS_MOV]( ' + chr(10) + chr(13) +
           '  [ID_Compra] [INT] NOT NULL, ' + chr(10) + chr(13) +
           '  [Codigo] [VARCHAR](15) NOT NULL, ' + chr(10) + chr(13) +
           '  [Nombre] [VARCHAR](100) NULL, ' + chr(10) + chr(13) +
           '  [Costo] [DECIMAL](28, 4) NOT NULL, ' + chr(10) + chr(13) +
           '  [CostoProrrateado] [DECIMAL](28, 4) NOT NULL, ' + chr(10) + chr(13) +
           '  [Impuesto] [DECIMAL](28, 4) NOT NULL, ' + chr(10) + chr(13) +
           '  [Cantidad] [DECIMAL](28, 4) NOT NULL, ' + chr(10) + chr(13) +
           '  [Valorem] [DECIMAL](28, 4) NOT NULL ' + chr(10) + chr(13) +
           ') ON [PRIMARY]';
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Text := SQL;
    Query2.ExecSQL;

    SQL := 'ALTER TABLE [dbo].[COMPRAS_MOV]  WITH CHECK ADD  CONSTRAINT [FK_COMPRAS_MOV_COMPRAS] FOREIGN KEY([ID_Compra]) ' + chr(10) + chr(13) +
           'REFERENCES [dbo].[COMPRAS] ([ID]) ' + chr(10) + chr(13) +
           'ON UPDATE CASCADE ' + chr(10) + chr(13) +
           'ON DELETE CASCADE ';
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Text := SQL;
    Query2.ExecSQL;

    SQL := 'ALTER TABLE [dbo].[COMPRAS_MOV] CHECK CONSTRAINT [FK_COMPRAS_MOV_COMPRAS] ';
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Text := SQL;
    Query2.ExecSQL;
  End;

  CargarDatos(ProximoID-1);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.InicializarVariables;
begin
  KeyPreview := True;
  txtCodigo.Text := EmptyStr;
  txtID.Text := EmptyStr;
  txtDocumento.Text := EmptyStr;
  txtCantidad.Text := FormatFloat(fmNumero2d, 0);
  txtPrecio.text := FormatFloat(fmNumero4d, 0);
  txtImpuesto.Text := FormatFloat(fmNumero4d, 0);
  txtExpediente.Text := EmptyStr;
  txtTasaCambio.Text := FormatFloat(fmNumero4d, 0);
  txtFlete.Text := FormatFloat(fmNumero4d, 0);
  txtFechaAprobacion.Text := EmptyStr;
  txtImportacion.Text := FormatFloat(fmNumero4d, 0);
  txtTotalImpuesto.Text := FormatFloat(fmNumero4d, 0);
  txtTotalMercancia.Text := FormatFloat(fmNumero4d, 0);
  txtSeguro.Text := FormatFloat(fmNumero4d, 0);
  txtValorem.Text := FormatFloat(fmNumero4d, 0);
  cmbProveedor.Text := EmptyStr;
  cmbProveedor.Clear;
  txtTotalMercancia.Enabled := False;
  txtTotalImpuesto.Enabled := False;
  dpFecha.DateTime := Now;

  Grid.Columns[0].FieldName := 'Codigo';
  Grid.Columns[0].Title.Caption := 'Codigo';
  Grid.Columns[0].Title.Alignment := taCenter;
  Grid.Columns[0].Title.Font.Style := [fsBold];
  Grid.Columns[0].ReadOnly := True;
  Grid.Columns[0].AutoFitColWidth := True;
  Grid.Columns[1].FieldName := 'Nombre';
  Grid.Columns[1].Width := 200;
  Grid.Columns[1].Title.Caption := 'Nombre';
  Grid.Columns[1].Title.Alignment := taCenter;
  Grid.Columns[1].Title.Font.Style := [fsBold];
  Grid.Columns[1].ReadOnly := True;
  Grid.Columns[2].FieldName := 'Cantidad';
  Grid.Columns[2].Title.Caption := 'Cantidad';
  Grid.Columns[2].Title.Alignment := taCenter;
  Grid.Columns[2].Title.Font.Style := [fsBold];
  Grid.Columns[2].DisplayFormat := fmNumero2d;
  Grid.Columns[2].ReadOnly := True;
  Grid.Columns[2].AutoFitColWidth := True;
  Grid.Columns[3].FieldName := 'Costo';
  Grid.Columns[3].Title.Caption := 'Costo';
  Grid.Columns[3].Title.Alignment := taCenter;
  Grid.Columns[3].Title.Font.Style := [fsBold];
  Grid.Columns[3].DisplayFormat := fmNumero4d;
  Grid.Columns[3].ReadOnly := True;
  Grid.Columns[3].AutoFitColWidth := True;
  Grid.Columns[4].FieldName := 'TotalCosto';
  Grid.Columns[4].Title.Caption := 'Total Costo';
  Grid.Columns[4].Title.Alignment := taCenter;
  Grid.Columns[4].Title.Font.Style := [fsBold];
  Grid.Columns[4].DisplayFormat := fmNumero4d;
  Grid.Columns[4].Color := clInactiveCaption;
  Grid.Columns[4].ReadOnly := true;
  Grid.Columns[4].AutoFitColWidth := True;
  Grid.Columns[5].FieldName := 'Impuesto';
  Grid.Columns[5].Title.Caption := 'Impuesto';
  Grid.Columns[5].Title.Alignment := taCenter;
  Grid.Columns[5].Title.Font.Style := [fsBold];
  Grid.Columns[5].DisplayFormat := fmNumero4d;
  Grid.Columns[5].ReadOnly := true;
  Grid.Columns[5].AutoFitColWidth := True;
  Grid.Columns[6].FieldName := 'TotalImpuesto';
  Grid.Columns[6].Title.Caption := 'Total Impuesto';
  Grid.Columns[6].Title.Alignment := taCenter;
  Grid.Columns[6].Title.Font.Style := [fsBold];
  Grid.Columns[6].DisplayFormat := fmNumero4d;
  Grid.Columns[6].Color := clInactiveCaption;
  Grid.Columns[6].ReadOnly := true;
  Grid.Columns[6].AutoFitColWidth := True;
  Grid.Columns[7].FieldName := 'CostoProrrateado';
  Grid.Columns[7].Title.Caption := 'Prorrateo';
  Grid.Columns[7].Title.Alignment := taCenter;
  Grid.Columns[7].Title.Font.Style := [fsBold];
  Grid.Columns[7].DisplayFormat := fmNumero4d;
  Grid.Columns[7].Color := clInactiveCaption;
  Grid.Columns[7].ReadOnly := true;
  Grid.Columns[7].AutoFitColWidth := True;
  Grid.Columns[8].FieldName := 'Valorem';
  Grid.Columns[8].Title.Caption := 'Ad Valorem';
  Grid.Columns[8].Title.Alignment := taCenter;
  Grid.Columns[8].Title.Font.Style := [fsBold];
  Grid.Columns[8].DisplayFormat := fmNumero4d;
  Grid.Columns[8].Color := clInactiveCaption;
  Grid.Columns[8].ReadOnly := true;
  Grid.Columns[8].AutoFitColWidth := True;
  Grid.Columns[9].FieldName := 'TotalBs';
  Grid.Columns[9].Title.Caption := 'Total Bs';
  Grid.Columns[9].Title.Alignment := taCenter;
  Grid.Columns[9].Title.Font.Style := [fsBold];
  Grid.Columns[9].DisplayFormat := fmNumero4d;
  Grid.Columns[9].Color := clInactiveCaption;
  Grid.Columns[9].ReadOnly := true;
  Grid.Columns[9].AutoFitColWidth := True;
  Grid.AutoFitColWidths := True;
  Grid.DataSource := DS;
  DS.DataSet := Query;
  Query.Close;

  //QueryProv.Close;
  QueryProv.SQL.Clear;
  QueryProv.ConnectionString := strConexionPrincipal;
  QueryProv.SQL.Text := 'SELECT * FROM dbo.SAPROV';
  QueryProv.Open;
  DSProv.DataSet := QueryProv;
  cmbProveedor.DropDownBox.ListSource := DSProv;
  cmbProveedor.DropDownBox.ListSourceAutoFilter := True;
  cmbProveedor.DropDownBox.Rows := 10;
  cmbProveedor.KeyField := 'CodProv' ;
  cmbProveedor.ListField := 'Descrip';
  cmbProveedor.ListSource := DSProv;
  cmbProveedor.DropDownBox.Columns[0].Title.Caption  :='Codigo';
  cmbProveedor.DropDownBox.Columns[0].FieldName := 'CodProv';
  cmbProveedor.DropDownBox.Columns[0].Width := 50;
  cmbProveedor.DropDownBox.Columns[1].Title.Caption :='Nombre';
  cmbProveedor.DropDownBox.Columns[1].FieldName := 'Descrip';
  cmbProveedor.DropDownBox.Columns[1].Width := 200;
  cmbProveedor.DropDownBox.AutoFitColWidths := True;
  cmbProveedor.AutoSize := False;
  cmbProveedor.DropDownBox.Width := 300;
  cmbProveedor.DropDownBox.ShowTitles := True;
  cmbProveedor.Font.Color := clBlack;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.CargarDatos(Numero: Integer);
Var
  I               : Integer;
  SQL             : string;
  //COMPRAS
  ID              : Integer;
  Documento       : String;
  Proveedor       : String;
  Fecha           : String;
  FechaAprobacion : string;
  Aprobado        : Integer;
  Expediente      : string;
  TasaCambio      : Double;
  Impuesto        : Double;
  TotalMercancia  : Double;
  Flete           : Double;
  Importacion     : Double;
  Otros           : Double;
  //COMPRAS_MOV
  Codigo          : string;
  Nombre          : string;
  Costo           : Double;
  CostoProrrateado: Double;
  ImpuestoM       : Double;
  Cantidad        : Double;
  TotalBs         : Double;
  Valorem         : Double;

begin
  IF Numero = 0 Then
  begin
    ID := Numero;
  end;

  SQL := 'SELECT ID, Documento, Proveedor, Fecha, FechaAprobacion, Aprobado, ' + chr(10) + chr(13) +
         '  Expediente, TasaCambio, Impuesto, TotalMercancia, Flete, Importacion, Otros ' + chr(10) + chr(13) +
         '  FROM dbo.COMPRAS ' + chr(10) + chr(13) +
         '  WHERE ID = :ID ';
  Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Text := SQL;
  Query2.Parameters.ParamByName('ID').Value := Numero;
  Query2.Open;
  if Query2.Eof then
  begin
    InicializarVariables;
    Abort;
  end;
  ID              := Query2.FieldByName('ID').Value;
  Documento       := Query2.FieldByName('Documento').Value;
  Proveedor       := Query2.FieldByName('Proveedor').Value;
  Fecha           := Query2.FieldByName('Fecha').Value;
  FechaAprobacion := Query2.FieldByName('FechaAprobacion').Value;
  Aprobado        := Query2.FieldByName('Aprobado').Value;
  Expediente      := Query2.FieldByName('Expediente').Value;
  TasaCambio      := Query2.FieldByName('TasaCambio').Value;
  Impuesto        := Query2.FieldByName('Impuesto').Value;
  TotalMercancia  := Query2.FieldByName('TotalMercancia').Value;
  Flete           := Query2.FieldByName('Flete').Value;
  Importacion     := Query2.FieldByName('Importacion').Value;
  Otros           := Query2.FieldByName('Otros').Value;
  Query2.Close;

  txtID.Text := IntToStr(ID);
  txtDocumento.Text := Documento;
  cmbProveedor.KeyValue := Proveedor;
  dpFecha.Date := StrToDate(Fecha);
  if Aprobado = 1 then
  begin
    txtFechaAprobacion.Text := FechaAprobacion;
    txtFechaAprobacion.Visible := True;
    txtFechaAprobacion.Enabled := False;
    lblFechaAprobacion.Visible := True;
    txtFlete.Enabled := False;
    txtDocumento.Enabled := False;
    txtTasaCambio.Enabled := False;
    txtCantidad.Enabled := False;
    txtPrecio.Enabled := False;
    txtImpuesto.Enabled := False;
    txtExpediente.Enabled := False;
    txtImportacion.Enabled := False;
    txtSeguro.Enabled := False;
    txtValorem.Enabled := False;
    cmbProveedor.Enabled := False;
    btnGuardar.Enabled := False;
  end
    else
    begin
      txtFechaAprobacion.Visible := False;
      txtFechaAprobacion.Enabled := False;
      lblFechaAprobacion.Visible := False;
      txtFlete.Enabled := True;
      txtDocumento.Enabled := True;
      txtTasaCambio.Enabled := True;
      txtCantidad.Enabled := True;
      txtPrecio.Enabled := True;
      txtImpuesto.Enabled := True;
      txtExpediente.Enabled := True;
      txtImportacion.Enabled := True;
      txtSeguro.Enabled := True;
      txtValorem.Enabled := True;
      cmbProveedor.Enabled := True;
      btnGuardar.Enabled := True;
    end;
  txtExpediente.Text := Expediente;
  txtTasaCambio.Text := FloatToStr(TasaCambio);
  txtTotalImpuesto.Text := FloatToStr(Impuesto);
  txtTotalMercancia.Text := FloatToStr(TotalMercancia);
  txtFlete.Text := FloatToStr(Flete);
  txtImportacion.Text := FloatToStr(Importacion);
  txtSeguro.Text  := FloatToStr(Otros);

  txtTasaCambio.Text := FormatFloat(fmNumero4d, StrToFloat(txtTasaCambio.Text));
  txtTotalImpuesto.Text := FormatFloat(fmNumero4d, StrToFloat(txtTotalImpuesto.Text));
  txtTotalMercancia.Text := FormatFloat(fmNumero4d, StrToFloat(txtTotalMercancia.Text));
  txtFlete.Text := FormatFloat(fmNumero4d, StrToFloat(txtFlete.Text));
  txtImportacion.Text := FormatFloat(fmNumero4d, StrToFloat(txtImportacion.Text));
  txtSeguro.Text  := FormatFloat(fmNumero4d, StrToFloat(txtSeguro.Text));

  SQL := 'SELECT Codigo, Nombre, Costo, CostoProrrateado, Impuesto, Impuesto*Cantidad AS TotalImpuesto, ' +
         'Cantidad, Costo*Cantidad AS TotalCosto, Valorem*Cantidad AS Valorem, ' +
         'CostoProrrateado * ' + NumeroASQL(TasaCambio) + ' AS TotalBs ' +
         'FROM dbo.COMPRAS_MOV WHERE ID_Compra = :ID_Compra';
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Text := SQL;
  Query.Parameters.ParamByName('ID_Compra').Value := Numero;
  Query.Open;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.cmbProveedorExit(Sender: TObject);
begin
  txtExpediente.SetFocus;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.dpFechaExit(Sender: TObject);
begin
  txtTasaCambio.SetFocus;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtSeguroEnter(Sender: TObject);
begin
  txtSeguro.SelText;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtSeguroExit(Sender: TObject);
begin
  if txtSeguro.Text = EmptyStr then
    txtSeguro.Text := '0';
  txtSeguro.Text := FormatearNumero4d(txtSeguro.Text);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtSeguroKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(integer(enumTecla.Enter)) then
    txtCodigo.SetFocus;
  Key := SoloDecimalEnCaja(txtSeguro, Key);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtTasaCambioEnter(Sender: TObject);
begin
  SeleccionarTextoEdit(txtTasaCambio);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtTasaCambioExit(Sender: TObject);
begin
  if txtImpuesto.Text = EmptyStr then
    txtImpuesto.Text := '0';
  txtTasaCambio.Text := FormatearNumero4d(txtTasaCambio.Text);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtTasaCambioKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = chr(integer(enumTecla.Enter)) then
    txtFlete.SetFocus;
  Key := SoloDecimalEnCaja(txtTasaCambio, Key);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtTotalImpuestoChange(Sender: TObject);
begin
//  txtTotalImpuesto.Text := StringReplace(txtTotalImpuesto.Text, '.', '', [rfReplaceAll, rfIgnoreCase]);
//  txtTotalImpuesto.Text := FormatFloat(fmNumero4d, StrToFloat(txtTotalImpuesto.Text));
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtTotalImpuestoExit(Sender: TObject);
begin
    txtTotalImpuesto.Text := FormatFloat(fmNumero4d, StrToFloat(txtTotalImpuesto.Text));
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtTotalMercanciaChange(Sender: TObject);
begin
//  txtTotalMercancia.Text := StringReplace(txtTotalMercancia.Text, '.', '', [rfReplaceAll, rfIgnoreCase]);
//  txtTotalMercancia.Text := FormatFloat(fmNumero4d, StrToFloat(txtTotalMercancia.Text));
end;

procedure TformRegistroCompra.txtTotalMercanciaEnter(Sender: TObject);
begin

end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtValoremEnter(Sender: TObject);
begin
  txtValorem.SelText;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtValoremExit(Sender: TObject);
begin
  if txtValorem.Text = EmptyStr then
    txtValorem.Text := '0';
  txtValorem.Text := FormatearNumero4d(txtValorem.Text);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.txtValoremKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = chr(integer(enumTecla.Enter)) then
    txtImpuesto.SetFocus;
  Key := SoloDecimalEnCaja(txtValorem, Key);
end;
//--------------------------------------------------------------------------------------------------------
function TformRegistroCompra.ExisteID(Numero: Integer): Boolean;
var
  SQL: string;
begin
  Result := False;
  SQL := 'SELECT * FROM dbo.COMPRAS WHERE ID = :ID';
  Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Text := SQL;
  Query2.Parameters.ParamByName('ID').Value := Numero;
  Query2.Open;
  if Not Query2.Eof then
    Result := True;
  Query2.Close;
  //Actualizar := Result;
end;
//--------------------------------------------------------------------------------------------------------
function TformRegistroCompra.ProximoID: Integer;
var
  SQL: string;
begin
  SQL := 'SELECT ISNULL(MAX(ID),0)+1 AS Numero FROM dbo.COMPRAS';
  Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Text := SQL;
  Query2.Open;
  Result := Query2.FieldByName('Numero').Value;
  Query2.Close;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.GuardarEncabezado(ID: Integer; Documento: string;
                                                Proveedor: string; Fecha: string;
                                                FechaAprobacion: string; Aprobado: Integer;
                                                Expediente: string; TasaCambio: Double;
                                                Impuesto: Double; TotalMercancia: Double;
                                                Flete: Double; Importacion: Double;
                                                Otros: Double);
var
  SQL : string;
begin
  If ValidarCampos Then
  begin
    if ExisteDocumento(ID) then
    begin
      SQL := 'UPDATE dbo.COMPRAS ' +
             'SET Documento= :Documento, Proveedor= :Proveedor, Fecha= :Fecha, FechaAprobacion= :FechaAprobacion, ' +
             'Aprobado= :Aprobado, Expediente = :Expediente, TasaCambio= :TasaCambio, Impuesto= :Impuesto, TotalMercancia= :TotalMercancia, ' +
             'Flete= :Flete, Importacion= :Importacion, Otros= :Otros ' +
             'WHERE ID= :ID;';
      Query2.Close;
      Query2.SQL.Clear;
      Query2.SQL.Text := SQL;
      Query2.Parameters.ParamByName('Documento').Value := Documento;
      Query2.Parameters.ParamByName('Proveedor').Value := Proveedor;
      Query2.Parameters.ParamByName('Fecha').Value := Fecha;
      Query2.Parameters.ParamByName('FechaAprobacion').Value := Now;
      Query2.Parameters.ParamByName('Aprobado').Value := Aprobado;
      Query2.Parameters.ParamByName('Expediente').Value := Expediente;
      Query2.Parameters.ParamByName('TasaCambio').Value := TasaCambio;
      Query2.Parameters.ParamByName('Impuesto').Value := Impuesto;
      Query2.Parameters.ParamByName('TotalMercancia').Value := TotalMercancia;
      Query2.Parameters.ParamByName('Flete').Value := Flete;
      Query2.Parameters.ParamByName('Importacion').Value := Importacion;
      Query2.Parameters.ParamByName('Otros').Value := Otros;
      Query2.Parameters.ParamByName('ID').Value := ID;
      Query2.ExecSQL;
    end
      else
      begin
        SQL := 'INSERT INTO dbo.COMPRAS(ID, Documento, Proveedor, Fecha, FechaAprobacion, ' +
               'Aprobado, Expediente, TasaCambio, Impuesto, TotalMercancia, Flete, Importacion, ' +
               'Otros) ' +
               'VALUES(:ID, :Documento, :Proveedor, :Fecha, :FechaAprobacion, :Aprobado, :Expediente, ' +
               ':TasaCambio, :Impuesto, :TotalMercancia, :Flete, :Importacion, :Otros)';
        Query2.Close;
        Query2.SQL.Clear;
        Query2.SQL.Text := SQL;
        Query2.Parameters.ParamByName('ID').Value := ID;
        Query2.Parameters.ParamByName('Documento').Value := Documento;
        Query2.Parameters.ParamByName('Proveedor').Value := Proveedor;
        Query2.Parameters.ParamByName('Fecha').Value := Fecha;
        Query2.Parameters.ParamByName('FechaAprobacion').Value := Now;
        Query2.Parameters.ParamByName('Aprobado').Value := Aprobado;
        Query2.Parameters.ParamByName('Expediente').Value := Expediente;
        Query2.Parameters.ParamByName('TasaCambio').Value := TasaCambio;
        Query2.Parameters.ParamByName('Impuesto').Value := Impuesto;
        Query2.Parameters.ParamByName('TotalMercancia').Value := TotalMercancia;
        Query2.Parameters.ParamByName('Flete').Value := Flete;
        Query2.Parameters.ParamByName('Importacion').Value := Importacion;
        Query2.Parameters.ParamByName('Otros').Value := Otros;
        Query2.ExecSQL;
      end;
  end;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.GuardarMovimiento(ID_Compra: Integer; Codigo: string; Nombre: string;
                                                Costo: Double; CostoProrrateado: Double; Impuesto: Double;
                                                Cantidad: Double; Valorem: Double);
var
  SQL : string;
begin
  if ValidarCampos then
  begin
    SQL := 'INSERT INTO dbo.COMPRAS_MOV(ID_Compra, Codigo, Nombre, Costo, CostoProrrateado, Impuesto, Cantidad, Valorem) ' +
           'VALUES(:ID_Compra, :Codigo, :Nombre, :Costo, :CostoProrrateado, :Impuesto, :Cantidad, :Valorem)';
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Text := SQL;
    Query2.Parameters.ParamByName('ID_Compra').Value := ID_Compra;
    Query2.Parameters.ParamByName('Codigo').Value := Codigo;
    Query2.Parameters.ParamByName('Nombre').Value := Nombre;
    Query2.Parameters.ParamByName('Costo').Value := Costo;
    Query2.Parameters.ParamByName('CostoProrrateado').Value := CostoProrrateado;
    Query2.Parameters.ParamByName('Impuesto').Value := Impuesto;
    Query2.Parameters.ParamByName('Cantidad').Value := Cantidad;
    Query2.Parameters.ParamByName('Valorem').Value := Valorem;
    Query2.ExecSQL;

    SQL := 'UPDATE dbo.COMPRAS SET TotalMercancia = DATA.Mercancia, Impuesto = DATA.Impuesto ' +
           'FROM ( ' +
           'SELECT SUM(M.CostoProrrateado*M.Cantidad*C.TasaCambio) AS Mercancia, SUM(M.Impuesto*M.Cantidad*C.TasaCambio) AS Impuesto, M.ID_Compra ' +
           'FROM dbo.COMPRAS_MOV M INNER JOIN COMPRAS C ON C.ID = M.ID_Compra WHERE ID_Compra = :ID_Compra GROUP BY ID_Compra ' +
           ') DATA INNER JOIN dbo.COMPRAS C ON C.ID = DATA.ID_Compra';
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Text := SQL;
    Query2.Parameters.ParamByName('ID_Compra').Value := ID_Compra;
    Query2.ExecSQL;

    AplicarProrrateo(ID_Compra, False);
  end;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.BuscarClick(Sender: TObject);
begin
  frmCatalogoCompras.ShowModal;
end;
//--------------------------------------------------------------------------------------------------------
Function TformRegistroCompra.BuscarCodigo(Codigo: string): Boolean;
var
  SQL : string;
begin
  NombreArticulo := EmptyStr;
  Result := False;
  SQL := 'SELECT * FROM dbo.SAPROD WHERE CodProd = :Codigo';
  Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Text := SQL;
  Query2.Parameters.ParamByName('Codigo').Value := Codigo;
  Query2.Open;
  if not Query2.Eof then
  begin
    Result := True;
    NombreArticulo := Query2.FieldByName('Descrip').Value;
  end;
  Query2.Close;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.AplicarProrrateo(Numero: Integer; ParaAprobar: Boolean);
var
  Flete       : Double;
  Importacion : Double;
  Seguro      : Double;
  Impuesto    : Double;
  Mercancia   : Double;
  Factor      : Double;
  SQL         : string;
  M           : string;
  CERO        : string;
  CeroUno     : string;
  Server      : string;
  Blanco      : string;

begin
  M := QuotedStr('M');
  CERO := QuotedStr('00000');
  CeroUno := QuotedStr('01');
  Server := QuotedStr('server');
  Blanco := QuotedStr('');

  Flete :=  StrToFloat(StringReplace(txtFlete.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]));
  Importacion := StrToFloat(StringReplace(txtImportacion.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]));
  Seguro := StrToFloat(StringReplace(txtSeguro.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]));
  Impuesto := StrToFloat(StringReplace(txtTotalImpuesto.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]));
  Mercancia := StrToFloat(StringReplace(txtTotalMercancia.Text, SeparadorMiles, '', [rfReplaceAll, rfIgnoreCase]));
  Factor := 0;

  SQL := 'SELECT SUM(Costo*Cantidad) AS Total FROM dbo.COMPRAS_MOV WHERE ID_Compra = :ID';
  Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Text := SQL;
  Query2.Parameters.ParamByName('ID').Value := Numero;
  Query2.Open;
  Mercancia := Query2.FieldByName('Total').Value;

  if Mercancia <> 0 then
  Begin
    Factor := (Flete + Importacion + Seguro) / Mercancia;
  End;

  SQL := 'UPDATE dbo.COMPRAS_MOV SET CostoProrrateado = Costo + (Costo*:Factor) + Valorem ' +
         'WHERE ID_Compra = :ID_Compra';
  Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Text := SQL;
  Query2.Parameters.ParamByName('Factor').Value := Factor;
  Query2.Parameters.ParamByName('ID_Compra').Value := Numero;
  Query2.ExecSQL;

  SQL := 'UPDATE dbo.COMPRAS SET TotalMercancia = DATA.Mercancia, Impuesto = DATA.Impuesto ' +
         'FROM ( ' +
         'SELECT SUM(M.CostoProrrateado*M.Cantidad*C.TasaCambio) AS Mercancia, SUM(M.Impuesto*M.Cantidad*C.TasaCambio) AS Impuesto, M.ID_Compra ' +
         'FROM dbo.COMPRAS_MOV M INNER JOIN COMPRAS C ON C.ID = M.ID_Compra WHERE ID_Compra = :ID_Compra GROUP BY ID_Compra ' +
         ') DATA INNER JOIN dbo.COMPRAS C ON C.ID = DATA.ID_Compra';
  Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Text := SQL;
  Query2.Parameters.ParamByName('ID_Compra').Value := Numero;
  Query2.ExecSQL;

  if ParaAprobar then
  begin
    SQL := 'INSERT INTO dbo.SACOMP( [TipoCom],[CodSucu],[CodUsua],[CodEsta],[FechaT],[NumeroD],[CodProv],[CodUbic], ' +
           '[Descrip],[Factor],[Direc1],[ID3],[FechaE],[FechaV],[TGravable],[TotalPrd]) ' +
           'SELECT '+M+','+CERO+','+CeroUno+','+Server+',GETDATE(),C.Documento,C.Proveedor, NULL, :Proveedor, '+ NumeroASQL(Factor) +', '+Blanco+', ' +
           'C.Proveedor, C.Fecha, C.Fecha, C.TotalMercancia, SUM(M.Cantidad) AS Unds ' +
           'FROM dbo.COMPRAS C ' +
           'INNER JOIN COMPRAS_MOV M ON M.ID_Compra = C.ID ' +
           'WHERE C.ID = :ID ' +
           'GROUP BY C.Documento, C.Proveedor, C.Fecha, C.TotalMercancia ';
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Text := SQL;
    Query2.Parameters.ParamByName('Proveedor').Value := cmbProveedor.Text;
    Query2.Parameters.ParamByName('ID').Value := Numero;
    Query2.ExecSQL;

    SQL := 'INSERT INTO SAITEMCOM ([CodSucu],[CodProv],[TipoCom],[NumeroD],[NroLinea],[FechaE],[CodItem], ' +
           '[CodUbic],[Cantidad],[Costo],[Precio1],[Precio2],[Precio3],[TotalItem],[DEsLote], ' +
           '[NroUnicoL],[NroLote],[FechaL],[ExistAntU],[ExistAnt],[Descrip1]) ' +
           'SELECT '+CERO+', C.Proveedor, '+M+', C.Documento, ROW_NUMBER() OVER (ORDER BY C.Fecha), C.Fecha, ' +
           'M.Codigo, '+CeroUno+', M.Cantidad, M.CostoProrrateado*C.TasaCambio, 0, 0, 0, M.Cantidad * M.Costo*C.TasaCambio, 0, 0, NULL, C.Fecha, 0, 0, M.Nombre ' +
           'FROM dbo.COMPRAS_MOV M INNER JOIN dbo.COMPRAS C ON C.ID = M.ID_Compra ' +
           'WHERE C.ID = :ID ';
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Text := SQL;
    Query2.Parameters.ParamByName('ID').Value := Numero;
    Query2.ExecSQL;

    SQL := 'INSERT INTO SAPRIMCOM ([CodSucu],[CodProv],[TipoCom],[NumeroD],[NroLinea],[CodItem],[Factor], ' +
           '[DocImpo],[FechaI],[Precio1],[Precio2],[Precio3],[Costo1],[Costo2],[Costo3],[Costo4]) ' +
           'SELECT '+CERO+', C.Proveedor, '+M+', C.Documento, ROW_NUMBER() OVER (ORDER BY C.Fecha), ' +
           'M.Codigo, '+NumeroASQL(Factor)+', '+Blanco+', C.Fecha, 0,0,0, M.CostoProrrateado*C.TasaCambio, ' +
           'C.Flete/DATA.Neto*SUM(M.Cantidad),C.Otros/DATA.Neto*SUM(M.Cantidad), ' +
           'C.Importacion/DATA.Neto*SUM(M.Cantidad) ' +
           'FROM dbo.COMPRAS C ' +
           '  INNER JOIN dbo.COMPRAS_MOV M ON M.ID_Compra = C.ID ' +
           '	INNER JOIN (SELECT SUM(Cantidad) Neto, ID_Compra FROM dbo.COMPRAS_MOV GROUP BY ID_Compra) DATA ' +
           'ON DATA.ID_Compra = C.ID ' +
           'WHERE C.ID = :ID ' +
           'GROUP BY M.CostoProrrateado * C.TasaCambio, C.Proveedor, C.Documento, M.Codigo, C.Fecha, C.Flete, DATA.Neto, ' +
           'C.Otros, C.Importacion ';
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Text := SQL;
    Query2.Parameters.ParamByName('ID').Value := Numero;
    Query2.ExecSQL;

    ShowMessage('Compra aprobada y trasladada a SAINT');
  end;
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.AplicarAprobacion(Numero: Integer);
var
  SQL : string;
begin
  //--
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.EliminarRegistro(Numero: Integer; Codigo: string);
var
  SQL   : string;
begin
  SQL := 'DELETE FROM COMPRAS_MOV WHERE Codigo = :Codigo AND ID_Compra = :Numero';
  Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Text := SQL;
  Query2.Parameters.ParamByName('Codigo').Value := Codigo;
  Query2.Parameters.ParamByName('Numero').Value := Numero;
  Query2.ExecSQL;

  SQL := 'UPDATE dbo.COMPRAS SET TotalMercancia = DATA.Mercancia, Impuesto = DATA.Impuesto ' +
         'FROM ( ' +
         'SELECT SUM(Costo*Cantidad) AS Mercancia, SUM(Impuesto*Cantidad) AS Impuesto, ID_Compra ' +
         'FROM dbo.COMPRAS_MOV WHERE ID_Compra = :ID_Compra GROUP BY ID_Compra ' +
         ') DATA INNER JOIN dbo.COMPRAS C ON C.ID = DATA.ID_Compra';
  Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Text := SQL;
  Query2.Parameters.ParamByName('ID_Compra').Value := Numero;
  Query2.ExecSQL;

  AplicarProrrateo(Numero, False);

  ShowMessage('Registro Eliminado');
  CargarDatos(Numero);
end;
//--------------------------------------------------------------------------------------------------------
procedure TformRegistroCompra.GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Valor : string;
begin
  if key = VK_DELETE then
    Valor := Grid.DataSource.DataSet.FieldByName('Codigo').Value;

  if trim(Valor) <> EmptyStr then
  begin
    EliminarRegistro(StrToInt(txtID.Text),Valor);
  end;
end;
//--------------------------------------------------------------------------------------------------------
function TformRegistroCompra.BuscarUltimoNumero;
var
  SQL : string;
begin
  SQL := 'SELECT MAX(NroUnico)+1 AS Numero FROM sacomp';
  Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Text := SQL;
  Query2.Open;
  if Query2.Eof then
  begin
    Result := 1;
  end
    else
    begin
      Result := Query2.FieldByName('Numero').Value;
    end;
end;
//--------------------------------------------------------------------------------------------------------
function TformRegistroCompra.ExisteDocumento(Numero: integer): Boolean;
var
  SQL : string;
  ID  : Integer;
begin
  ID := Numero;

  SQL := 'SELECT * FROM COMPRAS WHERE ID = :ID';
  Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Text := SQL;
  Query2.Parameters.ParamByName('ID').Value := ID;
  Query2.Open;
  Result := (Not Query2.Eof);
  Query2.Close;
end;
//--------------------------------------------------------------------------------------------------------
function RegistrarArticulo(Codigo: String; Descripcion: string; Instancia: string; IVA: String): Boolean;
var
  SQL : string;
  QueryI : TADOQuery;
begin
  Result := False;
  QueryI := TADOQuery.Create(nil);
  QueryI.ConnectionString := strConexionPrincipal;
  if TRIM(IVA) = EmptyStr then
    IVA := '16';

  try
    try
    begin
      SQL := 'INSERT INTO dbo.SAPROD(CodProd, Descrip, CodInst, Activo) ' +
             'VALUES(:Codigo, :Nombre, :CodInst, 1)';
      QueryI.Close;
      QueryI.SQL.Clear;
      QueryI.SQL.Text := SQL;
      QueryI.Parameters.ParamByName('Codigo').Value := Trim(Codigo);
      QueryI.Parameters.ParamByName('Nombre').Value := Trim(Descripcion);
      QueryI.Parameters.ParamByName('CodInst').Value := Instancia;
      QueryI.ExecSQL;

      SQL := 'INSERT INTO dbo.SATAXPRD(CodProd, CodTaxs, Monto, EsPorct) ' +
             'VALUES(:Codigo, :CodTaxs, :Monto, 1);';
      QueryI.Close;
      QueryI.SQL.Clear;
      QueryI.SQL.Text := SQL;
      QueryI.Parameters.ParamByName('Codigo').Value := Trim(Codigo);
      QueryI.Parameters.ParamByName('CodTaxs').Value := 'IVA';
      QueryI.Parameters.ParamByName('Monto').Value := Trim(IVA);
      QueryI.ExecSQL;

      SQL := 'INSERT INTO dbo.SACODBAR(CodAlte, CodProd) ' +
             'VALUES(:CodAlte, :CodProd)';
      QueryI.Close;
      QueryI.SQL.Clear;
      QueryI.SQL.Text := SQL;
      QueryI.Parameters.ParamByName('CodAlte').Value := Trim(Codigo);
      QueryI.Parameters.ParamByName('CodProd').Value := Trim(Codigo);
      QueryI.ExecSQL;
    end;
    except
      on E: exception do
      begin
        Application.ProcessMessages;
      end;
    end;
  finally
  begin
    Result := True;
    QueryI.Free;
  end;

  end;
end;
//--------------------------------------------------------------------------------------------------------
end.

