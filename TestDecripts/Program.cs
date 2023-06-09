using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilidades;

namespace TestDecripts
{
    class Program
    {
        static void Main(string[] args)
        {
            //Obtener llaves
            // llave publica ----Guardar en db llave privada. llave publica
            //post , Texto plano, llave publica -- busqueda llave publica --guardar texto cryp --

            var keys =Encrypt.GenerateKey();
            Console.WriteLine(JsonConvert.SerializeObject(keys.ToList()) + "Keys");
            var cryp = Encrypt.EncryptRSA(keys.FirstOrDefault(f=>f.Key== "42f46a59-6875-4904-96fb-1ff6ca469312").Value, "Probando RSA");

            Console.WriteLine(cryp + "Dato Cryps :: Probando RSA en Base64");

            var de = Encrypt.Decrypt(keys.FirstOrDefault(f => f.Key == "143ef900-5f7d-4428-890b-5808ba8c2fbf").Value,cryp);


            var keys2 = Encrypt.GenerateKey();

            if(keys.FirstOrDefault(f => f.Key == "42f46a59-6875-4904-96fb-1ff6ca469312").Value == keys2.FirstOrDefault(f => f.Key == "42f46a59-6875-4904-96fb-1ff6ca469312").Value)
            {
                Console.WriteLine(de + "Dato DeCryps");
            }

            Console.WriteLine(de + "Dato DeCryps");
        }
    }
}
