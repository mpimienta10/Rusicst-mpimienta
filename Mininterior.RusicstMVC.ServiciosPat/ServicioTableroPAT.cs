using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using Mininterior.RusicstMVC.Entidades;

namespace ServiciosPat
{
    // NOTA: puede usar el comando "Rename" del menú "Refactorizar" para cambiar el nombre de clase "Service1" en el código y en el archivo de configuración a la vez.
    public class ServicioTableroPAT : IServicioTableroPAT
    {
        #region Gestion Municipal

        public List<C_DerechosWebService_Result> ObtenerDerechos(int IdTablero)
        {
            try
            {
                List<C_DerechosWebService_Result> result = new List<C_DerechosWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DerechosWebService(IdTablero).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_PreguntasWebService_Result> ObtenerPreguntas(int IdTablero)
        {
            BasicHttpBinding binding = new BasicHttpBinding();
            binding.MaxReceivedMessageSize = 10000000;
            try
            {
                List<C_PreguntasWebService_Result> result = new List<C_PreguntasWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_PreguntasWebService(IdTablero).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_PreguntasReparacionColectivaWebService_Result> ObtenerPreguntasReparacionColectiva(int IdTablero)
        {
            try
            {
                List<C_PreguntasReparacionColectivaWebService_Result> result = new List<C_PreguntasReparacionColectivaWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_PreguntasReparacionColectivaWebService(IdTablero).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_PreguntasRetornosReubicacionesWebService_Result> ObtenerPreguntasRetornosReubicaciones(int IdTablero)
        {
            try
            {
                List<C_PreguntasRetornosReubicacionesWebService_Result> result = new List<C_PreguntasRetornosReubicacionesWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_PreguntasRetornosReubicacionesWebService(IdTablero).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<C_DatosMunicipalesDiligenciadosWebService_Result> ObtenerDatosMunicipalesDiligenciados(int IdTablero, int? IdDerecho, int DivipolaMunicipio)
        {
            try
            {
                List<C_DatosMunicipalesDiligenciadosWebService_Result> result = new List<C_DatosMunicipalesDiligenciadosWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosMunicipalesDiligenciadosWebService(IdTablero, IdDerecho, DivipolaMunicipio).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_DatosMunicipalesDiligenciadosRCWebService_Result> ObtenerDatosMunicipalesDiligenciadosReparacionColectiva(int IdTablero, int? IdDerecho, int DivipolaMunicipio)
        {
            try
            {
                List<C_DatosMunicipalesDiligenciadosRCWebService_Result> result = new List<C_DatosMunicipalesDiligenciadosRCWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosMunicipalesDiligenciadosRCWebService(IdTablero, IdDerecho, DivipolaMunicipio).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_DatosMunicipalesDiligenciadosRRWebService_Result> ObtenerDatosMunicipalesDiligenciadosRetornosReubicaciones(int IdTablero, int? IdDerecho, int DivipolaMunicipio)
        {
            try
            {
                List<C_DatosMunicipalesDiligenciadosRRWebService_Result> result = new List<C_DatosMunicipalesDiligenciadosRRWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosMunicipalesDiligenciadosRRWebService(IdTablero, IdDerecho, DivipolaMunicipio).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_AvanceMunicipioWebService_Result> ObtenerAvanceTablero(int IdTablero, int DivipolaMunicipio)
        {
            try
            {
                List<C_AvanceMunicipioWebService_Result> result = new List<C_AvanceMunicipioWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_AvanceMunicipioWebService(IdTablero, DivipolaMunicipio).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_TablerosWebService_Result> ObtenerTableros()
        {
            try
            {
                List<C_TablerosWebService_Result> result = new List<C_TablerosWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_TablerosWebService().ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        #region Gestion Departamental

        public List<C_DatosPreguntasDepartamentoDiligenciadasWebService_Result> ObtenerDatosPreguntasDepartamentoDiligenciadas(int IdTablero, int DivipolaDepartamento)
        {
            try
            {
                List<C_DatosPreguntasDepartamentoDiligenciadasWebService_Result> result = new List<C_DatosPreguntasDepartamentoDiligenciadasWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosPreguntasDepartamentoDiligenciadasWebService(IdTablero, DivipolaDepartamento).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_DatosConsolidadoMunicipiosGobernacionesWebService_Result> ObtenerConsolidadoMunicipiosGobernaciones(int IdTablero, int DivipolaDepartamento)
        {
            try
            {
                List<C_DatosConsolidadoMunicipiosGobernacionesWebService_Result> result = new List<C_DatosConsolidadoMunicipiosGobernacionesWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosConsolidadoMunicipiosGobernacionesWebService(IdTablero, DivipolaDepartamento).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_DatosDepartamentalesDiligenciadosRCWebService_Result> ObtenerDatosDepartamentalesDiligenciadosReparacionColectiva(int IdTablero, int DivipolaDepartamento)
        {
            try
            {
                List<C_DatosDepartamentalesDiligenciadosRCWebService_Result> result = new List<C_DatosDepartamentalesDiligenciadosRCWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosDepartamentalesDiligenciadosRCWebService(IdTablero, DivipolaDepartamento).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_DatosDepartamentalesDiligenciadosRRWebService_Result> ObtenerDatosDepartamentalesDiligenciadosRetornosReubicaciones(int IdTablero, int DivipolaDepartamento)
        {
            try
            {
                List<C_DatosDepartamentalesDiligenciadosRRWebService_Result> result = new List<C_DatosDepartamentalesDiligenciadosRRWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosDepartamentalesDiligenciadosRRWebService(IdTablero, DivipolaDepartamento).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        #region Seguimiento Municipal

        public List<C_MapaPoliticaPublicaWebService_Result> ObtenerMedidasOtrosDerechos()
        {
            try
            {
                List<C_MapaPoliticaPublicaWebService_Result> result = new List<C_MapaPoliticaPublicaWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_MapaPoliticaPublicaWebService().ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_AvanceTableroSeguimientoMunicipioWebService_Result> ObtenerAvanceSeguimiento(int IdTablero, int DivipolaMunicipio)
        {
            try
            {
                List<C_AvanceTableroSeguimientoMunicipioWebService_Result> result = new List<C_AvanceTableroSeguimientoMunicipioWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_AvanceTableroSeguimientoMunicipioWebService(DivipolaMunicipio, IdTablero).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_DatosMunicipalesSeguimientoWebService_Result> ObtenerDatosSeguimientoMunicipal(int IdTablero, int? IdDerecho, int DivipolaMunicipio)
        {
            try
            {
                List<C_DatosMunicipalesSeguimientoWebService_Result> result = new List<C_DatosMunicipalesSeguimientoWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosMunicipalesSeguimientoWebService(IdTablero, IdDerecho, DivipolaMunicipio).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_DatosMunicipalesSeguimientoRCWebService_Result> ObtenerDatosSeguimientoMunicipalReparacionColectiva(int IdTablero, int DivipolaMunicipio)
        {
            try
            {
                List<C_DatosMunicipalesSeguimientoRCWebService_Result> result = new List<C_DatosMunicipalesSeguimientoRCWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosMunicipalesSeguimientoRCWebService(IdTablero, DivipolaMunicipio).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_DatosMunicipalesSeguimientoRRWebService_Result> ObtenerDatosSeguimientoMunicipalRetornosReubicaciones(int IdTablero, int DivipolaMunicipio)
        {
            try
            {
                List<C_DatosMunicipalesSeguimientoRRWebService_Result> result = new List<C_DatosMunicipalesSeguimientoRRWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosMunicipalesSeguimientoRRWebService(IdTablero, DivipolaMunicipio).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_DatosMunicipalesSeguimientoODWebService_Result> ObtenerDatosSeguimientoMunicipalOtrosDerechos(int IdTablero, int? IdMedida, int DivipolaMunicipio)
        {
            try
            {
                List<C_DatosMunicipalesSeguimientoODWebService_Result> result = new List<C_DatosMunicipalesSeguimientoODWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosMunicipalesSeguimientoODWebService(IdTablero, IdMedida, DivipolaMunicipio).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        #region Seguimiento Departamental

        public List<C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService_Result> ObtenerDatosConsolidadoSeguimientoMunicipal(int IdTablero, int? IdDerecho, int DivipolaDepartamento)
        {
            try
            {
                List<C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService_Result> result = new List<C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService(IdTablero, IdDerecho, DivipolaDepartamento).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_DatosDepartamentalesSeguimientoWebService_Result> ObtenerDatosPreguntasDepartamentalesSeguimiento(int IdTablero, int DivipolaDepartamento)
        {
            try
            {
                List<C_DatosDepartamentalesSeguimientoWebService_Result> result = new List<C_DatosDepartamentalesSeguimientoWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosDepartamentalesSeguimientoWebService(IdTablero, DivipolaDepartamento).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_DatosDepartamentalesSeguimientoRCWebService_Result> ObtenerDatosDepartamentalesSeguimientoReparacionColectiva(int IdTablero, int DivipolaDepartamento)
        {
            try
            {
                List<C_DatosDepartamentalesSeguimientoRCWebService_Result> result = new List<C_DatosDepartamentalesSeguimientoRCWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosDepartamentalesSeguimientoRCWebService(IdTablero, DivipolaDepartamento).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_DatosDepartamentalesSeguimientoRRWebService_Result> ObtenerDatosDepartamentalesSeguimientoRetornosReubicaciones(int IdTablero, int DivipolaDepartamento)
        {
            try
            {
                List<C_DatosDepartamentalesSeguimientoRRWebService_Result> result = new List<C_DatosDepartamentalesSeguimientoRRWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosDepartamentalesSeguimientoRRWebService(IdTablero, DivipolaDepartamento).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<C_DatosDepartamentalesSeguimientoODWebService_Result> ObtenerDatosDepartamentalesSeguimientoOtrosDerechos(int IdTablero, int? IdMedida, int DivipolaDepartamento)
        {
            try
            {
                List<C_DatosDepartamentalesSeguimientoODWebService_Result> result = new List<C_DatosDepartamentalesSeguimientoODWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_DatosDepartamentalesSeguimientoODWebService(IdTablero, IdMedida, DivipolaDepartamento).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        #region Prgramas Planeacion para SIGO

        public List<C_ProgramasPlaneacionWebService_Result> ObtenerProgramasPlaneacion(int IdTablero)
        {
            try
            {
                List<C_ProgramasPlaneacionWebService_Result> result = new List<C_ProgramasPlaneacionWebService_Result>();
                using (var db = new EntitiesRusicst())
                {
                    result = db.C_ProgramasPlaneacionWebService(IdTablero).ToList();
                }
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        
        #endregion
    }
}
