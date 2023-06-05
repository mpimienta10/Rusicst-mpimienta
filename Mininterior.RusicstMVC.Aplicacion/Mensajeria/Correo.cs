// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Aplicacion
// Author           : Equipo de desarrollo OIM - Christian Ospina
// Created          : 02-25-2017
//
// Last Modified By : Equipo de desarrollo OIM - Christian Ospina
// Last Modified On : 03-18-2017
// ***********************************************************************
// <copyright file="Correo.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary>Clase que maneja el envío de correo electrónico</summary>
// ***********************************************************************
/// <summary>
/// Mensajeria namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Aplicacion.Mensajeria
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Mail;

    /// <summary>
    /// Clase estática Correo.
    /// </summary>
    public static class Correo
    {
        /// <summary>
        /// Enviar el correo electrónico.
        /// </summary>
        /// <param name="paras">Arreglo con las cuentas paras.</param>
        /// <param name="copias">Arreglo con las cuentas copias.</param>
        /// <param name="ocultos">Arreglo con las cuentas ocultos.</param>
        /// <param name="adjuntos">Arreglo con los adjuntos.</param>
        /// <param name="asunto">asunto del correo.</param>
        /// <param name="mensajeHtml">mensaje HTML.</param>
        /// <param name="correoUsuario">correo remitente.</param>
        /// <param name="correoClave">clave remitente.</param>
        /// <param name="host">Envia el SMTP.</param>
        /// <param name="puerto">puerto utilizado.</param>
        /// <returns><c>true</c> si el correo es enviado, <c>false</c> si ocurrio alguna excepción.</returns>
        public static string EnviarXSmtp(string[] paras, string[] copias, string[] ocultos, AdjuntoCorreo[] adjuntos, string asunto, string mensajeHtml, string correoUsuario, string correoClave, string host, int puerto)
        {
            int vacios=0;
            using (MailMessage mail = new MailMessage())
            {
                mail.From = new MailAddress(correoUsuario);

                if (null != paras) paras.Where(e => null != e).ToList().ForEach(e => mail.To.Add(e));
                if (null != copias) copias.Where(e => null != e).ToList().ForEach(e => mail.CC.Add(e));
                if (null != ocultos) ocultos.Where(e => null != e).ToList().ForEach(e => mail.Bcc.Add(e));

                if (paras == null || paras.Count() == 0)
                    vacios++;
                if (copias == null || copias.Count() == 0)
                    vacios++;
                if (ocultos == null || ocultos.Count() == 0)
                    vacios++;
                if (vacios ==3) return "El correo no tiene destinatarios";

                mail.Subject = asunto;
                mail.Body = mensajeHtml;
                mail.IsBodyHtml = true;

                if (null != adjuntos)
                {
                    adjuntos.ToList().ForEach(delegate (AdjuntoCorreo e)
                    {
                        System.Net.Mail.Attachment att = new System.Net.Mail.Attachment(new MemoryStream(e.Contenido), e.Nombre);
                        mail.Attachments.Add(att);
                    });
                }

                using (SmtpClient smtp = new SmtpClient(host, puerto))
                {
                    smtp.Credentials = new NetworkCredential(correoUsuario, correoClave);
                    smtp.EnableSsl = true;

                    try
                    {
                        smtp.Send(mail);
                        return string.Empty;
                    }
                    catch (SmtpFailedRecipientsException e)
                    {
                        return e.Message;
                    }
                    catch (SmtpException e)
                    {
                        return e.Message;
                    }
                    catch (WebException e)
                    {
                        return e.Message;
                    }
                    catch (Exception e)
                    {
                        return e.Message;
                    }
                }
            }
        }

        /// <summary>
        /// Obtiene el asunto del correo.
        /// </summary>
        /// <param name="estado">The estado.</param>
        /// <returns>System.String.</returns>
        public static string ObtenerAsunto(EstadoSolicitud estado)
        {
            string Retorno = string.Empty;

            switch (estado)
            {
                case EstadoSolicitud.Solicitada:
                    Retorno = MensajesCorreo.AsuntoSolicitudUsuarioConfirmacion;
                    break;
                case EstadoSolicitud.Confirmada:
                    Retorno = string.Empty;
                    break;
                case EstadoSolicitud.MinConfirmada:
                    Retorno = MensajesCorreo.AsuntoSolicitudUsuarioAceptacion;
                    break;
                case EstadoSolicitud.Rechazada:
                    Retorno = MensajesCorreo.AsuntoRechazoSolicitud;
                    break;
                case EstadoSolicitud.Aprobada:
                    Retorno = MensajesCorreo.AsuntoCreacionUsuario;
                    break;
                case EstadoSolicitud.RecuperarContraseña:
                    Retorno = MensajesCorreo.AsuntoRecuperarClave;
                    break;
                default:
                    break;
            }

            return Retorno;
        }
    }

    /// <summary>
    /// Class AdjuntoCorreo.
    /// </summary>
    public class AdjuntoCorreo
    {
        /// <summary>
        /// Gets or sets el nombre del adjunto.
        /// </summary>
        /// <value>The nombre.</value>
        public string Nombre
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets el contenido del adjunto.
        /// </summary>
        /// <value>The contenido.</value>
        public byte[] Contenido
        {
            get;
            set;
        }
    }
}

