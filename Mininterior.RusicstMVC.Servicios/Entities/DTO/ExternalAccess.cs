using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace Mininterior.RusicstMVC.Servicios.Entities.DTO
{
    public class ExternalAccess : XIdentify
    {
        [Required]
        public string primerNombre { get; set; }
        public string segundoNombre { get; set; }
        [Required]
        public string primerApellido { get; set; }
        public string segundoApellido { get; set; }
        [Required]
        public string cargo { get; set; }
        [Required]
        public string numeroIdentificacion { get; set; }
        [Required]
        public string correo { get; set; }
        [Required]
        public string entidad { get; set; }
        [Required]
        public string dependencia { get; set; }
        [Required]
        public string subDependencia { get; set; }
    }
}