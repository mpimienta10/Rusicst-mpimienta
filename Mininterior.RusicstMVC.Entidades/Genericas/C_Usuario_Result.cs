using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Mininterior.RusicstMVC.Entidades
{
    public partial class C_Usuario_Result
    {
        public string NombresYUsername { get { return Nombres + " (" + UserName + ")"; }  }
    }
}
