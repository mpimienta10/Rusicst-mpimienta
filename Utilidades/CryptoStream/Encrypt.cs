using System;
using System.IO;
using System.Security.Cryptography;

namespace Utilidades.CryptoStream
{
    public static class Encrypt
    {
        static public Tuple<byte[], byte[]> EncryptAES(byte[] toEncryptAES, RSAParameters RSAPublicKey)
        {
            byte[] encryptedAES = null;
            byte[] encryptedRSA = null;

            using (MemoryStream ms = new MemoryStream())
            {
                using (RijndaelManaged AES = new RijndaelManaged())
                {
                    AES.KeySize = 256;
                    AES.BlockSize = 128;
                    AES.Mode = CipherMode.CBC;
                    AES.GenerateIV();
                    AES.GenerateKey();
                    encryptedRSA = RSAEncrypt(AES.Key, RSAPublicKey);

                    ms.Write(AES.IV, 0, AES.KeySize); //Move the write here.

                    using (var cs = new CryptoStream(ms, AES.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(toEncryptAES, 0, toEncryptAES.Length);
                        cs.Close();
                    }
                    encryptedAES = ms.ToArray();
                }
            }
            return new Tuple<byte[], byte[]>(encryptedAES, encryptedRSA);
        }

        private static byte[] ReadFully(Stream stream, int length)
        {
            int offset = 0;
            byte[] buffer = new byte[length];
            while (offset < length)
            {
                offset += stream.Read(buffer, offset, length - offset);
            }
            return buffer;
        }

        static public byte[] DecryptAES(byte[] toDecryptAES, byte[] AESKeyAndIV, RSAParameters RSAPrivateKey)
        {
            byte[] AESKey = RSADecrypt(AESKeyAndIV, RSAPrivateKey);

            using (MemoryStream source = new MemoryStream(toDecryptAES))
            {
                using (RijndaelManaged AES = new RijndaelManaged())
                {
                    AES.KeySize = 256;
                    AES.BlockSize = 128;
                    AES.Key = AESKey;
                    var iv = ReadFully(source, AES.KeySize);
                    AES.IV = iv;
                    AES.Mode = CipherMode.CBC;

                    using (var cs = new CryptoStream(source, AES.CreateDecryptor(), CryptoStreamMode.Read))
                    {
                        using (var dest = new MemoryStream())
                        {
                            cs.CopyTo(dest);
                            return dest.ToArray();
                        }
                    }
                }
            }
        }
    }
}
