using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RusicstBI.Models
{
    public class EncuestaMunicipioModel
    {
        public string Encuesta { get; set; }
        public string CodigoMunicipio { get; set; }
        public string NombreMunicipio { get; set; }
        public double Valor { get; set; }
        public string Id { get; set; }
    }
}