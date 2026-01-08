using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace ImportadorCompras
{
    public class DatabaseManager
    {
        private readonly string _connectionString;
        private readonly string _codSucu;
        private readonly string _tipoCom; // Generalmente 'H' para Compras

        public DatabaseManager()
        {
            // Lectura de configuración
            _connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            _codSucu = ConfigurationManager.AppSettings["CodSucu"] ?? "00000";
            _tipoCom = ConfigurationManager.AppSettings["TipoCom"] ?? "H";
        }

        /// <summary>
        /// Obtiene y avanza el correlativo de forma atómica replicando la lógica de SACORRELSIS.
        /// Equivalente a la rutina de "Próximo Número".
        /// </summary>
        private int GetNextCorrelative(SqlTransaction transaction, string fieldName = "PrxFact")
        {
            // Lógica:
            // 1. Actualizamos sumando 1
            // 2. Leemos el valor "viejo" (OUTPUT DELETED) para usarlo como actual, 
            //    o leemos el INSERTED y restamos 1. 
            //    Para Saint, generalmente se toma el valor actual y se deja el siguiente en la tabla.

            string sql = @"
                UPDATE SACORRELSIS 
                SET ValueInt = ValueInt + 1 
                OUTPUT DELETED.ValueInt 
                WHERE CodSucu = @CodSucu AND FieldName = @FieldName";

            using (SqlCommand cmd = new SqlCommand(sql, transaction.Connection, transaction))
            {
                cmd.Parameters.AddWithValue("@CodSucu", _codSucu);
                cmd.Parameters.AddWithValue("@FieldName", fieldName);

                object result = cmd.ExecuteScalar();
                if (result != null && int.TryParse(result.ToString(), out int currentVal))
                {
                    return currentVal;
                }
                else
                {
                    throw new Exception($"No se pudo obtener el correlativo para '{fieldName}' en la sucursal '{_codSucu}'. Verifique la tabla SACORRELSIS.");
                }
            }
        }

        /// <summary>
        /// Obtiene el nombre del proveedor basado en el codigo de CodProv facilitado en el archivo segun la tabla SAPROV
        /// </summary>
        private string ObtenerProveedor(SqlTransaction transaction, string Codigo)
        {
            string sql = @"
                            SELECT Descrip 
                            FROM dbo.SAPROV
                            WHERE CodProv = @CodProv";

            using (SqlCommand cmd = new SqlCommand(sql, transaction.Connection, transaction))
            {
                cmd.Parameters.AddWithValue("@CodProv", Codigo);
                
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    return result.ToString();
                }
                else
                {
                    throw new Exception($"No se pudo obtener el nombre de proveedor para el codigo '{Codigo}'. Verifique el codigo o el registro es SAPROV.");
                }
            }
        }

        public void GuardarFacturas(List<CompraImportada> datos)
        {
            Logger.Write("Iniciando proceso de transacción SQL...");

            // 1. Agrupamos por Proveedor para crear una cabecera por cada uno
            var facturasPorProveedor = datos.GroupBy(x => x.CodProv);

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();

                foreach (var grupo in facturasPorProveedor)
                {
                    string proveedor = grupo.Key;

                    // Iniciamos transacción por cada Factura de Proveedor
                    // Si falla una factura, no afecta a las de otros proveedores.
                    using (SqlTransaction transaction = conn.BeginTransaction())
                    {
                        try
                        {
                            // A. Obtener Próximo Número (Correlativo)
                            int proximoNumero = GetNextCorrelative(transaction, "PrxFact");
                            string numeroDocumento = proximoNumero.ToString().PadLeft(10, '0'); // Relleno con ceros según estándar Saint
                            string nombreProveedor = ObtenerProveedor(transaction, proveedor);

                            Logger.Write($"Procesando Proveedor: {proveedor}. Generando Documento: {numeroDocumento}");

                            // B. Calcular Totales del Encabezado
                            // Nota: Según tu Excel, 'Monto' ya incluye todo.
                            decimal totalMonto = grupo.Sum(x => x.Monto);

                            // Tomamos datos comunes del primer registro del grupo
                            DateTime fechaEmision = grupo.First().FechaEmision;
                            string referencia = grupo.First().Referencia ?? "S/R";

                            // C. Insertar Encabezado (SACOMP)
                            InsertarEncabezado(transaction, numeroDocumento, proveedor, totalMonto, fechaEmision, referencia, nombreProveedor);

                            // D. Insertar Detalles (SAITEMCOM)
                            int nroLinea = 1;
                            foreach (var item in grupo)
                            {
                                InsertarDetalle(transaction, numeroDocumento, proveedor, item, nroLinea);
                                nroLinea++;
                            }

                            transaction.Commit();
                            Logger.Write($"Factura {numeroDocumento} guardada exitosamente.");
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            Logger.LogException(ex, $"Error guardando factura {proveedor}");
                   
                            throw;
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Réplica de la inserción en SACOMP (Encabezado de Compra)
        /// </summary>
        private void InsertarEncabezado(SqlTransaction trans, string numeroD, string codProv, decimal total, DateTime fechaE, string numeroP, string nombreProv                                   )
        {
            
            // TipoCom: 'H'
            // Signo: 1
            // Status: '0'
            // Credito: Se asume que entra a Crédito (SaldoAct = Total)
            // Fechas: FechaI (Ingreso al sistema) = GETDATE(), FechaE (Emisión) = Del Excel
            // CodEsta: Se deja vacío ('') para evitar errores de FK si 'VE' no existe.

            string query = @"
                INSERT INTO SACOMP (
                    CodSucu, TipoCom, NumeroD, CodProv, NroCtrol,
                    CodEsta, CodUsua, Signo, FechaT, OTipo, ONumero,
                    NumeroP, NumeroE, NumeroC, NumeroN, NumeroR,
                    TipoTraE, Moneda, Factor, MontoMEx, CodUbic,
                    Descrip, Direc1, Direc2, ZipCode, Telef, ID3,
                    Monto, OtrosC, MtoTax, Fletes, 
                    TGravable, TExento, DesctoP, RetenIVA,
                    FechaI, FechaR, FechaE, FechaV,
                    CancelI, CancelE, CancelT, CancelC, CancelA, CancelG,
                    MtoTotal, Contado, Credito, SaldoAct,
                    MtoPagos, MtoNCredito, MtoNDebito, Descto1, MtoInt1, Descto2, MtoInt2, MtoFinanc,
                    DetalChq, TotalPrd, TotalSrv, OrdenC, CodOper, NGiros, NMeses,
                    Notas1, Notas2, Notas3, Notas4, Notas5, Notas6, Notas7, Notas8, Notas9, Notas10,
                    NroEstable, PtoEmision, AutSRI, TipoSus, TGravable0, FromTran, CodTarj
                ) VALUES (
                    @CodSucu, @TipoCom, @NumeroD, @CodProv, '',
                    '', 'SISTEMA', 1, @FechaE, '', '',
                    @NumeroP, '', '', '', '',
                    0, '', 0, 0, '',
                    @Descrip, '', '', '', '', '',
                    @Total, 0, 0, 0, 
                    @Total, 0, 0, 0, -- Asumimos todo a TGravable por defecto o TExento según config (Ajustado a Total base)
                    GETDATE(), GETDATE(), @FechaE, @FechaE,
                    0, 0, 0, 0, 0, 0,
                    @Total, 0, @Total, @Total, -- Credito = Total, SaldoAct = Total
                    0, 0, 0, 0, 0, 0, 0, 0,
                    '', 0, @Total, '', '', 0, 0,
                    '', '', '', '', '', '', '', '', '', '',
                    '', '', '', 0, 0, 0, ''
                )";

            using (SqlCommand cmd = new SqlCommand(query, trans.Connection, trans))
            {
                cmd.Parameters.AddWithValue("@CodSucu", _codSucu);
                cmd.Parameters.AddWithValue("@TipoCom", _tipoCom);
                cmd.Parameters.AddWithValue("@NumeroD", numeroD);
                cmd.Parameters.AddWithValue("@CodProv", codProv);
                cmd.Parameters.AddWithValue("@NumeroP", numeroP); // Referencia del Excel
                cmd.Parameters.AddWithValue("@Descrip", Truncate(nombreProv, 100));
                cmd.Parameters.AddWithValue("@FechaE", fechaE);
                cmd.Parameters.AddWithValue("@Total", total);

                cmd.ExecuteNonQuery();
            }
        }

        /// <summary>
        /// Réplica de la inserción en SAITEMCOM (Detalle de Compra)
        /// </summary>
        private void InsertarDetalle(SqlTransaction trans, string numeroD, string codProv, CompraImportada item, int nroLinea)
        {
            // Análisis Delphi:
            // Cantidad: Se asume 1 si viene del Excel financiero (Monto global).
            // Precio: El Monto del Excel.
            // Costos: Se igualan al Precio.
            // Signo: 1.
            // EsServ: 1 (Asumimos servicio/gasto por la naturaleza del excel "COMPRAS NO FISCALES").

            string query = @"
                INSERT INTO SAITEMCOM (
                    CodSucu, TipoCom, NumeroD, CodProv, 
                    NroLinea, NroLineaC, 
                    CodItem, CodUbic, 
                    Descrip1, Descrip2, Descrip3, Descrip4, Descrip5, Descrip6, Descrip7, Descrip8, Descrip9, Descrip10,
                    Refere, Signo, Tara, 
                    Cantidad, CantidadO, ExistAntU, ExistAnt, Faltante, CantidadU, CantidadA, CantidadUA,
                    Costo, TotalItem, 
                    Precio1, Precio2, PrecioU2, Precio3, PrecioU3, PrecioU, Precio, Descto,
                    NroUnicoL, NroLote, FechaE, FechaL, FechaV,
                    EsServ, EsUnid, EsFreeP, EsPesa, EsExento, UsaServ, DEsLote, DEsSeri,
                    MtoTax, CostOrg, CantidadT, 
                    PrecioI1, PrecioIU1, PrecioI2, PrecioIU2, PrecioI3, PrecioIU3, CostoI
                ) VALUES (
                    @CodSucu, @TipoCom, @NumeroD, @CodProv,
                    @NroLinea, @NroLinea, 
                    @CodItem, '', 
                    @Descrip1, @Descrip2, @Descrip3, @Descrip4, @Descrip5, @Descrip6, '', '', '', '',
                    '', 1, 0,
                    1, 0, 0, 0, 0, 1, 0, 0, -- Cantidad = 1
                    @Precio, @TotalItem, 
                    @Precio, @Precio, @Precio, @Precio, @Precio, @Precio, @Precio, 0,
                    0, '', GETDATE(), GETDATE(), GETDATE(),
                    1, 1, 0, 0, 0, 0, 0, 0, -- EsServ = 1
                    0, @Precio, 0,
                    0, 0, 0, 0, 0, 0, 0
                )";

            using (SqlCommand cmd = new SqlCommand(query, trans.Connection, trans))
            {
                cmd.Parameters.AddWithValue("@CodSucu", _codSucu);
                cmd.Parameters.AddWithValue("@TipoCom", _tipoCom);
                cmd.Parameters.AddWithValue("@NumeroD", numeroD);
                cmd.Parameters.AddWithValue("@CodProv", codProv);
                cmd.Parameters.AddWithValue("@NroLinea", nroLinea);

                // Mapeo de datos del Excel
                // Si el CodItem viene vacío en Excel, usamos uno genérico o el que indique la regla de negocio
                cmd.Parameters.AddWithValue("@CodItem", string.IsNullOrWhiteSpace(item.CodItem) ? "GASTO" : item.CodItem);

                cmd.Parameters.AddWithValue("@Descrip1", Truncate(item.Descrip1, 40));
                cmd.Parameters.AddWithValue("@Descrip2", Truncate(item.Descrip2, 40));
                cmd.Parameters.AddWithValue("@Descrip3", Truncate(item.Descrip3, 40));
                cmd.Parameters.AddWithValue("@Descrip4", Truncate(item.Descrip4, 40));
                cmd.Parameters.AddWithValue("@Descrip5", Truncate(item.Descrip5, 40));
                cmd.Parameters.AddWithValue("@Descrip6", Truncate(item.Descrip6, 40));

                cmd.Parameters.AddWithValue("@Precio", item.Monto);
                cmd.Parameters.AddWithValue("@TotalItem", item.Monto); // 1 * Monto

                cmd.ExecuteNonQuery();
            }
        }

        // Función auxiliar para cortar strings que excedan el tamaño de la BD (VARCHAR 40 en SAITEMCOM)
        private string Truncate(string value, int maxLength)
        {
            if (string.IsNullOrEmpty(value)) return "";
            return value.Length <= maxLength ? value : value.Substring(0, maxLength);
        }
    }
}