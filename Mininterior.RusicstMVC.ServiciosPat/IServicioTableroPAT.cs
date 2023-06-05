using Mininterior.RusicstMVC.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace ServiciosPat
{
    // NOTA: puede usar el comando "Rename" del menú "Refactorizar" para cambiar el nombre de interfaz "IService1" en el código y en el archivo de configuración a la vez.
    [ServiceContract]
    public interface IServicioTableroPAT
    {

        #region Gestion Municipal

        [OperationContract]
        List<C_DerechosWebService_Result> ObtenerDerechos(int IdTablero);
        [OperationContract]
        List<C_PreguntasWebService_Result> ObtenerPreguntas(int IdTablero);
        [OperationContract]
        List<C_PreguntasReparacionColectivaWebService_Result> ObtenerPreguntasReparacionColectiva(int IdTablero);
        [OperationContract]
        List<C_PreguntasRetornosReubicacionesWebService_Result> ObtenerPreguntasRetornosReubicaciones(int IdTablero);
        [OperationContract]
        List<C_DatosMunicipalesDiligenciadosWebService_Result> ObtenerDatosMunicipalesDiligenciados(int IdTablero, int? IdDerecho, int DivipolaMunicipio);
        [OperationContract]
        List<C_DatosMunicipalesDiligenciadosRCWebService_Result> ObtenerDatosMunicipalesDiligenciadosReparacionColectiva(int IdTablero, int? IdDerecho, int DivipolaMunicipio);
        [OperationContract]
        List<C_DatosMunicipalesDiligenciadosRRWebService_Result> ObtenerDatosMunicipalesDiligenciadosRetornosReubicaciones(int IdTablero, int? IdDerecho, int DivipolaMunicipio);
        [OperationContract]
        List<C_AvanceMunicipioWebService_Result> ObtenerAvanceTablero(int IdTablero, int DivipolaMunicipio);
        [OperationContract]
        List<C_TablerosWebService_Result> ObtenerTableros();

        #endregion

        #region Gestion Departamental

        [OperationContract]
        List<C_DatosPreguntasDepartamentoDiligenciadasWebService_Result> ObtenerDatosPreguntasDepartamentoDiligenciadas(int IdTablero, int DivipolaDepartamento);
        [OperationContract]
        List<C_DatosConsolidadoMunicipiosGobernacionesWebService_Result> ObtenerConsolidadoMunicipiosGobernaciones(int IdTablero, int DivipolaDepartamento);
        [OperationContract]
        List<C_DatosDepartamentalesDiligenciadosRCWebService_Result> ObtenerDatosDepartamentalesDiligenciadosReparacionColectiva(int IdTablero, int DivipolaDepartamento);
        [OperationContract]
        List<C_DatosDepartamentalesDiligenciadosRRWebService_Result> ObtenerDatosDepartamentalesDiligenciadosRetornosReubicaciones(int IdTablero, int DivipolaDepartamento);
        #endregion

        #region Seguimiento Municipal

        [OperationContract]
        List<C_MapaPoliticaPublicaWebService_Result> ObtenerMedidasOtrosDerechos();

        [OperationContract]
        List<C_AvanceTableroSeguimientoMunicipioWebService_Result> ObtenerAvanceSeguimiento(int IdTablero, int DivipolaMunicipio);

        [OperationContract]
        List<C_DatosMunicipalesSeguimientoWebService_Result> ObtenerDatosSeguimientoMunicipal (int IdTablero, int? IdDerecho, int DivipolaMunicipio);

        [OperationContract]
        List<C_DatosMunicipalesSeguimientoRCWebService_Result> ObtenerDatosSeguimientoMunicipalReparacionColectiva(int IdTablero, int DivipolaMunicipio);

        [OperationContract]
        List<C_DatosMunicipalesSeguimientoRRWebService_Result> ObtenerDatosSeguimientoMunicipalRetornosReubicaciones(int IdTablero, int DivipolaMunicipio);

        [OperationContract]
        List<C_DatosMunicipalesSeguimientoODWebService_Result> ObtenerDatosSeguimientoMunicipalOtrosDerechos(int IdTablero, int? IdMedida, int DivipolaMunicipio);

        #endregion

        #region Seguimiento Departamental

        [OperationContract]
        List<C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService_Result> ObtenerDatosConsolidadoSeguimientoMunicipal(int IdTablero, int? IdDerecho, int DivipolaDepartamento);

        [OperationContract]
        List<C_DatosDepartamentalesSeguimientoWebService_Result> ObtenerDatosPreguntasDepartamentalesSeguimiento(int IdTablero, int DivipolaDepartamento);

        [OperationContract]
        List<C_DatosDepartamentalesSeguimientoRCWebService_Result> ObtenerDatosDepartamentalesSeguimientoReparacionColectiva(int IdTablero, int DivipolaDepartamento);

        [OperationContract]
        List<C_DatosDepartamentalesSeguimientoRRWebService_Result> ObtenerDatosDepartamentalesSeguimientoRetornosReubicaciones(int IdTablero, int DivipolaDepartamento);

        [OperationContract]
        List<C_DatosDepartamentalesSeguimientoODWebService_Result> ObtenerDatosDepartamentalesSeguimientoOtrosDerechos(int IdTablero, int? IdMedida, int DivipolaDepartamento);

        #endregion

        #region Programas Planeacion para SIGO
        [OperationContract]
        List<C_ProgramasPlaneacionWebService_Result> ObtenerProgramasPlaneacion(int IdTablero);
        #endregion

    }
}
