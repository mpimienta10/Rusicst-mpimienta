using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RusicstBI.Models
{
    public class ModeloConsultasPersonalizadas
    {
        public string CodigoEncuesta { get; set; }
        public string NombreEncuesta { get; set; }
        public string CodigoPregunta { get; set; }
        public string NombrePregunta { get; set; }
        public string CodigoDepartamento { get; set; }
        public string NombreDepartamento { get; set; }
        public string CodigoMunicipio { get; set; }
        public string NombreMunicipio { get; set; }
        public string EtapaPolitica { get; set; }
        public string Seccion { get; set; }
        public string Tema { get; set; }
        public string HechoVictimizante { get; set; }
        public string DinamicaDesplazamiento { get; set; }
        public string EnfoqueDiferencial { get; set; }
        public string FactoresRiesgo { get; set; }
        public string RangoEtareo { get; set; }
        public double ValorMoneda { get; set; }
        public double ValorNumero { get; set; }
        public double ValorPorcentaje { get; set; }
        public double ValorRespuestaUnica { get; set; }
    }
}