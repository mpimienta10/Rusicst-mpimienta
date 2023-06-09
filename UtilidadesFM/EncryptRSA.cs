using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Utilidades
{
    public static class Encrypt
    {
        // clave publica 42f46a59-6875-4904-96fb-1ff6ca469312
        // clave privada 143ef900-5f7d-4428-890b-5808ba8c2fbf

        private  static readonly string key1Md5 = "01997528-a6e8-40e1-af70-3a448d56d73e";
        private static readonly string key2Md5 = "60f6fb29-64bb-47b3-8200-b3c06ef06e5a";

        public static List<DataCrypts> GenerateKey()
        {
            var csp = new RSACryptoServiceProvider(2048);
            var privKey = csp.ExportParameters(true);
            var pubKey = csp.ExportParameters(false);

            string pubKeyString;
            {
                var sw = new System.IO.StringWriter();
                var xs = new System.Xml.Serialization.XmlSerializer(typeof(RSAParameters));
                xs.Serialize(sw, pubKey);
                pubKeyString = sw.ToString();
            }

            List<DataCrypts> List = new List<DataCrypts>();
            List.Add(new DataCrypts() {Key= "42f46a59-6875-4904-96fb-1ff6ca469312",
                                    Value = MD5Util.Encriptar(pubKeyString, key1Md5) });

            string privKeyString;
            {
                var sw = new System.IO.StringWriter();
                var xs = new System.Xml.Serialization.XmlSerializer(typeof(RSAParameters));
                xs.Serialize(sw, privKey);
                privKeyString = sw.ToString();
            }
            List.Add(new DataCrypts() { Key = "143ef900-5f7d-4428-890b-5808ba8c2fbf",
                                        Value = MD5Util.Encriptar(privKeyString, key2Md5) });
            return List;
        }

        public static string EncryptRSA(string key, string value)
        {
            var sr = new System.IO.StringReader(MD5Util.Desencriptar(key, key1Md5));
            var xs = new System.Xml.Serialization.XmlSerializer(typeof(RSAParameters));
            var pubKey = (RSAParameters)xs.Deserialize(sr);
            var csp = new RSACryptoServiceProvider();
            csp.ImportParameters(pubKey);
            var bytesPlainTextData = System.Text.Encoding.Unicode.GetBytes(value);
            var bytesCypherText = csp.Encrypt(bytesPlainTextData, false);
            var cypherText = Convert.ToBase64String(bytesCypherText);
            return Base64.Base64Encode(cypherText);
        }

        public static string Decrypt(string key,string cypherText)
        {
            var csp = new RSACryptoServiceProvider(2048);
            var sr = new System.IO.StringReader(MD5Util.Desencriptar(key, key2Md5));
            var xs = new System.Xml.Serialization.XmlSerializer(typeof(RSAParameters));
            var privKey = (RSAParameters)xs.Deserialize(sr);
            var bytesCypherText = Convert.FromBase64String(Base64.Base64Decode(cypherText));
            csp = new RSACryptoServiceProvider();
            csp.ImportParameters(privKey);
            var bytesPlainTextData = csp.Decrypt(bytesCypherText, false);
            var plainTextData = System.Text.Encoding.Unicode.GetString(bytesPlainTextData);
            return plainTextData;
        }
    }
    public class DataCrypts
    {
        public string Key { get; set; }
        public string Value { get; set; }
    }
}
