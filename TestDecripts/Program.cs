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
                string keyEjemplo = "x4zEU9yKqtmdBV1X9zwIW8lwhbjjfpqf9vU/6g7T9nrYxRfVwdJEofzXnRpfCB6s/3InvcMYUOEco91SjjzOVYbDmKn2pvDVnYoXP5h+V/JqHImqWfA+p6ywlvxQxzhiyUvz7ZyLSvvws//Hu8EaaGl6mgJtaQ2B2G4u/+adBdOoHpUNXXhcJvx78js0NMbAnN9sJAC7eXMVCGC1oK/9JsQm3RMNE5OukjAYf7GEdasO7wqAtzMIuPPQSIF1WHxtWaMKpLzbySnHEPPxmKl+oNS/b3EOdGBM5dD/pnAd+G9Uk2aBI4yWG6DdhS6TIXxoxhSgIej17OVf5mVcH/sTTSKybB7UqS2sC4pkMZHMvaecddVEYSW8YwqxkhJc6LRuMNipPrOh0VMWN+RfH/WkL3gK5ylu1OVKAFJcVg4u6P8U0w1Ae/DPFgQW+nlBvzxmk5DQXqyFaBH9lHrzIAQo6gIVTKNyKLyWzK/1gBmNE9yKExQY/AlE4arlS9VmWr8MOiKBAlkHk1n1huBOyzZ0qf/AUxaZjP9zErOFGVf+VkPAZgGakhs9N+AdX1KhuA43utOU2yMLJFstqYl/T+JCJ6MLWZH12UZGKEJ+5jlH1/6iMPyxTEMirrwOHl8DOmrPI2wy53K1a9teREVu0ZFRRjn4dgwLF6yNk7kh4/szLV1lf0f11DO6jSJtdSs+mrr9mBZxLEq8cr1oxb8R8dwlDu2+MC3fNinxZRca+r19e0i/37csVOWIiXt/iYg0PKbS";
                var test = JsonConvert.SerializeObject(new XIdentify() {rol="GOBERNACIOM",departamento="BOGOTA D.C.",municipio= "BOGOTA D.C." });
                var result = EncryptVivanto.EncryptRSA(keyEjemplo, test);
            }
                catch (Exception)
                {

                    throw;
                }

        }
    }
}
