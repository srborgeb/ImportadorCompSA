using FluentValidation;

namespace ImportadorCompSA.Modelos
{
    /// <summary>
    /// Objeto de Transferencia de Datos (DTO) para la auditoría de documentos importados.
    /// </summary>
    public class DtoReporteAgrupado
    {
        public string Proveedor { get; set; }
        public string Documento { get; set; }
    }

    /// <summary>
    /// Validador rígido utilizando FluentValidation para asegurar la integridad de la data del reporte.
    /// </summary>
    public class ValidadorDtoReporteAgrupado : AbstractValidator<DtoReporteAgrupado>
    {
        public ValidadorDtoReporteAgrupado()
        {
            RuleFor(x => x.Proveedor)
                .NotEmpty().WithMessage("El código de proveedor no puede estar vacío.");

            RuleFor(x => x.Documento)
                .NotEmpty().WithMessage("El número de documento no puede estar vacío.");
        }
    }
}