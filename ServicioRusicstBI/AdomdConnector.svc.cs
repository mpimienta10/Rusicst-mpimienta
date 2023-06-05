using System;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using Microsoft.AnalysisServices.AdomdClient;
using System.ComponentModel;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.Xml.Serialization;
using Newtonsoft.Json;
using System.Data;
using System.Data.SqlClient;

using Dimension = CustomDataProvider.Web.Framework.AdomdDimension;

namespace CustomDataProvider.Web
{
    using System.Data;
    using System.Text.RegularExpressions;

    using Measure = CustomDataProvider.Web.Framework.AdomdMeasure;
    using Member = CustomDataProvider.Web.Framework.AdomdMember;
    using CustomDataProvider.Web.Framework;
    using System.Web.Script.Services;
    using CustomDataProvider.Web.Models;

    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class AdomdConnector : IAdomdConnector
    {
        private String connectionStringBI;
        private String connectionStringENGINE;

        public AdomdConnector()
        {
            connectionStringBI = System.Configuration.ConfigurationManager.ConnectionStrings["OLAP_BI_RUSICST"].ConnectionString;
            connectionStringENGINE = System.Configuration.ConfigurationManager.ConnectionStrings["ENGINE_RUSICST"].ConnectionString;
        }

        public string LoadSchema()
        {
            AdomdConnection conn = new AdomdConnection(connectionStringBI);

            conn.Open();

            return conn.Database;
        }

        public ObservableCollection<AdomdCube> LoadCubes()
        {
            AdomdConnection conn = new AdomdConnection(connectionStringBI);

            conn.Open();

            ObservableCollection<AdomdCube> cubeDefsCollection = new ObservableCollection<AdomdCube>();
            foreach (CubeDef cube in conn.Cubes)
            {
                if (cube.Type == CubeType.Cube)
                {
                    cubeDefsCollection.Add(
                        new AdomdCube
                        {
                            CubeName = cube.Name,
                            Caption = cube.Caption,
                            Description = cube.Description,
                            LastDataUpdate = cube.LastUpdated,
                            CubeType = cube.Type.ToString()
                        });
                }
            }

            return cubeDefsCollection;
        }

        public string LoadDimensions(string cubeName)
        {
            AdomdConnection conn = new AdomdConnection(connectionStringBI);

            conn.Open();

            CubeDef cubeDef = conn.Cubes[cubeName];

            if (cubeDef == null)
            {
                return null;
            }

            ObservableCollection<Dimension> dimensions =
                new ObservableCollection<Dimension>();

            foreach (Microsoft.AnalysisServices.AdomdClient.Dimension dimensionData in cubeDef.Dimensions)
            {
                if (dimensionData.DimensionType == DimensionTypeEnum.Measure)
                {
                    continue;
                }

                Dimension currentDimension =
                    new Dimension()
                    {
                        Name = dimensionData.Name,
                        UniqueName = dimensionData.UniqueName,
                        Caption = dimensionData.Caption,
                        Description = dimensionData.Description,
                        DimensionType = dimensionData.DimensionType.ToString()
                    };

                foreach (Hierarchy hierarchyData in dimensionData.Hierarchies)
                {
                    AdomdHierarchy currentHierarchy =
                        new AdomdHierarchy()
                        {
                            Name = hierarchyData.Name,
                            UniqueName = hierarchyData.UniqueName,
                            Caption = hierarchyData.Caption,
                            Description = hierarchyData.Description,
                            DefaultMember = hierarchyData.DefaultMember,
                            DimensionUniqueName = currentDimension.UniqueName
                        };

                    foreach (Level level in hierarchyData.Levels)
                    {
                        AdomdLevel currentLevel =
                        new AdomdLevel()
                        {
                            Name = level.Name,
                            Caption = level.Caption,
                            UniqueName = level.UniqueName,
                            Description = level.Description,
                            Number = (uint)level.LevelNumber,
                            HierarchyUniqueName = currentHierarchy.Name
                        };

                        currentHierarchy.Levels.Add(currentLevel);
                    }

                    currentDimension.Hierarchies.Add(currentHierarchy);
                }

                dimensions.Add(currentDimension);
            }
            String jsonTabla = JsonConvert.SerializeObject(dimensions, Formatting.Indented);
            return jsonTabla;
        }

        //public ObservableCollection<Measure> LoadMeasures(string cubeName)
        //{
        //    Microsoft.AnalysisServices.AdomdClient.AdomdConnection conn =
        //        new Microsoft.AnalysisServices.AdomdClient.AdomdConnection(connectionStringBI);

        //    conn.Open();

        //    CubeDef cubeDef = conn.Cubes[cubeName];

        //    if (cubeDef == null)
        //    {
        //        return null;
        //    }

        //    ObservableCollection<Measure> measures = new ObservableCollection<Measure>();

        //    AdomdMeasure currentMeasure;

        //    foreach (Microsoft.AnalysisServices.AdomdClient.Measure measure in cubeDef.Measures)
        //    {
        //        if (measure.Expression == string.Empty)
        //        {
        //            string measureGroupName = measure.Properties["MEASUREGROUP_NAME"].Value.ToString();
        //            string aggregator = measure.Properties["MEASURE_AGGREGATOR"].Value.ToString();

        //            currentMeasure = new Measure
        //            {
        //                Name = measure.Name,
        //                UniqueName = measure.UniqueName,
        //                Caption = measure.Caption,
        //                Description = measure.Description,
        //                MeasureGroupName = measureGroupName,
        //                Aggregator = aggregator
        //            };
        //        }
        //        else
        //        {
        //            string measureGroupName = measure.Properties[0].Value.ToString();
        //            string aggregator = null;

        //            currentMeasure = new Measure
        //            {
        //                Name = measure.Name,
        //                UniqueName = measure.UniqueName,
        //                Caption = measure.Caption,
        //                Description = measure.Description,
        //                MeasureGroupName = measureGroupName,
        //                Aggregator = aggregator
        //            };
        //        };

        //        measures.Add(currentMeasure);
        //    }

        //    return measures;
        //}

        public List<string> LoadMeasureGroups(string cubeName)
        {
            Microsoft.AnalysisServices.AdomdClient.AdomdConnection conn =
                new Microsoft.AnalysisServices.AdomdClient.AdomdConnection(connectionStringBI);

            conn.Open();

            CubeDef cubeDef = conn.Cubes[cubeName];

            if (cubeDef == null)
            {
                return null;
            }

            List<string> measureGroupsNames = new List<string>();
            foreach (Microsoft.AnalysisServices.AdomdClient.Measure measure in cubeDef.Measures)
            {
                if (measure.Expression == string.Empty)
                {
                    string measureGroupName = measure.Properties["MEASUREGROUP_NAME"].Value.ToString();
                    if (!measureGroupsNames.Contains(measureGroupName))
                    {
                        measureGroupsNames.Add(measureGroupName);
                    }
                }
                else
                {
                    string measureGroupName = measure.Properties[0].Value.ToString();
                    if (!measureGroupsNames.Contains(measureGroupName))
                    {
                        measureGroupsNames.Add(measureGroupName);
                    }
                }
            }

            return measureGroupsNames;
        }


        public Dictionary<string, List<string>> LoadMeasureGroupDimensions(string cubeName, string catalogName)
        {
            Microsoft.AnalysisServices.AdomdClient.AdomdConnection conn =
                 new Microsoft.AnalysisServices.AdomdClient.AdomdConnection(connectionStringBI);

            conn.Open();

            AdomdRestrictionCollection restrictions = new AdomdRestrictionCollection();
            restrictions.Add("CATALOG_NAME", catalogName);
            restrictions.Add("CUBE_NAME", cubeName);

            DataSet result = conn.GetSchemaDataSet("MDSCHEMA_MEASUREGROUP_DIMENSIONS", restrictions);
            Dictionary<string, List<string>> groupDimensions = new Dictionary<string, List<string>>();

            foreach (DataRow row in result.Tables[0].Rows)
            {
                string groupName = (string)row["MEASUREGROUP_NAME"];
                string dimensionUniqueName = (string)row["DIMENSION_UNIQUE_NAME"];

                List<string> dimensions = null;
                if (groupDimensions.TryGetValue(groupName, out dimensions))
                {
                    dimensions.Add(dimensionUniqueName);
                }
                else
                {
                    groupDimensions.Add(groupName, new List<string> { dimensionUniqueName });
                }
            }

            return groupDimensions;
        }

        //public ObservableCollection<Member> LoadLevelMembers(string cubeName, string levelUniqueName)
        //{
        //    Microsoft.AnalysisServices.AdomdClient.AdomdConnection conn =
        //        new Microsoft.AnalysisServices.AdomdClient.AdomdConnection(connectionStringBI);
        //    conn.Open();

        //    CubeDef cubeDef = conn.Cubes[cubeName];

        //    if (cubeDef == null)
        //    {
        //        return null;
        //    }

        //    MatchCollection matches = Regex.Matches(levelUniqueName, @"(\[.+?\])");
        //    if (matches.Count != 3)
        //    {
        //        throw new ArgumentException("Level unique name does not follow the expected format [Dimension].[Hierarchy].[Level]", "levelUniqueName");
        //    }

        //    string dimensionName = matches[0].Value.Replace("[", "").Replace("]", "");
        //    Microsoft.AnalysisServices.AdomdClient.Dimension dimension = cubeDef.Dimensions[dimensionName];

        //    if (dimension == null)
        //    {
        //        return null;
        //    }

        //    string hierarchyName = matches[1].Value.Replace("[", "").Replace("]", "");
        //    Microsoft.AnalysisServices.AdomdClient.Hierarchy hierarchy = dimension.Hierarchies[hierarchyName];

        //    if (hierarchy == null)
        //    {
        //        return null;
        //    }

        //    string levelName = matches[2].Value.Replace("[", "").Replace("]", "");
        //    Microsoft.AnalysisServices.AdomdClient.Level adomdLevel = hierarchy.Levels[levelName];

        //    if (adomdLevel == null)
        //    {
        //        return null;
        //    }

        //    MemberCollection levelMembers = adomdLevel.GetMembers();
        //    ObservableCollection<AdomdMember> members = new ObservableCollection<Member>();

        //    foreach (Microsoft.AnalysisServices.AdomdClient.Member memberData in levelMembers)
        //    {
        //        string parentName = memberData.Parent == null ? string.Empty : memberData.Parent.Name;

        //        AdomdMember member =
        //            new AdomdMember()
        //            {
        //                Name = memberData.Name,
        //                UniqueName = memberData.UniqueName,
        //                Caption = memberData.Caption,
        //                ParentUniqueName = parentName,
        //                LevelUniqueName = memberData.LevelName,
        //                LevelNumber = (uint)memberData.LevelDepth,
        //                ChildrenCardinality = (int)memberData.ChildCount
        //            };

        //        members.Add(member);
        //    }

        //    return members;
        //}

     
        public ObservableCollection<Member> LoadFilterMemberMembers(string cubeName, string parentMemberUniqueName, int levelNumber)
        {

            Microsoft.AnalysisServices.AdomdClient.AdomdConnection conn =
                new Microsoft.AnalysisServices.AdomdClient.AdomdConnection(connectionStringBI);
            conn.Open();

            CubeDef cubeDef = conn.Cubes[cubeName];

            if (cubeDef == null)
            {
                return null;
            }

            MatchCollection matches = Regex.Matches(parentMemberUniqueName, @"(\[.+?\])");
            if (matches.Count < 2)
            {
                throw new ArgumentException("Level unique name does not follow the expected format [Dimension].[Hierarchy].[Member]", "hierarchyUniqueName");
            }

            string dimensionName = matches[0].Value.Replace("[", "").Replace("]", "");
            Microsoft.AnalysisServices.AdomdClient.Dimension dimension = cubeDef.Dimensions[dimensionName];

            if (dimension == null)
            {
                return null;
            }

            string hierarchyName = matches[1].Value.Replace("[", "").Replace("]", "");
            Microsoft.AnalysisServices.AdomdClient.Hierarchy hierarchy = dimension.Hierarchies[hierarchyName];

            if (hierarchy == null)
            {
                return null;
            }

            Microsoft.AnalysisServices.AdomdClient.Level adomdLevel = hierarchy.Levels[levelNumber];

            if (adomdLevel == null)
            {
                return null;
            }

            MemberCollection levelMembers = adomdLevel.GetMembers();
            ObservableCollection<AdomdMember> members = new ObservableCollection<Member>();

            foreach (Microsoft.AnalysisServices.AdomdClient.Member memberData in levelMembers)
            {
                if (memberData.Parent.UniqueName != parentMemberUniqueName)
                {
                    continue;
                }

                string parentName = memberData.Parent == null ? string.Empty : memberData.Parent.Name;

                AdomdMember member =
                    new AdomdMember()
                    {
                        Name = memberData.Name,
                        UniqueName = memberData.UniqueName,
                        Caption = memberData.Caption,
                        ParentUniqueName = parentName,
                        LevelUniqueName = memberData.LevelName,
                        LevelNumber = (uint)memberData.LevelDepth,
                        ChildrenCardinality = (int)memberData.ChildCount
                    };

                members.Add(member);
            }

            return members;
        }


        public GridData ExecuteCommand(string query)
        {
            AdomdConnection conn = new AdomdConnection(connectionStringBI);

            conn.Open();

            AdomdCommand command = new AdomdCommand(query, conn);
            command.CommandTimeout = 0;

            CellSet cellSet = command.ExecuteCellSet();

            GridData gridData = new GridData { Axes = new List<AxisData>() };
            foreach (Axis axis in cellSet.Axes)
            {
                AxisData axisData = new AxisData { Positions = new List<PositionData>() };

                foreach (Position position in axis.Positions)
                {
                    PositionData positionData = new PositionData
                    {
                        Ordinal = position.Ordinal,
                        Members = new List<MemberData>()
                    };

                    foreach (Microsoft.AnalysisServices.AdomdClient.Member member in position.Members)
                    {
                        MemberData memberData = new MemberData
                        {
                            Caption = member.Caption,
                            ChildCount = (int)member.ChildCount,
                            LevelDepth = member.LevelDepth,
                            LevelName = member.LevelName,
                            Name = member.Name,
                            ParentUniqueName = member.Parent == null ? string.Empty : member.Parent.UniqueName,
                            UniqueName = member.UniqueName,
                            DrilledDown = member.DrilledDown,
                            ParentSameAsPrevious = member.ParentSameAsPrevious
                        };

                        positionData.Members.Add(memberData);
                    }

                    axisData.Positions.Add(positionData);
                }

                gridData.Axes.Add(axisData);
            }

            gridData.Cells = new List<CellData>();

            foreach (Microsoft.AnalysisServices.AdomdClient.Cell cell in cellSet.Cells)
            {
                CellData cellData = new CellData
                {
                    FormattedValue = cell.FormattedValue,
                    Value = cell.Value
                };

                gridData.Cells.Add(cellData);
            }

            return gridData;
        }

        public string ExecuteCommandDataTableJSON(string query)
        {
            try
            {
                AdomdConnection conn = new AdomdConnection(connectionStringBI);

                conn.Open();

                AdomdCommand command = new AdomdCommand(query, conn);
                command.CommandTimeout = 0;

                AdomdDataAdapter ada = new AdomdDataAdapter(command);

                DataSet ds = new DataSet();

                ada.Fill(ds);

                DataTable dt = ds.Tables[0];

                System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
                Dictionary<string, object> row;
                foreach (DataRow dr in dt.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
                return serializer.Serialize(rows);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public DataTable ExecuteCommandDataTable(string query)
        {
            try
            {
                AdomdConnection conn = new AdomdConnection(connectionStringBI);

                conn.Open();

                AdomdCommand command = new AdomdCommand(query, conn);
                command.CommandTimeout = 0;

                AdomdDataAdapter ada = new AdomdDataAdapter(command);

                DataSet ds = new DataSet();

                ada.Fill(ds);

                DataTable dt = ds.Tables[0];

                return dt;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public string ConsultasPersonalizadasRusicstJSON(string model)
        {
            ConsultasPersonalizadasModels consulta = JsonConvert.DeserializeObject<ConsultasPersonalizadasModels>(model);
            DataTable dtConsultaPersonalizada;

            Datos dat = new Datos();

            try
            {
                String filas = String.Empty;
                String columnas = String.Empty;
                String sentencia = String.Empty;
                Int32 numeroFilas = 0;
                Int32 numeroColumnas = 0;

                #region opciones

                if (consulta.moneda == true)
                {
                    if (consulta.monedaFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " , ";

                        filas = filas + "[Measures].[Valor Moneda]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " , ";

                        columnas = columnas + "[Measures].[Valor Moneda]";
                    }
                }

                if (consulta.numero == true)
                {
                    if (consulta.numeroFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " , ";

                        filas = filas + "[Measures].[Valor Numero]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " , ";

                        columnas = columnas + "[Measures].[Valor Numero]";
                    }
                }

                if (consulta.porcentaje == true)
                {
                    if (consulta.porcentajeFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " , ";

                        filas = filas + "[Measures].[Valor Porcentaje]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " , ";

                        columnas = columnas + "[Measures].[Valor Porcentaje]";
                    }
                }

                if (consulta.respuestaUnica == true)
                {
                    if (consulta.respuestaUnicaFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " , ";

                        filas = filas + "[Measures].[Valor Unica]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " , ";

                        columnas = columnas + "[Measures].[Valor Unica]";
                    }
                }

                if (filas != String.Empty)
                {
                    filas = "{ " + filas + "}";
                }

                if (columnas != String.Empty)
                {
                    columnas = "{ " + columnas + "}";
                }

                if (consulta.codigoEncuesta == true)
                {
                    if (consulta.codigoEncuestaFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Encuestas].[Codigo Encuesta].[Codigo Encuesta]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Encuestas].[Codigo Encuesta].[Codigo Encuesta]";
                    }
                }

                if (consulta.nombreEncuesta == true)
                {
                    if (consulta.nombreEncuestaFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Encuestas].[Nombre Encuesta].[Nombre Encuesta]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Encuestas].[Nombre Encuesta].[Nombre Encuesta]";
                    }
                }

                if (consulta.codigoPregunta == true)
                {
                    if (consulta.codigoPreguntaFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Preguntas].[Codigo Pregunta].[Codigo Pregunta]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Preguntas].[Codigo Pregunta].[Codigo Pregunta]";
                    }
                }

                if (consulta.nombrePregunta == true)
                {
                    if (consulta.nombrePreguntaFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Preguntas].[Nombre Pregunta].[Nombre Pregunta]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Preguntas].[Nombre Pregunta].[Nombre Pregunta]";
                    }
                }

