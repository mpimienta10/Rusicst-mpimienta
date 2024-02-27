// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-26-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 07-03-2017
// ***********************************************************************
// <copyright file="AuthRepository.cs" company="Ministerio del Interior">
//     Copyright ©  Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Servicios namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios
{
    using Mininterior.RusicstMVC.Aplicacion;
    using Entities;
    using Mininterior.RusicstMVC.Entidades;
    using Microsoft.AspNet.Identity;
    using Microsoft.AspNet.Identity.EntityFramework;
    using Mininterior.RusicstMVC.Servicios.Models;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Mininterior.RusicstMVC.Servicios.Entities.DTO;
    using Mininterior.RusicstMVC.Entities;
    using Utilidades;
    using System.Web.Http;

    /// <summary>
    /// Class AuthRepository.
    /// </summary>
    public class AuthRepository : IDisposable
    {
        /// <summary>
        /// The _CTX
        /// </summary>
        private AuthContext _ctx;

        /// <summary>
        /// The _user manager
        /// </summary>
        private UserManager<IdentityUser> _userManager;

        /// <summary>
        /// The _role manager
        /// </summary>
        private RoleManager<IdentityRole> _roleManager;

        /// <summary>
        /// Initializes a new instance of the <see cref="AuthRepository" /> class.
        /// </summary>
        public AuthRepository()
        {
            _ctx = new AuthContext();
            _userManager = new UserManager<IdentityUser>(new UserStore<IdentityUser>(_ctx));
            //Permitir caracteres especiales ( " ", _, ñ, á)
            _userManager.UserValidator = new UserValidator<IdentityUser>(_userManager) { AllowOnlyAlphanumericUserNames = false };
            _roleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(_ctx));
        }

        #region Métodos relacionados con la autenticación

        /// <summary>
        /// Registers the user.
        /// </summary>
        /// <param name="userModel">The user model.</param>
        /// <returns>Task IdentityResult.</returns>
        public async Task<IdentityResult> RegisterUser(LoginModel userModel)
        {
            IdentityResult result = new IdentityResult();
            bool nuevo = false;

            //// Valida si el usuario existe
            IdentityUser user = await _userManager.FindByNameAsync(userModel.UserName);

            C_Usuario_Result Usuario = new C_Usuario_Result();
            C_Usuario_Result ListaUsuario = new C_Usuario_Result();

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                //// Trae el usuario que esta registrandose
                Usuario = BD.C_Usuario(null, userModel.Token, null, null, null, null, null).FirstOrDefault();
            }

            //// Si existe, actualiza el usuario con los nuevos datos
            if (null != user)
            {
                //Validacion que la contraseña no haya sido utulizado en los ultimos 5 cambios o asignaciones
                if (await this.ConsultarContrasenaAnterior(user.Id, userModel.Password))
                    throw new Exception("Esta contraseña ya fue utilizada en los ultimos 5 registros, intente con otra");

                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Obtiene todos los que estan aprobados, los inactiva y les coloca el estado retirado
                    ListaUsuario = BD.C_Usuario(null, null, null, null, null, userModel.UserName, null).FirstOrDefault();
                    if (Usuario.IdTipoUsuario == 2 || Usuario.IdTipoUsuario == 7) // alcaldia y gobernacion
                        //BD.U_UsuarioUpdate(ListaUsuario.Id, null, null, null, null, (int)EstadoSolicitud.Retiro, Usuario.IdUsuarioTramite, null, ListaUsuario.Nombres, ListaUsuario.Cargo, ListaUsuario.TelefonoFijo, ListaUsuario.TelefonoFijoIndicativo, ListaUsuario.TelefonoFijoExtension, ListaUsuario.TelefonoCelular, ListaUsuario.Email, ListaUsuario.EmailAlternativo, false, false, null, false, ListaUsuario.DocumentoSolicitud, ListaUsuario.FechaSolicitud, Usuario.FechaNoRepudio, ListaUsuario.FechaTramite, DateTime.Now, null, null, null, Usuario.Id);
                        BD.U_UsuarioUpdate(ListaUsuario.Id, user.Id, null, null, null, (int)EstadoSolicitud.Aprobada, Usuario.IdUsuarioTramite != null ? Usuario.IdUsuarioTramite : null, user.UserName, Usuario.Nombres, Usuario.Cargo, Usuario.TelefonoFijo, Usuario.TelefonoFijoIndicativo, Usuario.TelefonoFijoExtension, Usuario.TelefonoCelular, Usuario.Email, Usuario.EmailAlternativo, true, true, null, true, Usuario.DocumentoSolicitud, Usuario.FechaSolicitud, Usuario.FechaNoRepudio, Usuario.FechaTramite, null, DateTime.Now, null, null, Usuario.Id);
                    else
                        BD.U_UsuarioUpdate(Usuario.Id, user.Id, null, null, null, (int)EstadoSolicitud.Aprobada, Usuario.IdUsuarioTramite != null ? Usuario.IdUsuarioTramite : null, user.UserName, Usuario.Nombres, Usuario.Cargo, Usuario.TelefonoFijo, Usuario.TelefonoFijoIndicativo, Usuario.TelefonoFijoExtension, Usuario.TelefonoCelular, Usuario.Email, Usuario.EmailAlternativo, true, true, null, true, Usuario.DocumentoSolicitud, Usuario.FechaSolicitud, Usuario.FechaNoRepudio, Usuario.FechaTramite, null, DateTime.Now, null, null, null);
                }

                user.Email = userModel.Email;
                user.PhoneNumber = userModel.Telefono;
                user.PasswordHash = _userManager.PasswordHasher.HashPassword(userModel.Password);
                user.EmailConfirmed = true;

                result = await _userManager.UpdateAsync(user);

            }
            else
            {
                //// Crea el nuevo usuario
                user = new IdentityUser { Email = userModel.Email, PhoneNumber = userModel.Telefono, UserName = userModel.UserName };
                result = await _userManager.CreateAsync(user, userModel.Password);
                nuevo = true;
            }

            if (result.Succeeded)
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Actualiza la información del usuario y lo deja aprobado y activo
                    //BD.U_UsuarioUpdate(Usuario.Id, user.Id, null, null, null, (int)EstadoSolicitud.Aprobada, Usuario.IdUsuarioTramite, user.UserName, Usuario.Nombres, Usuario.Cargo, Usuario.TelefonoFijo, Usuario.TelefonoFijoIndicativo, Usuario.TelefonoFijoExtension, Usuario.TelefonoCelular, Usuario.Email, Usuario.EmailAlternativo, true, true, null, true, Usuario.DocumentoSolicitud, Usuario.FechaSolicitud, Usuario.FechaNoRepudio, Usuario.FechaTramite, null, DateTime.Now, null, null, null);
                    if (Usuario.IdTipoUsuario == 2 || Usuario.IdTipoUsuario == 7) // alcaldia y gobernacion
                        BD.U_UsuarioUpdate(Usuario.Id, null, null, null, null, (int)EstadoSolicitud.Retiro, Usuario.IdUsuarioTramite, null, ListaUsuario.Nombres, ListaUsuario.Cargo, ListaUsuario.TelefonoFijo, ListaUsuario.TelefonoFijoIndicativo, ListaUsuario.TelefonoFijoExtension, ListaUsuario.TelefonoCelular, ListaUsuario.Email, ListaUsuario.EmailAlternativo, false, false, null, false, ListaUsuario.DocumentoSolicitud, ListaUsuario.FechaSolicitud, Usuario.FechaNoRepudio, ListaUsuario.FechaTramite, DateTime.Now, null, null, null, ListaUsuario.Id);
                    else if (nuevo)
                        BD.U_UsuarioUpdate(Usuario.Id, user.Id, null, null, null, (int)EstadoSolicitud.Aprobada, Usuario.IdUsuarioTramite, user.UserName, Usuario.Nombres, Usuario.Cargo, Usuario.TelefonoFijo, Usuario.TelefonoFijoIndicativo, Usuario.TelefonoFijoExtension, Usuario.TelefonoCelular, Usuario.Email, Usuario.EmailAlternativo, true, true, null, true, Usuario.DocumentoSolicitud, Usuario.FechaSolicitud, Usuario.FechaNoRepudio, Usuario.FechaTramite, null, DateTime.Now, null, null, null);
                }
            }
            await PasswordHistory(user.Id, userModel.Password);
            return result;
        }

        public async Task PasswordHistory(string userId, string pswrd)
        {
            using (EntitiesRusicst db = new EntitiesRusicst())
            {
                db.I_CreatePassword(Base64.Base64Encode(pswrd), userId);
            }
        }

        public async Task<bool> ConsultarContrasenaAnterior(string userId, string pswrd)
        {
            using (EntitiesRusicst db = new EntitiesRusicst())
            {
                var result = db.C_ConsultarContrasenaAnterior(Base64.Base64Encode(pswrd), userId);

                return result?.Count > 0;
            }
        }

        public async Task<bool> EsMayor90Dias(string userId)
        {
            var contrasenias = new List<Contrasena>();
            using (EntitiesRusicst db = new EntitiesRusicst())
            {
                contrasenias = db.C_ConsultarContrasenaAnterior(null, userId);
            }

            if (contrasenias is null && contrasenias.Count <= 1)
            {
                throw new Exception("Este usuario no tiene ninguna contraseña");
            }

            contrasenias = contrasenias.OrderByDescending(o => o.FechaCreacion).ToList();

            var hoy = DateTime.UtcNow.AddHours(-5);

            var fechaUltimaActualizacion = contrasenias.FirstOrDefault().FechaCreacion;

            TimeSpan Diff_dates = hoy.Subtract(fechaUltimaActualizacion);

            if (Diff_dates.Days >= 90)
                return true;

            return false;

        }

        /// <summary>
        /// Get all user actives
        /// </summary>
        /// <returns>List of users actives</returns>
        public async Task<List<ActiveUserVIvanto>> GetAllUserActives()
        {
            await Task.Delay(100);
            List<C_Usuario_Result> resultC_Usuarios = new List<C_Usuario_Result>();
            List<ActiveUserVIvanto> result = new List<ActiveUserVIvanto>();
            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                //// Trae el usuario que esta registrandose
                resultC_Usuarios = BD.C_Usuario(null, null, null, null, null, null, null).ToList();
            }
            resultC_Usuarios = resultC_Usuarios.Where(w => w.Activo).ToList();
            foreach (var item in resultC_Usuarios)
            {
                ActiveUserVIvanto user = new ActiveUserVIvanto
                {
                    activo = item.Activo,
                    Email = item.Email,
                    Nombres = item.Nombres,
                    role = item.Cargo
                };
                result.Add(user);
            }
            return result;
        }

        /// <summary>
        /// Finds the user.
        /// </summary>
        /// <param name="userName">Name of the user.</param>
        /// <param name="password">The password.</param>
        /// <returns>Task&lt;IdentityUser&gt;.</returns>
        public async Task<IdentityUser> FindUser(string userName, string password)
        {
            IdentityUser user = await _userManager.FindAsync(userName, password);
            return user;
        }

        /// <summary>
        /// Finds the name of the by.
        /// </summary>
        /// <param name="userName">Name of the user.</param>
        /// <returns>Task&lt;IdentityUser&gt;.</returns>
        public async Task<IdentityUser> FindByName(string userName)
        {
            IdentityUser user = await _userManager.FindByNameAsync(userName);

            return user;
        }

        /// <summary>
        /// find as an asynchronous operation.
        /// </summary>
        /// <param name="loginInfo">The login information.</param>
        /// <returns>Task&lt;IdentityUser&gt;.</returns>
        public async Task<IdentityUser> FindAsync(UserLoginInfo loginInfo)
        {
            IdentityUser user = await _userManager.FindAsync(loginInfo);

            return user;
        }

        /// <summary>
        /// create as an asynchronous operation.
        /// </summary>
        /// <param name="user">The user.</param>
        /// <returns>Task IdentityResult</returns>
        public async Task<IdentityResult> CreateAsync(IdentityUser user)
        {
            var result = await _userManager.CreateAsync(user);

            return result;
        }

        /// <summary>
        /// add login as an asynchronous operation.
        /// </summary>
        /// <param name="userId">The user identifier.</param>
        /// <param name="login">The login.</param>
        /// <returns>Task IdentityResult</returns>
        public async Task<IdentityResult> AddLoginAsync(string userId, UserLoginInfo login)
        {
            var result = await _userManager.AddLoginAsync(userId, login);

            return result;
        }

        /// <summary>
        /// Changes the password.
        /// </summary>
        /// <param name="userName">Name of the user.</param>
        /// <param name="password">The password.</param>
        /// <param name="newPassword">The new password.</param>
        /// <returns>Task IdentityResult</returns>
        public IdentityResult ChangePassword(string userName, string password, string newPassword)
        {
            IdentityResult result = new IdentityResult();
            IdentityUser user = new IdentityUser();

            if (string.IsNullOrEmpty(password))
            {
                user = _userManager.FindByName(userName);
            }
            else
            {
                user = _userManager.Find(userName, password);
            }

            if (null != user)
            {
                user.PasswordHash = _userManager.PasswordHasher.HashPassword(newPassword);
                if (this.ConsultarContrasenaAnterior(user.Id, newPassword).Result) {
                    throw new Exception("Esta contraseña fue utilizada en los ultimos 5 registros");
                }
                result = _userManager.Update(user);
            }

            if (result.Succeeded)
            {
                PasswordHistory(user.Id, newPassword).GetAwaiter().GetResult();
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Trae el usuario que esta realizando el cambio de contraseña
                    C_Usuario_Result Usuario = BD.C_Usuario(null, null, null, null, null, userName, null).FirstOrDefault();

                    //// Actualiza la información del usuario con los datos de la columna DatosActualizados en false con el objetivo que cambie la contraseña al ingresar
                    BD.U_UsuarioUpdate(Usuario.Id, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, null, null, null, null, null, null, null, null, null, null, Usuario.IdUsuarioHistorico);
                }
            }

            return result;
        }

        /// <summary>
        /// Recoveries the password.
        /// </summary>
        /// <param name="userName">Name of the user.</param>
        /// <param name="email">The email.</param>
        /// <param name="newPassword">The new password.</param>
        /// <returns>Task IdentityResult.</returns>
        public async Task<IdentityResult> RecoveryPassword(string userName, string email, string newPassword)
        {
            IdentityResult result = new IdentityResult();
            IdentityUser user = new IdentityUser();

            if (!string.IsNullOrEmpty(userName) && !string.IsNullOrEmpty(userName))
            {
                user = await _userManager.FindByNameAsync(userName);

                if (null != user && user.Email.ToLower() == email.ToLower())
                {
                    newPassword = newPassword.Replace("+", "=");
                    user.PasswordHash = _userManager.PasswordHasher.HashPassword(newPassword);
                    if (this.ConsultarContrasenaAnterior(user.Id, newPassword).Result)
                        throw new Exception("Esta contraseña ya fue utilizada en los ultimos 5 registros, intente con otra");
                    result = await _userManager.UpdateAsync(user);
                }
            }

            if (result.Succeeded)
            {
                await PasswordHistory(user.Id, newPassword);
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Trae el usuario que esta realizando el cambio de contraseña
                    C_Usuario_Result Usuario = BD.C_Usuario(null, null, null, null, null, userName, null).FirstOrDefault();

                    if (null != Usuario)
                    {
                        //// Actualiza la información del usuario con los datos de la columna DatosActualizados en false con el objetivo que cambie la contraseña al ingresar
                        BD.U_UsuarioUpdate(Usuario.Id, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, false, null, null, null, null, null, null, null, null, null, null, null);
                    }
                    else
                    {
                        result = new IdentityResult("Usuario inactivo");
                    }
                }
            }

            return result;
        }

        /// <summary>
        /// Changes the email.
        /// </summary>
        /// <param name="userName">Name of the user.</param>
        /// <param name="eMail">The e mail.</param>
        /// <returns>Task IdentityResult</returns>
        public IdentityResult ChangeEmail(string userName, string eMail)
        {
            IdentityResult result = new IdentityResult();

            IdentityUser user = _userManager.FindByName(userName);
            user.Email = eMail;
            user.EmailConfirmed = true;
            result = _userManager.Update(user);

            return result;
        }

        #endregion

        #region Métodos relacionados con la autorización

        /// <summary>
        /// Registra los roles del RUSICST
        /// </summary>
        /// <param name="model">representa la entidad TipoUsuariosModels</param>
        /// <returns>Task IdentityResult</returns>
        public async Task<IdentityResult> RegisterRole(RolModel model)
        {
            IdentityResult result = new IdentityResult();

            //// Crea el nuevo rol
            IdentityRole rol = new IdentityRole
            {
                Name = model.Nombre
            };

            result = await _roleManager.CreateAsync(rol);

            return result;
        }

        /// <summary>
        /// Obtiene todos los roles.
        /// </summary>
        /// <returns>List IdentityRole.</returns>
        public List<RolModel> GetAllRoles()
        {
            return _roleManager.Roles.Select(e => new RolModel { Id = e.Id, Nombre = e.Name }).ToList();
        }

        /// <summary>
        /// Elimina el rol.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns>Task IdentityResult.</returns>
        public async Task<IdentityResult> RemoveRol(string id)
        {
            try
            {
                IdentityRole rol = _roleManager.FindById(id);
                return await _roleManager.DeleteAsync(rol);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Modifica el nombre del rol.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>Tas IdentityResult.</returns>
        public async Task<IdentityResult> ModifyRole(RolModel model)
        {
            IdentityRole rol = _roleManager.FindById(model.Id);
            rol.Name = model.Nombre;
            return await _roleManager.UpdateAsync(rol);
        }

        /// <summary>
        /// Registra cada uno de los usuarios en la tabla de AspNetUserRoles
        /// </summary>
        /// <param name="idRol">Identificador del rol.</param>
        /// <param name="idsUsuarios">cadena de caracteres con los ids de los usuarios.</param>
        /// <param name="incluir">Determina si se incluyen o se excluyen del rol</param>
        /// <returns>Task IHttpActionResult.</returns>
        public async Task<IdentityResult> RegisterUsersRole(string idRol, string idsUsuarios, bool incluir)
        {
            string[] str = idsUsuarios.Split(',');
            IdentityRole rol = _roleManager.FindById(idRol);

            if (incluir)
            {
                str.ToList().ForEach(e => rol.Users.Add(new IdentityUserRole { RoleId = rol.Id, UserId = e }));
            }
            else
            {
                str.ToList().ForEach(e => rol.Users.Remove(rol.Users.Where(user => user.RoleId == idRol && user.UserId == e).First()));
            }

            try
            {
                return await _roleManager.UpdateAsync(rol);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Finds the user.
        /// </summary>
        /// <param name="roleName">Name de el rol.</param>
        /// <returns>Task IdentityRole </returns>
        public async Task<IdentityRole> FindRole(string roleName)
        {
            IdentityRole role = await _roleManager.FindByNameAsync(roleName);
            return role;
        }

        #endregion

        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose()
        {
            _ctx.Dispose();
            _userManager.Dispose();
            _roleManager.Dispose();
        }
    }
}