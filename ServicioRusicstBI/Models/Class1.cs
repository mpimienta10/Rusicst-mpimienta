using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CustomDataProvider.Web.Models
{
    public class ConsultasPersonalizadasModels
    {
        public bool codigoEncuesta  { get; set; }
        public bool codigoEncuestaFila { get; set; }
        public bool nombreEncuesta { get; set; }
        public bool nombreEncuestaFila { get; set; }
        public bool codigoPregunta { get; set; }
        public bool codigoPreguntaFila { get; set; }
        public bool nombrePregunta { get; set; }
        public bool nombrePreguntaFila { get; set; }
        public bool codigoDepartamento { get; set; }
        public bool codigoDepartamentoFila { get; set; }
        public bool nombreDepartamento { get; set; }
        public bool nombreDepartamentoFila { get; set; }
        public bool codigoMunicipio { get; set; }
        public bool codigoMunicipioFila { get; set; }
        public bool nombreMunicipio { get; set; }
        public bool nombreMunicipioFila { get; set; }
        public bool etapaPolitica { get; set; }
        public bool etapaPoliticaFila { get; set; }
        public bool seccion { get; set; }
        public bool seccionFila { get; set; }
        public bool tema { get; set; }
        public bool temaFila { get; set; }
        public bool hechoVictimizante { get; set; }
        public bool hechoVictimizanteFila { get; set; }
        public bool dinamicaDesplazamiento { get; set; }
        public bool dinamicaDesplazamientoFila { get; set; }
        public bool enfoqueDiferencial { get; set; }
        public bool enfoqueDiferencialFila { get; set; }
        public bool factoresRiesgo { get; set; }
        public bool factoresRiesgoFila { get; set; }
        public bool rangoEtareo { get; set; }
        public bool rangoEtareoFila { get; set; }
        public bool moneda { get; set; }
        public bool monedaFila { get; set; }
        public bool numero { get; set; }
        public bool numeroFila { get; set; }
        public bool porcentaje { get; set; }
        public bool porcentajeFila { get; set; }
        public bool respuestaUnica { get; set; }
        public bool respuestaUnicaFila { get; set; }
        public string filtroEncuesta { get; set; }
        public string filtroDepartamento { get; set; }
        public string filtroMunicipio { get; set; }
        public string filtroPreguntas { get; set; }
        //ref String errorServicio
    }

    public class CrearPersonalizadasModels
    {
        public int idConsultaPredefinida { get; set; }
        public string nombre { get; set; }
        public string descripcion { get; set; }
        public string codigoPreguntas { get; set; }
        public string codigoEncuesta { get; set; }
        public string codigoDepartamento { get; set; }
        public string codigoMunicipio { get; set; }
    }

    public class cambiarModel
    {
        public int idConsultaPredefinida { get; set; }
        public string control { get; set; }
    }
}