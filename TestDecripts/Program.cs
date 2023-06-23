using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UtilidadesVivanto;

namespace TestDecripts
{
    class Program
    {
        static void Main(string[] args)
        {
            #region test directo
            //Obtener llaves
            // llave publica ----Guardar en db llave privada. llave publica
            //post , Texto plano, llave publica -- busqueda llave publica --guardar texto cryp --

            //var keys =Encrypt.GenerateKey();
            //Console.WriteLine(JsonConvert.SerializeObject(keys.ToList()) + "Keys");
            //var cryp = Encrypt.EncryptRSA(keys.FirstOrDefault(f=>f.Key== "42f46a59-6875-4904-96fb-1ff6ca469312").Value, "Probando RSA");

            //Console.WriteLine(cryp + "Dato Cryps :: Probando RSA en Base64");

            //var de = Encrypt.Decrypt(keys.FirstOrDefault(f => f.Key == "143ef900-5f7d-4428-890b-5808ba8c2fbf").Value,cryp);


            //var keys2 = Encrypt.GenerateKey();

            //if(keys.FirstOrDefault(f => f.Key == "42f46a59-6875-4904-96fb-1ff6ca469312").Value == keys2.FirstOrDefault(f => f.Key == "42f46a59-6875-4904-96fb-1ff6ca469312").Value)
            //{
            //    Console.WriteLine(de + "Dato DeCryps");
            //}

            //Console.WriteLine(de + "Dato DeCryps");
            #endregion

            try
            {
                string keyEjemplo = "x4zEU9yKqtmdBV1X9zwIW8lwhbjjfpqf9vU/6g7T9nrYxRfVwdJEofzXnRpfCB6s/3InvcMYUOEco91SjjzOVSHvUjExVszLnYoXP5h+V/JqHImqWfA+p6ywlvxQxzhiqC7EBQ9rOB7EF/DsRYQZgQJSIHnlTiZBEk//X080O/F6UhrPfZCYD7oNf8VNFzXdaeuSfi2XohTVPBz8UdXO0sQm3RMNE5OukjAYf7GEdasO7wqAtzMIuPPQSIF1WHxtuYSm903+I3NFIYgb/djrl2FssdGaKRWMrfZDaBAtQn9TDpdk2l/ZtNDE0Eh6EqNhLlohkcQf6gEui2qvptT8g5YbgMbhqRBxlffyL8gIVO2r3FzWyDf3ApBSbUqvUpgzgYBWJxSHMMwAFcOS1eAarNdEU++4yca7X327vsp3k/BuGui3HvLM9Z1SKmGh6JFbrwpG/XYXgu7us7FAAipNVvbmwe8OT0Qki6wdg94NMiNEETiAq0zAuMi/n0xMWxbBG2bqcBnR9zlzKR0joHOSMvBXTg1wMRE5Hbj62Ceb13J7Ndsk/bEj4YNKipimRuS7EEX1iuWD56mtHgGELs8xWGGNE7fvc9z2uleRyhi8R2GNvlFxCgTgll0z0Je0v8shfQhc1ccpu+9YT0pAGpjlZtwzUDnW1Q+v8Q6U3oewvqC6ofF4hn5dxw0yN1i2xcDkysNA1hsJlQ4uyplga+xs7+2+MC3fNinxZRca+r19e0i/37csVOWIiXt/iYg0PKbS";
                var result = EncryptVivanto.EncryptRSA(keyEjemplo,
                "{Json serrializado ejemplo}");
            }
                catch (Exception)
                {

                    throw;
                }

        }
    }
}
