using System;
using System.Collections.Generic;

namespace ImportadorCompras
{
    // Representa una línea cruda del Excel mapeada a la estructura deseada
    public class CompraImportada
    {
        // Datos para agrupación y Header
        public string CodProv { get; set; }
        public DateTime FechaEmision { get; set; } // Obtenida columna A (aunque mapeada a Descrip2, necesitamos fecha real)
        public string Referencia { get; set; } // Columna B (Referencia)

        // Datos para Detalles (SAITEMCOM) según mapeo fila 9
        public string Descrip1 { get; set; } // Col C
        public string Descrip2 { get; set; } // Col A
        public string Descrip3 { get; set; } // Col B
        public string Descrip4 { get; set; } // Col K (aprox, indice 11)
        public string Descrip5 { get; set; } // Col D
        public string Descrip6 { get; set; } // Col M (aprox, indice 13)

        public string CodItem { get; set; }  // Col I
        public decimal Monto { get; set; }   // Col L (Monto) - Usado para Precio y Total

        // Datos auxiliares calculados
        public int NroLinea { get; set; }
    }
}