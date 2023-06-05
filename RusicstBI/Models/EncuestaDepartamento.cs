using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RusicstBI.Models
{
    public class EncuestaDepartamento
    {
        public string Encuesta { get; set; }
        public string Departamento { get; set; }
        public double Valor { get; set; }
    }
}