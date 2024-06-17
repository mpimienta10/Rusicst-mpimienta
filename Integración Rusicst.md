
# Integración Rusicst

Agregar Nuget de encriptación **UtilidadesVivanto**

#### Ejemplo de uso

```cs
using UtilidadesVivanto;

try
{
    string keyEjemplo = "Key publica"; // Endpoint: api/crypts/keys/
    string valueEjemplo = "{Json serrializado ejemplo}";
    var result = EncryptVivanto.EncryptRSA(keyEjemplo, valueEjemplo);
} catch (Exception) {
    throw;
}
```

Ejemplo de data del parametro **valueEjemplo** (Debe ser en formato JSON serializado)

```sh
'{"role": "prueba", "municipio": "prueba", "departamento ": "prueba"}'
```

#### Generar llave (keyEjemplo)

```sh
GET api/crypts/keys/
--header 'X-CLIENT: 21bc4a10-951a-4a16-b9c8-bfc448f346d9'
```

#### Obtener Acceso Externo

```sh
POST /api/v1/external-access
--header 'X-KEY: x4zEU9yKqtmdBV1X9...'
--header 'X-IDENTIFY: YiTGMHpLb1...'
```
**X-KEY** Corresponde a la llave Generada en 'Generar llave (key)'
**X-IDENTIFY** Corresponde a la data encriptada en 'EncryptVivanto.EncryptRSA'

Respuesta
```json
{
    "estado": true,
    "url": "https://rusicst.mininterior.gov.co/#!/home/login",
    "token": "eyJhbGci..."
}
```

Ejemplo para loguear en Rusicst con el token obtenido

```sh
https://rusicst.mininterior.gov.co/#!/home/login?access_token=eyJhbGci...
```

#### Generar token JWT
Hay uno endpoint especifico y su accesso es autorizado por un token jwt

```sh
POST /api/v1/external-access
--header 'X-KEY: x4zEU9yKqtmdBV1X9...'
--header 'X-IDENTIFY: YiTGMHpLb1...'
```

Respuesta
```json
{
    "estado": true,
    "token": "eyJhbGci..."
}
```

#### Listado de usuarios activos

```sh
POST /api/v1/external-access
--header 'Authorization: Bearer eyJhbGci...'
```

Respuesta
```json
[
    {
        "role": "Enlace Municipal de Víctimas",
        "Nombres": "Adolfo  Raul Salcedo Ibarguen",
        "Email": "secconvivenciayparticipacioncomunitaria@guacari-valle.gov.co",
        "activo": true
    },
    {
        "role": "enlace municipal de victimas",
        "Nombres": "ADOLFO JAVIER ROJAS GOMEZ",
        "Email": "victimas@tuchin-cordoba.gov.co",
        "activo": true
    }
]
```