                if (consulta.codigoDepartamento == true)
                {
                    if (consulta.codigoDepartamentoFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Municipio].[Codigo Departamento].[Codigo Departamento]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Municipio].[Codigo Departamento].[Codigo Departamento]";
                    }
                }

                if (consulta.nombreDepartamento == true)
                {
                    if (consulta.nombreDepartamentoFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Municipio].[Nombre Departamento].[Nombre Departamento]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Municipio].[Nombre Departamento].[Nombre Departamento]";
                    }
                }

                if (consulta.codigoMunicipio == true)
                {
                    if (consulta.codigoMunicipioFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Municipio].[Codigo Municipio].[Codigo Municipio]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Municipio].[Codigo Municipio].[Codigo Municipio]";
                    }
                }

                if (consulta.nombreMunicipio == true)
                {
                    if (consulta.nombreMunicipioFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Municipio].[Nombre Municipio].[Nombre Municipio]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Municipio].[Nombre Municipio].[Nombre Municipio]";
                    }
                }

                if (consulta.etapaPolitica == true)
                {
                    if (consulta.etapaPoliticaFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Etapa Politica].[Nombre Etapa Politica].[Nombre Etapa Politica]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Etapa Politica].[Nombre Etapa Politica].[Nombre Etapa Politica]";
                    }
                }

                if (consulta.seccion == true)
                {
                    if (consulta.seccionFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Seccion].[Nombre Seccion].[Nombre Seccion]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Seccion].[Nombre Seccion].[Nombre Seccion]";
                    }
                }

                if (consulta.tema == true)
                {
                    if (consulta.temaFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Tema].[Nombre Tema].[Nombre Tema]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Tema].[Nombre Tema].[Nombre Tema]";
                    }
                }

                if (consulta.hechoVictimizante == true)
                {
                    if (consulta.hechoVictimizanteFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Hechos Victimizantes].[Nombre Hechos Victimizantes].[Nombre Hechos Victimizantes]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Hechos Victimizantes].[Nombre Hechos Victimizantes].[Nombre Hechos Victimizantes]";
                    }
                }

                if (consulta.dinamicaDesplazamiento == true)
                {
                    if (consulta.dinamicaDesplazamientoFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Dinamica Desplazamiento].[Nombre Dinamica Desplazamiento].[Nombre Dinamica Desplazamiento]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Dinamica Desplazamiento].[Nombre Dinamica Desplazamiento].[Nombre Dinamica Desplazamiento]";
                    }
                }

                if (consulta.enfoqueDiferencial == true)
                {
                    if (consulta.enfoqueDiferencialFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Enfoque Diferencial].[Nombre Enfoque Diferencial].[Nombre Enfoque Diferencial]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Enfoque Diferencial].[Nombre Enfoque Diferencial].[Nombre Enfoque Diferencial]";
                    }
                }

                if (consulta.factoresRiesgo == true)
                {
                    if (consulta.factoresRiesgoFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Factores Riesgo].[Nombre Factores Riesgo].[Nombre Factores Riesgo]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Factores Riesgo].[Nombre Factores Riesgo].[Nombre Factores Riesgo]";
                    }
                }

                if (consulta.rangoEtareo == true)
                {
                    if (consulta.rangoEtareoFila == true)
                    {
                        if (filas != String.Empty) filas = filas + " * ";

                        filas = filas + "[Rango Etareo].[Nombre Rango Etareo].[Nombre Rango Etareo]";
                    }
                    else
                    {
                        if (columnas != String.Empty) columnas = columnas + " * ";

                        columnas = columnas + "[Rango Etareo].[Nombre Rango Etareo].[Nombre Rango Etareo]";
                    }
                }

                #endregion

                sentencia = "SELECT NON EMPTY { ";
                sentencia = sentencia + columnas + " } DIMENSION PROPERTIES MEMBER_CAPTION ON COLUMNS, NON EMPTY { ( ";
                sentencia = sentencia + filas + " ) } DIMENSION PROPERTIES MEMBER_CAPTION ON ROWS ";

                int numeroParentesis = 1;

                if (consulta.filtroEncuesta != String.Empty && consulta.filtroEncuesta != "-1")
                {
                    sentencia = sentencia + "FROM ( SELECT ( { [Encuestas].[Codigo Encuesta].&[" + consulta.filtroEncuesta + @"] } ) ON COLUMNS ";
                    ++numeroParentesis;
                }

                if (consulta.filtroDepartamento != String.Empty && consulta.filtroDepartamento != "-1")
                {
                    sentencia = sentencia + "FROM ( SELECT ( { [Municipio].[Codigo Departamento].&[" + consulta.filtroDepartamento + @"] } ) ON COLUMNS ";
                    ++numeroParentesis;
                }

                if (consulta.filtroMunicipio != String.Empty && consulta.filtroMunicipio != "-1")
                {
                    sentencia = sentencia + "FROM ( SELECT ( { [Municipio].[Codigo Municipio].&[" + consulta.filtroMunicipio + @"] } ) ON COLUMNS ";
                    ++numeroParentesis;
                }

                if (consulta.filtroPreguntas != String.Empty)
                {
                    String[] codigoPreguntas = consulta.filtroPreguntas.Split(',');
                    String preguntas = String.Empty;

                    sentencia = sentencia + @"FROM ( SELECT ( { ";
                    foreach (String codigo in codigoPreguntas)
                    {
                        if (preguntas != String.Empty)
                        {
                            preguntas = preguntas + ",";
                        }
                        preguntas = preguntas + @"[Preguntas].[Codigo Pregunta].&[" + codigo + @"]";
                    }
                    sentencia = sentencia + preguntas + @" } ) ON COLUMNS ";

                    ++numeroParentesis;
                }

                sentencia = sentencia + " FROM [DWH RUSICST] ";

                for (int i = 1; i < numeroParentesis; ++i)
                {
                    sentencia = sentencia + ")";
                }

                dtConsultaPersonalizada = ExecuteCommandDataTable(sentencia);

                numeroFilas = dtConsultaPersonalizada.Rows.Count;
                numeroColumnas = dtConsultaPersonalizada.Columns.Count;
                int columnasRejilla = 0;

                if (numeroFilas > 0)
                {
                    DataTable tb = new DataTable("ConsultasPersonalizadas");

                    for (Int32 columna = 0; columna < numeroColumnas; ++columna)
                    {
                        switch (dtConsultaPersonalizada.Columns[columna].ColumnName)
                        {
                            case "[Encuestas].[Codigo Encuesta].[Codigo Encuesta].[MEMBER_CAPTION]":
                                tb.Columns.Add("CodigoEncuesta", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Encuestas].[Nombre Encuesta].[Nombre Encuesta].[MEMBER_CAPTION]":
                                tb.Columns.Add("NombreEncuesta", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Preguntas].[Codigo Pregunta].[Codigo Pregunta].[MEMBER_CAPTION]":
                                tb.Columns.Add("CodigoPregunta", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Preguntas].[Nombre Pregunta].[Nombre Pregunta].[MEMBER_CAPTION]":
                                tb.Columns.Add("NombrePregunta", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Municipio].[Codigo Departamento].[Codigo Departamento].[MEMBER_CAPTION]":
                                tb.Columns.Add("CodigoDepartamento", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Municipio].[Nombre Departamento].[Nombre Departamento].[MEMBER_CAPTION]":
                                tb.Columns.Add("NombreDepartamento", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Municipio].[Codigo Municipio].[Codigo Municipio].[MEMBER_CAPTION]":
                                tb.Columns.Add("CodigoMunicipio", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Municipio].[Nombre Municipio].[Nombre Municipio].[MEMBER_CAPTION]":
                                tb.Columns.Add("NombreMunicipio", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Etapa Politica].[Nombre Etapa Politica].[Nombre Etapa Politica].[MEMBER_CAPTION]":
                                tb.Columns.Add("EtapaPolitica", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Seccion].[Nombre Seccion].[Nombre Seccion].[MEMBER_CAPTION]":
                                tb.Columns.Add("Seccion", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Tema].[Nombre Tema].[Nombre Tema].[MEMBER_CAPTION]":
                                tb.Columns.Add("Tema", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Hechos Victimizantes].[Nombre Hechos Victimizantes].[Nombre Hechos Victimizantes].[MEMBER_CAPTION]":
                                tb.Columns.Add("HechoVictimizante", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Dinamica Desplazamiento].[Nombre Dinamica Desplazamiento].[Nombre Dinamica Desplazamiento].[MEMBER_CAPTION]":
                                tb.Columns.Add("DinamicaDesplazamiento", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Enfoque Diferencial].[Nombre Enfoque Diferencial].[Nombre Enfoque Diferencial].[MEMBER_CAPTION]":
                                tb.Columns.Add("EnfoqueDiferencial", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Factores Riesgo].[Nombre Factores Riesgo].[Nombre Factores Riesgo].[MEMBER_CAPTION]":
                                tb.Columns.Add("FactoresRiesgo", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Rango Etareo].[Nombre Rango Etareo].[Nombre Rango Etareo].[MEMBER_CAPTION]":
                                tb.Columns.Add("RangoEtareo", typeof(string));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Measures].[Valor Moneda]":
                                tb.Columns.Add("ValorMoneda", typeof(double));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Measures].[Valor Numero]":
                                tb.Columns.Add("ValorNumero", typeof(double));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Measures].[Valor Porcentaje]":
                                tb.Columns.Add("ValorPorcentaje", typeof(double));
                                columnasRejilla = columna + 1;
                                break;
                            case "[Measures].[Valor Unica]":
                                tb.Columns.Add("ValorRespuestaUnica", typeof(double));
                                columnasRejilla = columna + 1;
                                break;
                        }
                    }

                    for (Int32 columna = columnasRejilla; columna < numeroColumnas; ++columna)
                    {
                        String nombreColumna = dtConsultaPersonalizada.Columns[columna].ColumnName;

                        nombreColumna = nombreColumna.Replace(@"].[", @"],[");
                        nombreColumna = nombreColumna.Replace(@"].&[", @"],&[");
                        nombreColumna = nombreColumna.Replace(@"[Encuestas],[Codigo Encuesta],&", @" Código Encuesta : ");
                        nombreColumna = nombreColumna.Replace(@"[Encuestas],[Nombre Encuesta],&", @" Nombre Encuesta : ");
                        nombreColumna = nombreColumna.Replace(@"[Preguntas],[Codigo Pregunta],&", @" Código Pregunta : ");
                        nombreColumna = nombreColumna.Replace(@"[Preguntas],[Nombre Pregunta],&", @" Nombre Encuesta : ");
                        nombreColumna = nombreColumna.Replace(@"[Municipio],[Codigo Departamento],&", @" Código Departamento : ");
                        nombreColumna = nombreColumna.Replace(@"[Municipio],[Nombre Departamento],&", @" Nombre Departamento : ");
                        nombreColumna = nombreColumna.Replace(@"[Municipio],[Codigo Municipio],&", @" Código Municipio : ");
                        nombreColumna = nombreColumna.Replace(@"[Municipio],[Nombre Municipio],&", @" Nombre Municipio : ");
                        nombreColumna = nombreColumna.Replace(@"[Etapa Politica],[Nombre Etapa Politica],&", @" Etapa Política : ");
                        nombreColumna = nombreColumna.Replace(@"[Seccion],[Nombre Seccion],&", @"´Sección : ");
                        nombreColumna = nombreColumna.Replace(@"[Tema],[Nombre Tema],&", @" Tema : ");
                        nombreColumna = nombreColumna.Replace(@"[Hechos Victimizantes],[Nombre Hechos Victimizantes],&", @" Hechos Victimizantes : ");
                        nombreColumna = nombreColumna.Replace(@"[Dinamica Desplazamiento],[Nombre Dinamica Desplazamiento],&", @" Dinámica del Desplazamiento : ");
                        nombreColumna = nombreColumna.Replace(@"[Enfoque Diferencial],[Nombre Enfoque Diferencial],&", @" Enfoque Diferencial : ");
                        nombreColumna = nombreColumna.Replace(@"[Factores Riesgo],[Nombre Factores Riesgo],&", @" Factores de Riesgo : ");
                        nombreColumna = nombreColumna.Replace(@"[Rango Etareo],[Nombre Rango Etareo],&", @" Rango Etareo : ");
                        nombreColumna = nombreColumna.Replace(@"[Measures],[Valor Moneda],", @" ");
                        nombreColumna = nombreColumna.Replace(@"[Measures],[Valor Numero],", @" ");
                        nombreColumna = nombreColumna.Replace(@"[Measures],[Valor Porcentaje],", @" ");
                        nombreColumna = nombreColumna.Replace(@"[Measures],[Valor Unica],", @" ");
                        nombreColumna = nombreColumna.Trim();

                        tb.Columns.Add(nombreColumna, typeof(double));
                    }

                    foreach (DataRow drConsultaPersonalizada in dtConsultaPersonalizada.Rows)
                    {
                        DataRow tr = tb.NewRow();

                        for (Int32 columna = 0; columna < numeroColumnas; ++columna)
                        {
                            tr[columna] = drConsultaPersonalizada[columna];
                        }

                        tb.Rows.Add(tr);
                    }

                    foreach (DataRow drFormatear in tb.Rows)
                    {
                        for (int columna = 0; columna < tb.Columns.Count; ++columna)
                        {
                            if (tb.Columns[columna].DataType.Name.ToString() == "Double")
                            {
                                double temporal = 0;

                                if (double.TryParse(drFormatear[columna].ToString(), out temporal) && drFormatear[columna].ToString() != "Infinito" && drFormatear[columna].ToString() != "Infinity")
                                {
                                    drFormatear[columna] = Convert.ToDouble(String.Format("{0:0.00}", (double)drFormatear[columna]));
                                }
                                else
                                {
                                    drFormatear[columna] = Convert.ToDouble(String.Format("{0:0.00}", 0));
                                }
                            }
                        }

                    }

                    String jsonTabla = JsonConvert.SerializeObject(tb, Newtonsoft.Json.Formatting.Indented);
                    return jsonTabla;

                    //return tb;
                }
            }
            catch (Exception exc)
            {
                if (exc.Message.ToString() != "No se puede encontrar la tabla 0." && exc.Message.ToString() != "Cannot find table 0.")
                    return exc.Message.ToString();
                else
                    return "No se encontró información con los parámetros utilizados, por favor cambie los parametros y realice una nueva busqueda.";
            }

            return null;
        }

        public String ConsultaDepartamentosRusicstJSON(string hecho, string filtroEncuesta, string filtroPreguntas)
        {
            DataTable dtConsultaPersonalizada;

            Datos dat = new Datos();

            try
            {
                String filas = String.Empty;
                String columnas = String.Empty;
                String sentencia = String.Empty;

                switch (hecho)
                {
                    case "Moneda":
                        columnas = "[Measures].[Valor Moneda]";
                        break;
                    case "Número":
                        columnas = "[Measures].[Valor Numero]";
                        break;
                    case "Porcentaje":
                        columnas = "[Measures].[Valor Porcentaje]";
                        break;
                    case "Respuesta Unica":
                        columnas = "[Measures].[Valor Unica]";
                        break;
                }

                if (filas != String.Empty) filas = filas + " * ";

                filas = filas + "[Municipio].[Nombre Departamento].[Nombre Departamento]";

                sentencia = "SELECT NON EMPTY { ";
                sentencia = sentencia + columnas + " } DIMENSION PROPERTIES MEMBER_CAPTION ON COLUMNS, NON EMPTY { ( ";
                sentencia = sentencia + filas + " ) } DIMENSION PROPERTIES MEMBER_CAPTION ON ROWS ";

                int numeroParentesis = 1;

                if (filtroEncuesta != String.Empty && filtroEncuesta != "-1")
                {
                    sentencia = sentencia + "FROM ( SELECT ( { [Encuestas].[Codigo Encuesta].&[" + filtroEncuesta + @"] } ) ON COLUMNS ";
                    ++numeroParentesis;
                }

                if (filtroPreguntas != String.Empty)
                {
                    String[] codigoPreguntas = filtroPreguntas.Split(',');
                    String preguntas = String.Empty;

                    sentencia = sentencia + @"FROM ( SELECT ( { ";
                    foreach (String codigo in codigoPreguntas)
                    {
                        if (preguntas != String.Empty)
                        {
                            preguntas = preguntas + ",";
                        }
                        preguntas = preguntas + @"[Preguntas].[Codigo Pregunta].&[" + codigo + @"]";
                    }
                    sentencia = sentencia + preguntas + @" } ) ON COLUMNS ";

                    ++numeroParentesis;
                }

                sentencia = sentencia + " FROM [DWH RUSICST] ";

                for (int i = 1; i < numeroParentesis; ++i)
                {
                    sentencia = sentencia + ")";
                }

                dtConsultaPersonalizada = ExecuteCommandDataTable(sentencia);

                DataTable tb = new DataTable("RusictsDepartamento");

                tb.Columns.Add("Departamento", typeof(string));
                tb.Columns.Add("Valor", typeof(double));

                foreach (DataRow drConsultaPersonalizada in dtConsultaPersonalizada.Rows)
                {
                    DataRow tr = tb.NewRow();

                    tr[0] = drConsultaPersonalizada[0].ToString();
                    tr[1] = (drConsultaPersonalizada[1].ToString() == String.Empty ? 0 : drConsultaPersonalizada[1]);

                    tb.Rows.Add(tr);
                }

                foreach (DataRow drFormatear in tb.Rows)
                {
                    drFormatear[1] = Convert.ToDouble(String.Format("{0:0.00}", (double)drFormatear[1]));
                }

                String jsonTabla = JsonConvert.SerializeObject(tb, Newtonsoft.Json.Formatting.Indented);

                return jsonTabla;
            }
            catch (Exception exc)
            {
                if (exc.Message.ToString() != "No se puede encontrar la tabla 0." && exc.Message.ToString() != "Cannot find table 0.")
                {
                    return exc.Message.ToString();
                }
                else
                {
                    return "No se encontró información con los parámetros utilizados, por favor cambie los parametros y realice una nueva busqueda.";
                }
            }

        }

        public String ConsultaDepartamentosEncuestasRusicstJSON(string hecho, string filtroEncuesta, string filtroPreguntas)
        {
            DataTable dtConsultaPersonalizada;

            Datos dat = new Datos();

            try
            {
                String filas = String.Empty;
                String columnas = String.Empty;
                String sentencia = String.Empty;

                switch (hecho)
                {
                    case "Moneda":
                        columnas = "[Measures].[Valor Moneda]";
                        break;
                    case "Número":
                        columnas = "[Measures].[Valor Numero]";
                        break;
                    case "Porcentaje":
                        columnas = "[Measures].[Valor Porcentaje]";
                        break;
                    case "Respuesta Unica":
                        columnas = "[Measures].[Valor Unica]";
                        break;
                }

                if (filas != String.Empty) filas = filas + " * ";

                filas = filas + "[Municipio].[Nombre Departamento].[Nombre Departamento]";

                if (filas != String.Empty) filas = filas + " * ";

                filas = filas + "[Encuestas].[Nombre Encuesta].[Nombre Encuesta]";

                sentencia = "SELECT NON EMPTY { ";
                sentencia = sentencia + columnas + " } DIMENSION PROPERTIES MEMBER_CAPTION ON COLUMNS, NON EMPTY { ( ";
                sentencia = sentencia + filas + " ) } DIMENSION PROPERTIES MEMBER_CAPTION ON ROWS ";

                int numeroParentesis = 1;

                if (filtroEncuesta != String.Empty && filtroEncuesta != "-1")
                {
                    sentencia = sentencia + "FROM ( SELECT ( { [Encuestas].[Codigo Encuesta].&[" + filtroEncuesta + @"] } ) ON COLUMNS ";
                    ++numeroParentesis;
                }

                if (filtroPreguntas != String.Empty)
                {
                    String[] codigoPreguntas = filtroPreguntas.Split(',');
                    String preguntas = String.Empty;

                    sentencia = sentencia + @"FROM ( SELECT ( { ";
                    foreach (String codigo in codigoPreguntas)
                    {
                        if (preguntas != String.Empty)
                        {
                            preguntas = preguntas + ",";
                        }
                        preguntas = preguntas + @"[Preguntas].[Codigo Pregunta].&[" + codigo + @"]";
                    }
                    sentencia = sentencia + preguntas + @" } ) ON COLUMNS ";

                    ++numeroParentesis;
                }

                sentencia = sentencia + " FROM [DWH RUSICST] ";

                for (int i = 1; i < numeroParentesis; ++i)
                {
                    sentencia = sentencia + ")";
                }

                dtConsultaPersonalizada = ExecuteCommandDataTable(sentencia);

                DataTable tb = new DataTable("RusictsDepartamento");

                tb.Columns.Add("Departamento", typeof(string));
                tb.Columns.Add("Encuesta", typeof(string));
                tb.Columns.Add("Valor", typeof(double));

                foreach (DataRow drConsultaPersonalizada in dtConsultaPersonalizada.Rows)
                {
                    DataRow tr = tb.NewRow();

                    tr[0] = drConsultaPersonalizada[0].ToString();
                    tr[1] = drConsultaPersonalizada[1].ToString();
                    tr[2] = (drConsultaPersonalizada[2].ToString() == String.Empty ? 0 : drConsultaPersonalizada[2]);

                    tb.Rows.Add(tr);
                }

                foreach (DataRow drFormatear in tb.Rows)
                {
                    drFormatear[2] = Convert.ToDouble(String.Format("{0:0.00}", (double)drFormatear[2]));
                }

                String jsonTabla = JsonConvert.SerializeObject(tb, Newtonsoft.Json.Formatting.Indented);

                return jsonTabla;
            }
            catch (Exception exc)
            {
                if (exc.Message.ToString() != "No se puede encontrar la tabla 0." && exc.Message.ToString() != "Cannot find table 0.")
                {
                    return exc.Message.ToString();
                }
                else
                {
                    return "No se encontró información con los parámetros utilizados, por favor cambie los parametros y realice una nueva busqueda.";
                }

            }

        }

        public String ConsultaMunicipioRusicstJSON(string departamento, string hecho, string filtroEncuesta, string filtroPreguntas)
        {

            DataTable dtConsultaPersonalizada;

            Datos dat = new Datos();

            try
            {
                String filas = String.Empty;
                String columnas = String.Empty;
                String sentencia = String.Empty;

                switch (hecho)
                {
                    case "Moneda":
                        columnas = "[Measures].[Valor Moneda]";
                        break;
                    case "Número":
                        columnas = "[Measures].[Valor Numero]";
                        break;
                    case "Porcentaje":
                        columnas = "[Measures].[Valor Porcentaje]";
                        break;
                    case "Respuesta Unica":
                        columnas = "[Measures].[Valor Unica]";
                        break;
                }

                if (filas != String.Empty) filas = filas + " * ";

                filas = filas + "[Municipio].[Codigo Municipio].[Codigo Municipio]";

                if (filas != String.Empty) filas = filas + " * ";

                filas = filas + "[Municipio].[Nombre Municipio].[Nombre Municipio]";


                sentencia = "SELECT NON EMPTY { ";
                sentencia = sentencia + columnas + " } DIMENSION PROPERTIES MEMBER_CAPTION ON COLUMNS, NON EMPTY { ( ";
                sentencia = sentencia + filas + " ) } DIMENSION PROPERTIES MEMBER_CAPTION ON ROWS ";

                int numeroParentesis = 1;

                if (filtroEncuesta != String.Empty && filtroEncuesta != "-1")
                {
                    sentencia = sentencia + "FROM ( SELECT ( { [Encuestas].[Codigo Encuesta].&[" + filtroEncuesta + @"] } ) ON COLUMNS ";
                    ++numeroParentesis;
                }

                if (departamento != String.Empty && departamento != "-1")
                {
                    sentencia = sentencia + "FROM ( SELECT ( { [Municipio].[Nombre Departamento].&[" + departamento + @"] } ) ON COLUMNS ";
                    ++numeroParentesis;
                }

                if (filtroPreguntas != String.Empty)
                {
                    String[] codigoPreguntas = filtroPreguntas.Split(',');
                    String preguntas = String.Empty;

                    sentencia = sentencia + @"FROM ( SELECT ( { ";
                    foreach (String codigo in codigoPreguntas)
                    {
                        if (preguntas != String.Empty)
                        {
                            preguntas = preguntas + ",";
                        }
                        preguntas = preguntas + @"[Preguntas].[Codigo Pregunta].&[" + codigo + @"]";
                    }
                    sentencia = sentencia + preguntas + @" } ) ON COLUMNS ";

                    ++numeroParentesis;
                }

                sentencia = sentencia + " FROM [DWH RUSICST] ";

                for (int i = 1; i < numeroParentesis; ++i)
                {
                    sentencia = sentencia + ")";
                }

                dtConsultaPersonalizada = ExecuteCommandDataTable(sentencia);

                DataTable tb = new DataTable("RusictsMunicipio");

                tb.Columns.Add("CodigoMunicipio", typeof(string));
                tb.Columns.Add("NombreMunicipio", typeof(string));
                tb.Columns.Add("Valor", typeof(double));
                tb.Columns.Add("Id", typeof(string));

                foreach (DataRow drConsultaPersonalizada in dtConsultaPersonalizada.Rows)
                {
                    DataRow tr = tb.NewRow();

                    tr[0] = drConsultaPersonalizada[0].ToString();
                    tr[1] = drConsultaPersonalizada[1].ToString();
                    tr[2] = (drConsultaPersonalizada[2].ToString() == String.Empty ? 0 : drConsultaPersonalizada[2]);
                    tr[3] = drConsultaPersonalizada[0].ToString();

                    tb.Rows.Add(tr);
                }

                foreach (DataRow drFormatear in tb.Rows)
                {
                    drFormatear[2] = Convert.ToDouble(String.Format("{0:0.00}", (double)drFormatear[2]));
                }

                String jsonTabla = JsonConvert.SerializeObject(tb, Newtonsoft.Json.Formatting.Indented);

                return jsonTabla;
            }
            catch (Exception exc)
            {
                if (exc.Message.ToString() != "No se puede encontrar la tabla 0." && exc.Message.ToString() != "Cannot find table 0.")
                {
                    return exc.Message.ToString();
                }
                else
                {
                    return "No se encontró información con los parámetros utilizados, por favor cambie los parametros y realice una nueva busqueda.";
                }
            }

        }

        public String ConsultaMunicipioEncuestaRusicstJSON(string departamento, string hecho, string filtroEncuesta, string filtroPreguntas)
        {

            DataTable dtConsultaPersonalizada;

            Datos dat = new Datos();

            try
            {
                String filas = String.Empty;
                String columnas = String.Empty;
                String sentencia = String.Empty;

                switch (hecho)
                {
                    case "Moneda":
                        columnas = "[Measures].[Valor Moneda]";
                        break;
                    case "Número":
                        columnas = "[Measures].[Valor Numero]";
                        break;
                    case "Porcentaje":
                        columnas = "[Measures].[Valor Porcentaje]";
                        break;
                    case "Respuesta Unica":
                        columnas = "[Measures].[Valor Unica]";
                        break;
                }

                if (filas != String.Empty) filas = filas + " * ";

                filas = filas + "[Municipio].[Codigo Municipio].[Codigo Municipio]";

                if (filas != String.Empty) filas = filas + " * ";

                filas = filas + "[Municipio].[Nombre Municipio].[Nombre Municipio]";

                if (filas != String.Empty) filas = filas + " * ";

                filas = filas + "[Encuestas].[Nombre Encuesta].[Nombre Encuesta]";

                sentencia = "SELECT NON EMPTY { ";
                sentencia = sentencia + columnas + " } DIMENSION PROPERTIES MEMBER_CAPTION ON COLUMNS, NON EMPTY { ( ";
                sentencia = sentencia + filas + " ) } DIMENSION PROPERTIES MEMBER_CAPTION ON ROWS ";

                int numeroParentesis = 1;

                if (filtroEncuesta != String.Empty && filtroEncuesta != "-1")
                {
                    sentencia = sentencia + "FROM ( SELECT ( { [Encuestas].[Codigo Encuesta].&[" + filtroEncuesta + @"] } ) ON COLUMNS ";
                    ++numeroParentesis;
                }

                if (departamento != String.Empty && departamento != "-1")
                {
                    sentencia = sentencia + "FROM ( SELECT ( { [Municipio].[Nombre Departamento].&[" + departamento + @"] } ) ON COLUMNS ";
                    ++numeroParentesis;
                }

                if (filtroPreguntas != String.Empty)
                {
                    String[] codigoPreguntas = filtroPreguntas.Split(',');
                    String preguntas = String.Empty;

                    sentencia = sentencia + @"FROM ( SELECT ( { ";
                    foreach (String codigo in codigoPreguntas)
                    {
                        if (preguntas != String.Empty)
                        {
                            preguntas = preguntas + ",";
                        }
                        preguntas = preguntas + @"[Preguntas].[Codigo Pregunta].&[" + codigo + @"]";
                    }
                    sentencia = sentencia + preguntas + @" } ) ON COLUMNS ";

                    ++numeroParentesis;
                }

                sentencia = sentencia + " FROM [DWH RUSICST] ";

                for (int i = 1; i < numeroParentesis; ++i)
                {
                    sentencia = sentencia + ")";
                }

                dtConsultaPersonalizada = ExecuteCommandDataTable(sentencia);

                DataTable tb = new DataTable("RusictsMunicipio");

                tb.Columns.Add("CodigoMunicipio", typeof(string));
                tb.Columns.Add("NombreMunicipio", typeof(string));
                tb.Columns.Add("Encuesta", typeof(string));
                tb.Columns.Add("Valor", typeof(double));

                foreach (DataRow drConsultaPersonalizada in dtConsultaPersonalizada.Rows)
                {
                    DataRow tr = tb.NewRow();

                    tr[0] = drConsultaPersonalizada[0].ToString();
                    tr[1] = drConsultaPersonalizada[1].ToString();
                    tr[2] = drConsultaPersonalizada[2].ToString();
                    tr[3] = (drConsultaPersonalizada[3].ToString() == String.Empty ? 0 : drConsultaPersonalizada[3]);

                    tb.Rows.Add(tr);
                }

                foreach (DataRow drFormatear in tb.Rows)
                {
                    drFormatear[3] = Convert.ToDouble(String.Format("{0:0.00}", (double)drFormatear[3]));
                }

                String jsonTabla = JsonConvert.SerializeObject(tb, Newtonsoft.Json.Formatting.Indented);

                return jsonTabla;
            }
            catch (Exception exc)
            {
                if (exc.Message.ToString() != "No se puede encontrar la tabla 0." && exc.Message.ToString() != "Cannot find table 0.")
                {
                    return exc.Message.ToString();
                }
                else
                {
                    return "No se encontró información con los parámetros utilizados, por favor cambie los parametros y realice una nueva busqueda.";
                }

            }

        }

        public String ObtenerDepartamentosJSON()
        {

            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.ObtenerDepartamentos", Conexion);
                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;

                    ConsultaENGINE.CommandTimeout = 0;

                    DataSet datos = new DataSet();
                    SqlDataAdapter ad = new SqlDataAdapter();
                    ad.SelectCommand = ConsultaENGINE;

                    ad.Fill(datos, "ConsultaENGINE");

                    if (datos.Tables["ConsultaENGINE"].Rows.Count == 0)
                    {
                        return "No existen registros para esta consulta.";
                    }
                    else
                    {
                        String jsonTabla = JsonConvert.SerializeObject(datos.Tables["ConsultaENGINE"], Newtonsoft.Json.Formatting.Indented);
                        return jsonTabla;
                    }

                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }

        }

        public String ObtenerMunicipiosJSON(String codigoDepartamento)
        {
            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.ObtenerMunicipios", Conexion);
                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;
                    ConsultaENGINE.Parameters.Add("@CodigoDepartamento", SqlDbType.VarChar, 50);
                    ConsultaENGINE.Parameters["@CodigoDepartamento"].Value = codigoDepartamento;

                    ConsultaENGINE.CommandTimeout = 0;

                    DataSet datos = new DataSet();
                    SqlDataAdapter ad = new SqlDataAdapter();
                    ad.SelectCommand = ConsultaENGINE;

                    ad.Fill(datos, "ConsultaENGINE");

                    if (datos.Tables["ConsultaENGINE"].Rows.Count == 0)
                    {
                        return "No existen registros para esta consulta.";
                    }
                    else
                    {
                        String jsonTabla = JsonConvert.SerializeObject(datos.Tables["ConsultaENGINE"], Newtonsoft.Json.Formatting.Indented);
                        return jsonTabla;
                    }

                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }

        }

        public String ObtenerEncuestasJSON()
        {
            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.ObtenerEncuestas", Conexion);
                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;

                    ConsultaENGINE.CommandTimeout = 0;

                    DataSet datos = new DataSet();
                    SqlDataAdapter ad = new SqlDataAdapter();
                    ad.SelectCommand = ConsultaENGINE;

                    ad.Fill(datos, "ConsultaENGINE");

                    if (datos.Tables["ConsultaENGINE"].Rows.Count == 0)
                    {
                        return "No existen registros para esta consulta.";
                    }
                    else
                    {
                        String jsonTabla = JsonConvert.SerializeObject(datos.Tables["ConsultaENGINE"], Newtonsoft.Json.Formatting.Indented);
                        return jsonTabla;
                    }

                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }
        }

        public String ObtenerPreguntasPorCodigoJSON(String codigoEncuesta, String codigoPregunta)
        {
            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.ObtenerPreguntasPorCodigo", Conexion);
                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;
                    ConsultaENGINE.Parameters.Add("@CodigoEncuesta", SqlDbType.VarChar, 10);
                    ConsultaENGINE.Parameters["@CodigoEncuesta"].Value = codigoEncuesta;
                    ConsultaENGINE.Parameters.Add("@CodigoPregunta", SqlDbType.VarChar, 50);
                    ConsultaENGINE.Parameters["@CodigoPregunta"].Value = codigoPregunta;

                    ConsultaENGINE.CommandTimeout = 0;

                    DataSet datos = new DataSet();
                    SqlDataAdapter ad = new SqlDataAdapter();
                    ad.SelectCommand = ConsultaENGINE;

                    ad.Fill(datos, "ConsultaENGINE");

                    if (datos.Tables["ConsultaENGINE"].Rows.Count == 0)
                    {
                        return "No existen registros para esta consulta.";
                    }
                    else
                    {
                        String jsonTabla = JsonConvert.SerializeObject(datos.Tables["ConsultaENGINE"], Newtonsoft.Json.Formatting.Indented);
                        return jsonTabla;
                    }
                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }
        }

        public String ObtenerPreguntasPorNombreJSON(String codigoEncuesta, String nombrePregunta)
        {
            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.ObtenerPreguntasPorNombre", Conexion);
                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;
                    ConsultaENGINE.Parameters.Add("@CodigoEncuesta", SqlDbType.VarChar, 10);
                    ConsultaENGINE.Parameters["@CodigoEncuesta"].Value = codigoEncuesta;
                    ConsultaENGINE.Parameters.Add("@NombrePregunta", SqlDbType.VarChar, 500);
                    ConsultaENGINE.Parameters["@NombrePregunta"].Value = nombrePregunta;

                    ConsultaENGINE.CommandTimeout = 0;

                    DataSet datos = new DataSet();
                    SqlDataAdapter ad = new SqlDataAdapter();
                    ad.SelectCommand = ConsultaENGINE;

                    ad.Fill(datos, "ConsultaENGINE");

                    if (datos.Tables["ConsultaENGINE"].Rows.Count == 0)
                    {
                        return "No existen registros para esta consulta.";
                    }
                    else
                    {
                        String jsonTabla = JsonConvert.SerializeObject(datos.Tables["ConsultaENGINE"], Newtonsoft.Json.Formatting.Indented);
                        return jsonTabla;
                    }
                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }
        }

        public String ObtenerPreguntasPorConsultaPredefinidaJSON(int idConsultaPredefinida)
        {
            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.ObtenerPreguntasPorConsultaPredefinida", Conexion);
                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;
                    ConsultaENGINE.Parameters.Add("@IdConsultaPredefinida", SqlDbType.Int);
                    ConsultaENGINE.Parameters["@IdConsultaPredefinida"].Value = idConsultaPredefinida;

                    ConsultaENGINE.CommandTimeout = 0;

                    DataSet datos = new DataSet();
                    SqlDataAdapter ad = new SqlDataAdapter();
                    ad.SelectCommand = ConsultaENGINE;

                    ad.Fill(datos, "ConsultaENGINE");

                    if (datos.Tables["ConsultaENGINE"].Rows.Count == 0)
                    {
                        return "No existen registros para esta consulta.";
                    }
                    else
                    {
                        String jsonTabla = JsonConvert.SerializeObject(datos.Tables["ConsultaENGINE"], Newtonsoft.Json.Formatting.Indented);
                        return jsonTabla;
                    }

                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }
        }

        public List<string> ObtenerListadoConsultaPredefinida()
        {
            String errorServicio;
            List<string> valores = new List<string>();
            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.ObtenerListadoConsultaPredefinida", Conexion);
                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;

                    ConsultaENGINE.CommandTimeout = 0;

                    DataSet datos = new DataSet();
                    SqlDataAdapter ad = new SqlDataAdapter();
                    ad.SelectCommand = ConsultaENGINE;

                    ad.Fill(datos, "ConsultaENGINE");

                    if (datos.Tables["ConsultaENGINE"].Rows.Count == 0)
                    {
                        errorServicio = "No existen registros para esta consulta.";

                        return null;
                    }
                    else
                    {
                        errorServicio = String.Empty;
                        String jsonTabla = JsonConvert.SerializeObject(datos.Tables["ConsultaENGINE"], Newtonsoft.Json.Formatting.Indented);
                        valores.Add(errorServicio);
                        valores.Add(jsonTabla);

                        //return jsonTabla;
                        return valores;
                    }

                }
            }
            catch (Exception ex)
            {
                errorServicio = ex.Message.ToString();
                valores.Add(errorServicio);
                return valores;
                //return null;
            }

        }

        public List<string> ObtenerInformacionConsultaPredefinida(int idConsultaPredefinida) 
        {
            List<string> valores = new List<string>();
            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    Conexion.Open();

                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.ObtenerInformacionConsultaPredefinida", Conexion);

                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;
                    ConsultaENGINE.Parameters.Add("@IdConsultaPredefinida", SqlDbType.Int);
                    ConsultaENGINE.Parameters["@IdConsultaPredefinida"].Value = idConsultaPredefinida;
                    ConsultaENGINE.Parameters.Add("@Nombre", SqlDbType.VarChar, 150);
                    ConsultaENGINE.Parameters["@Nombre"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@Descripcion", SqlDbType.VarChar, 1000);
                    ConsultaENGINE.Parameters["@Descripcion"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@CodigoPreguntas", SqlDbType.VarChar, 1000);
                    ConsultaENGINE.Parameters["@CodigoPreguntas"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@CodigoEncuesta", SqlDbType.VarChar, 10);
                    ConsultaENGINE.Parameters["@CodigoEncuesta"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@CodigoDepartamento", SqlDbType.VarChar, 50);
                    ConsultaENGINE.Parameters["@CodigoDepartamento"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@CodigoMunicipio", SqlDbType.VarChar, 50);
                    ConsultaENGINE.Parameters["@CodigoMunicipio"].Direction = ParameterDirection.Output;

                    ConsultaENGINE.CommandTimeout = 0;

                    ConsultaENGINE.ExecuteNonQuery();

                    valores.Add("nombre =" + (String)ConsultaENGINE.Parameters["@Nombre"].Value);
                    valores.Add("descripcion =" + (String)ConsultaENGINE.Parameters["@Descripcion"].Value);
                    valores.Add("codigoPreguntas =" + (String)ConsultaENGINE.Parameters["@CodigoPreguntas"].Value);
                    valores.Add("codigoEncuesta =" + (String)ConsultaENGINE.Parameters["@CodigoEncuesta"].Value);
                    valores.Add("codigoDepartamento =" + (String)ConsultaENGINE.Parameters["@CodigoDepartamento"].Value);
                    valores.Add("codigoMunicipio =" + (String)ConsultaENGINE.Parameters["@CodigoMunicipio"].Value);

                    Conexion.Close();
                    Conexion.Dispose();
                }
            }
            catch (Exception ex)
            {
                valores.Add("errorServicio =" + ex.Message.ToString());
            }
            return valores;
        }

        public String ObtenerControlesDimensionesConsultaPredefinida(int idConsulaPredefinida)
        {
            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.ObtenerDimensionesConsultaPredefinida", Conexion);
                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;
                    ConsultaENGINE.Parameters.Add("@IdConsultaPredefinida", SqlDbType.Int);
                    ConsultaENGINE.Parameters["@IdConsultaPredefinida"].Value = idConsulaPredefinida;

                    ConsultaENGINE.CommandTimeout = 0;

                    DataSet datos = new DataSet();
                    SqlDataAdapter ad = new SqlDataAdapter();
                    ad.SelectCommand = ConsultaENGINE;

                    ad.Fill(datos, "ConsultaENGINE");

                    if (datos.Tables["ConsultaENGINE"].Rows.Count == 0)
                    {
                        return "No existen registros para esta consulta.";
                    }
                    else
                    {
                        String jsonTabla = JsonConvert.SerializeObject(datos.Tables["ConsultaENGINE"], Newtonsoft.Json.Formatting.Indented);
                        return jsonTabla;
                    }

                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }

        }

        public String ObtenerControlesHechosConsultaPredefinida(int idConsulaPredefinida)
        {
            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.ObtenerHechosConsultaPredefinida", Conexion);
                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;
                    ConsultaENGINE.Parameters.Add("@IdConsultaPredefinida", SqlDbType.Int);
                    ConsultaENGINE.Parameters["@IdConsultaPredefinida"].Value = idConsulaPredefinida;

                    ConsultaENGINE.CommandTimeout = 0;

                    DataSet datos = new DataSet();
                    SqlDataAdapter ad = new SqlDataAdapter();
                    ad.SelectCommand = ConsultaENGINE;

                    ad.Fill(datos, "ConsultaENGINE");

                    if (datos.Tables["ConsultaENGINE"].Rows.Count == 0)
                    {
                        return "No existen registros para esta consulta.";
                    }
                    else
                    {
                        String jsonTabla = JsonConvert.SerializeObject(datos.Tables["ConsultaENGINE"], Newtonsoft.Json.Formatting.Indented);
                        return jsonTabla;
                    }

                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }
        }

        public string PersistirConsultaPredefinida(string model)
        {
            CrearPersonalizadasModels crear = JsonConvert.DeserializeObject<CrearPersonalizadasModels>(model);
            try
            {
                string idConsultaPredefinidaSalida = "0";
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    Conexion.Open();

                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.PersistirConsultaPredefinida", Conexion);

                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;
                    ConsultaENGINE.Parameters.Add("@IdConsultaPredefinida", SqlDbType.Int);
                    ConsultaENGINE.Parameters["@IdConsultaPredefinida"].Value = crear.idConsultaPredefinida;
                    ConsultaENGINE.Parameters.Add("@Nombre", SqlDbType.VarChar, 1000);
                    ConsultaENGINE.Parameters["@Nombre"].Value = crear.nombre;
                    ConsultaENGINE.Parameters.Add("@Descripcion", SqlDbType.VarChar, 1000);
                    ConsultaENGINE.Parameters["@Descripcion"].Value = crear.descripcion;
                    ConsultaENGINE.Parameters.Add("@CodigoPreguntas", SqlDbType.VarChar, 1000);
                    ConsultaENGINE.Parameters["@CodigoPreguntas"].Value = crear.codigoPreguntas;
                    ConsultaENGINE.Parameters.Add("@CodigoEncuesta", SqlDbType.VarChar, 10);
                    ConsultaENGINE.Parameters["@CodigoEncuesta"].Value = crear.codigoEncuesta;
                    ConsultaENGINE.Parameters.Add("@CodigoDepartamento", SqlDbType.VarChar, 50);
                    ConsultaENGINE.Parameters["@CodigoDepartamento"].Value = crear.codigoDepartamento;
                    ConsultaENGINE.Parameters.Add("@CodigoMunicipio", SqlDbType.VarChar, 50);
                    ConsultaENGINE.Parameters["@CodigoMunicipio"].Value = crear.codigoMunicipio;
                    ConsultaENGINE.Parameters.Add("@IdConsultaPredefinidaSalida", SqlDbType.Int);
                    ConsultaENGINE.Parameters["@IdConsultaPredefinidaSalida"].Direction = ParameterDirection.Output;

                    ConsultaENGINE.CommandTimeout = 0;

                    ConsultaENGINE.ExecuteNonQuery();

                    idConsultaPredefinidaSalida = ConsultaENGINE.Parameters["@IdConsultaPredefinidaSalida"].Value.ToString();

                    Conexion.Close();
                    Conexion.Dispose();

                    return idConsultaPredefinidaSalida;
                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }
        }

        public string LimpiarConsultaPredefinida(int idConsultaPredefinida)
        {
            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    Conexion.Open();

                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.LimpiarConsultaPredefinida", Conexion);

                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;
                    ConsultaENGINE.Parameters.Add("@IdConsultaPredefinida", SqlDbType.Int);
                    ConsultaENGINE.Parameters["@IdConsultaPredefinida"].Value = idConsultaPredefinida;

                    ConsultaENGINE.CommandTimeout = 0;

                    ConsultaENGINE.ExecuteNonQuery();

                    Conexion.Close();
                    Conexion.Dispose();
                    return String.Empty;
                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }
        }

        public string PersistirDimensionHechoConsultaPrefefinida(string model)
        {
            try
            {
                cambiarModel crear = JsonConvert.DeserializeObject<cambiarModel>(model);

                int idConsultaPredefinida = crear.idConsultaPredefinida;
                string control = crear.control;
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    Conexion.Open();

                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.PersistirDimensionHechoConsultaPrefefinida", Conexion);

                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;
                    ConsultaENGINE.Parameters.Add("@IdConsultaPredefinida", SqlDbType.Int);
                    ConsultaENGINE.Parameters["@IdConsultaPredefinida"].Value = idConsultaPredefinida;
                    ConsultaENGINE.Parameters.Add("@Control", SqlDbType.VarChar, 50);
                    ConsultaENGINE.Parameters["@Control"].Value = control;

                    ConsultaENGINE.CommandTimeout = 0;

                    ConsultaENGINE.ExecuteNonQuery();
                    Conexion.Close();
                    Conexion.Dispose();
                    return String.Empty;
                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }
        }

        public string PersistirUbicacionConsultaPrefefinida(int idConsultaPredefinida, String nombre, string ubicacion)
        {
            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    Conexion.Open();

                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.PersistirUbicacionConsultaPrefefinida", Conexion);

                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;
                    ConsultaENGINE.Parameters.Add("@IdConsultaPredefinida", SqlDbType.Int);
                    ConsultaENGINE.Parameters["@IdConsultaPredefinida"].Value = idConsultaPredefinida;
                    ConsultaENGINE.Parameters.Add("@Nombre", SqlDbType.VarChar, 50);
                    ConsultaENGINE.Parameters["@Nombre"].Value = nombre;
                    ConsultaENGINE.Parameters.Add("@Ubicacion", SqlDbType.VarChar, 50);
                    ConsultaENGINE.Parameters["@Ubicacion"].Value = ubicacion;

                    ConsultaENGINE.CommandTimeout = 0;

                    ConsultaENGINE.ExecuteNonQuery();

                    Conexion.Close();
                    Conexion.Dispose();
                    return String.Empty;
                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }
        }

        public string PersistirPreguntaConsultaPrefefinida(int idConsultaPredefinida, String codigoPregunta)
        {
            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    Conexion.Open();

                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.PersistirPreguntaConsultaPrefefinida", Conexion);

                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;
                    ConsultaENGINE.Parameters.Add("@IdConsultaPredefinida", SqlDbType.Int);
                    ConsultaENGINE.Parameters["@IdConsultaPredefinida"].Value = idConsultaPredefinida;
                    ConsultaENGINE.Parameters.Add("@CodigoPregunta", SqlDbType.VarChar, 50);
                    ConsultaENGINE.Parameters["@CodigoPregunta"].Value = codigoPregunta;

                    ConsultaENGINE.CommandTimeout = 0;

                    ConsultaENGINE.ExecuteNonQuery();

                    Conexion.Close();
                    Conexion.Dispose();
                    return String.Empty;
                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }
        }

        public List<string> ObtenerDimensionesHechosPorPregunta(String codigoPreguntas)
        {
            List<string> valores = new List<string>();
            try
            {
                using (SqlConnection Conexion = new SqlConnection(connectionStringENGINE + "async=true;"))
                {
                    Conexion.Open();

                    SqlCommand ConsultaENGINE = new SqlCommand("Apoyo.ObtenerDimensionesHechosPorPregunta", Conexion);

                    ConsultaENGINE.CommandType = CommandType.StoredProcedure;
                    ConsultaENGINE.Parameters.Add("@codigoPreguntas", SqlDbType.VarChar, 500);
                    ConsultaENGINE.Parameters["@codigoPreguntas"].Value = codigoPreguntas;
                    ConsultaENGINE.Parameters.Add("@hechoMoneda", SqlDbType.Bit);
                    ConsultaENGINE.Parameters["@hechoMoneda"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@hechoNumero", SqlDbType.Bit);
                    ConsultaENGINE.Parameters["@hechoNumero"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@hechoPorcentaje", SqlDbType.Bit);
                    ConsultaENGINE.Parameters["@hechoPorcentaje"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@hechoRespuestaUnica", SqlDbType.Bit);
                    ConsultaENGINE.Parameters["@hechoRespuestaUnica"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@dimensionEtapaPolitica", SqlDbType.Bit);
                    ConsultaENGINE.Parameters["@dimensionEtapaPolitica"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@dimensionSeccion", SqlDbType.Bit);
                    ConsultaENGINE.Parameters["@dimensionSeccion"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@dimensionTema", SqlDbType.Bit);
                    ConsultaENGINE.Parameters["@dimensionTema"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@dimensionHechoVictimizante", SqlDbType.Bit);
                    ConsultaENGINE.Parameters["@dimensionHechoVictimizante"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@dimensionDinamicaDesplazamiento", SqlDbType.Bit);
                    ConsultaENGINE.Parameters["@dimensionDinamicaDesplazamiento"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@dimensionEnfoqueDiferencial", SqlDbType.Bit);
                    ConsultaENGINE.Parameters["@dimensionEnfoqueDiferencial"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@dimensionFactoresRiesgo", SqlDbType.Bit);
                    ConsultaENGINE.Parameters["@dimensionFactoresRiesgo"].Direction = ParameterDirection.Output;
                    ConsultaENGINE.Parameters.Add("@dimensionRangoEtareo", SqlDbType.Bit);
                    ConsultaENGINE.Parameters["@dimensionRangoEtareo"].Direction = ParameterDirection.Output;

                    ConsultaENGINE.CommandTimeout = 0;

                    ConsultaENGINE.ExecuteNonQuery();

                    valores.Add("hechoMoneda =" + (bool)ConsultaENGINE.Parameters["@hechoMoneda"].Value);
                    valores.Add("hechoNumero =" + (bool)ConsultaENGINE.Parameters["@hechoNumero"].Value);
                    valores.Add("hechoPorcentaje =" + (bool)ConsultaENGINE.Parameters["@hechoPorcentaje"].Value);
                    valores.Add("hechoRespuestaUnica =" + (bool)ConsultaENGINE.Parameters["@hechoRespuestaUnica"].Value);
                    valores.Add("dimensionEtapaPolitica =" + (bool)ConsultaENGINE.Parameters["@dimensionEtapaPolitica"].Value);
                    valores.Add("dimensionSeccion =" + (bool)ConsultaENGINE.Parameters["@dimensionSeccion"].Value);
                    valores.Add("dimensionTema =" + (bool)ConsultaENGINE.Parameters["@dimensionTema"].Value);
                    valores.Add("dimensionHechoVictimizante =" + (bool)ConsultaENGINE.Parameters["@dimensionHechoVictimizante"].Value);
                    valores.Add("dimensionDinamicaDesplazamiento =" + (bool)ConsultaENGINE.Parameters["@dimensionDinamicaDesplazamiento"].Value);
                    valores.Add("dimensionEnfoqueDiferencial =" + (bool)ConsultaENGINE.Parameters["@dimensionEnfoqueDiferencial"].Value);
                    valores.Add("dimensionFactoresRiesgo =" + (bool)ConsultaENGINE.Parameters["@dimensionFactoresRiesgo"].Value);
                    valores.Add("dimensionRangoEtareo =" + (bool)ConsultaENGINE.Parameters["@dimensionRangoEtareo"].Value);

                    Conexion.Close();
                    Conexion.Dispose();

                    return valores;
                }
            }
            catch (Exception ex)
            {
                valores.Add("errorServicio =" + ex.Message.ToString());
                return valores;
            }
        }

        public String ObtenerMunicipiosPorDepartamentoJSON(string departamento)
        {
            string consulta;

            DataTable dtMunicipios;

            try
            {
                // Consolidadora

                consulta = String.Empty;

                consulta = @"
                                SELECT 
                                    { [Measures].[Valor Moneda] } ON COLUMNS, 
                                    NON EMPTY { ([Municipio].[Codigo Municipio].[Codigo Municipio] * [Municipio].[Nombre Municipio].[Nombre Municipio] ) } 
                                    DIMENSION PROPERTIES MEMBER_CAPTION ON ROWS 
                                    FROM ( SELECT ( { [Municipio].[Nombre Departamento].&[" + departamento + @"] } ) ON COLUMNS FROM [DWH RUSICST]) 
                                    WHERE ( [Municipio].[Nombre Departamento].&[" + departamento + @"] )                                 
                            ";


                dtMunicipios = ExecuteCommandDataTable(consulta);

                DataTable tb = new DataTable("Municipios");

                tb.Columns.Add("CodigoMunicipio", typeof(string));
                tb.Columns.Add("NombreMunicipio", typeof(string));

                tb.Rows.Add("0", "... Seleccione");

                foreach (DataRow drMunicipios in dtMunicipios.Rows)
                {
                    DataRow tr = tb.NewRow();

                    tr[0] = drMunicipios[0].ToString();
                    tr[1] = drMunicipios[1].ToString();

                    tb.Rows.Add(tr);
                }

                DataView dv = new DataView(tb);
                dv.Sort = "NombreMunicipio ASC";
                tb = dv.ToTable();

                String jsonTabla = JsonConvert.SerializeObject(tb, Newtonsoft.Json.Formatting.Indented);

                return jsonTabla;
            }
            catch (Exception exc)
            {
                if (exc.Message.ToString() != "No se puede encontrar la tabla 0." && exc.Message.ToString() != "Cannot find table 0.")
                {
                    return exc.Message.ToString();
                }
                else
                {
                    return "No se encontró información para los parámetros utilizados en la consulta.";
                }
            }

        }

        public String ObtenerListaDepartamentosJSON()
        {
            DataTable tb = new DataTable("Departamentos");

            tb.Columns.Add("CodigoDepartamento", typeof(string));
            tb.Columns.Add("NombreDepartamento", typeof(string));

            tb.Rows.Add("0", "... Seleccione");
            tb.Rows.Add("Amazonas", "Amazonas");
            tb.Rows.Add("Antioquia", "Antioquia");
            tb.Rows.Add("Arauca", "Arauca");
            tb.Rows.Add("Atlántico", "Atlántico");
            tb.Rows.Add("Bogotá_D.C.", "Bogotá, D.C.");
            tb.Rows.Add("Bolivar", "Bolívar");
            tb.Rows.Add("Boyacá", "Boyacá");
            tb.Rows.Add("Caldas", "Caldas");
            tb.Rows.Add("Caquetá", "Caquetá");
            tb.Rows.Add("Casanare", "Casanare");
            tb.Rows.Add("Cauca", "Cauca");
            tb.Rows.Add("Cesar", "Cesar");
            tb.Rows.Add("Choco", "Chocó");
            tb.Rows.Add("Córdoba", "Córdoba");
            tb.Rows.Add("Cundinamarca", "Cundinamarca");
            tb.Rows.Add("Guainía", "Guainía");
            tb.Rows.Add("La_Guajira", "La Guajira");
            tb.Rows.Add("Guaviare", "Guaviare");
            tb.Rows.Add("Huila", "Huila");
            tb.Rows.Add("Magdalena", "Magdalena");
            tb.Rows.Add("Meta", "Meta");
            tb.Rows.Add("Nariño", "Nariño");
            tb.Rows.Add("Norte_de_Santander", "Norte de Santander");
            tb.Rows.Add("Putumayo", "Putumayo");
            tb.Rows.Add("Quindío", "Quindio");
            tb.Rows.Add("Risaralda", "Risaralda");
            tb.Rows.Add("San_Andrés_y_Providencia", "Archipiélago de San Andrés");
            tb.Rows.Add("Santander", "Santander");
            tb.Rows.Add("Sucre", "Sucre");
            tb.Rows.Add("Tolima", "Tolima");
            tb.Rows.Add("Valle_del_Cauca", "Valle del Cauca");
            tb.Rows.Add("Vaupes", "Vaupés");
            tb.Rows.Add("Vichada", "Vichada");

            String jsonTabla = JsonConvert.SerializeObject(tb, Newtonsoft.Json.Formatting.Indented);

            return jsonTabla;
        }

        public String ObtenerTiposGraficaJSON()
        {
            DataTable tb = new DataTable("TiposGrafica");

            tb.Columns.Add("CodigoTipoGrafica", typeof(string));
            tb.Columns.Add("NombreTipoGrafica", typeof(string));

            tb.Rows.Add("0", "Columnas");
            tb.Rows.Add("1", "Pastel");
            tb.Rows.Add("2", "Linea");
            tb.Rows.Add("3", "Barras");

            String jsonTabla = JsonConvert.SerializeObject(tb, Newtonsoft.Json.Formatting.Indented);

            return jsonTabla;
        }


        //public String QuitarCadena(String original, String caracter)
        //{
        //    char[] arreglo = original.ToCharArray();
        //    Array.Reverse(arreglo);

        //    String invertida = new String(arreglo);
        //    invertida = invertida.Substring(invertida.IndexOf(caracter) + 2, (invertida.Length - (invertida.IndexOf(caracter) + 2)));

        //    char[] arregloCorregido = invertida.ToCharArray();
        //    Array.Reverse(arregloCorregido);

        //    return new String(arregloCorregido);
        //}

        //public static String Reverse(String s)
        //{
        //    char[] charArray = s.ToCharArray();
        //    Array.Reverse(charArray);
        //    return new String(charArray);
        //}
    }
}




