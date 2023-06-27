using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilidades;

namespace UtilidadesVivanto
{
    public static class EncryptVivanto
    {
        public static string EncryptRSA(string key, string value)
        {
            try
            {
                if (string.IsNullOrEmpty(key))
                {
                    throw new Exception("El key no puede ser vacio o nulo");
                }

                if (string.IsNullOrEmpty(value))
                {
                    throw new Exception("El value no puede ser vacio o nulo");
                }
                return Encrypt.EncryptRSA(key, value);
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}
