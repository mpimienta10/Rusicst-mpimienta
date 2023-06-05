--=======================================================================================
-- Elimina los procedimientos que no tienen incidencia en esta primera versión
--=======================================================================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_EncuestaConsultar]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_EncuestaConsultar]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_GetLogHistoryConversationsByUser]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_GetLogHistoryConversationsByUser]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_GetLogHistoryConversationsByUser_Detail]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_GetLogHistoryConversationsByUser_Detail]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_GetLogHistoryConversationsByUser_Detail_Admin]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_GetLogHistoryConversationsByUser_Detail_Admin]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[c_GetPendingMessages]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[c_GetPendingMessages]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[c_getPendingMessagesConversations]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[c_getPendingMessagesConversations]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[c_SearchBI]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[c_SearchBI]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EliminarSeccion]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[EliminarSeccion]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EliminarContenidoSeccion]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[EliminarContenidoSeccion]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObtenerListadoPreguntasSeccionEncuesta]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[ObtenerListadoPreguntasSeccionEncuesta]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObtenerSeccionesEncuesta]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[ObtenerSeccionesEncuesta]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[reporte_ejecutivo2]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[reporte_ejecutivo2]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[reporte_ejecutivo2_modificado]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[reporte_ejecutivo2_modificado]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[reporte_ejecutivo2_original]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[reporte_ejecutivo2_original]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[reporte_ejecutivo3_dev]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[reporte_ejecutivo3_dev]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rusicst_complecion]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[rusicst_complecion]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rusicst_conteo_usuarios]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[rusicst_conteo_usuarios]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObtenerListadoPreguntasSeccionEncuesta]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[ObtenerListadoPreguntasSeccionEncuesta]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObtenerSeccionesEncuesta]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[ObtenerSeccionesEncuesta]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[u_UpdateConversationUser]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[u_UpdateConversationUser]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[u_UpdatePendingMessage]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[u_UpdatePendingMessage]
END