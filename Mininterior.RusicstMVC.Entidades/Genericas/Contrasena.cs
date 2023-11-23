using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mininterior.RusicstMVC.Entities
{
    public class Crypts
    {
        public int Id { get; set; }
        public string keyPublic { get; set; }
        public string keyPrivate { get; set; }
    }
}