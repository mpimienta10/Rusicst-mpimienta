using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mininterior.RusicstMVC.Entities
{
    public class Contrasena
    {
        public string Password { get; set; }
        public string UserId { get; set; }
        public DateTime FechaCreacion { get; set; }
        public bool Estado { get; set; }
    }
}