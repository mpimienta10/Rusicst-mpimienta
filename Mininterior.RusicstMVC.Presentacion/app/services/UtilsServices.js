app.service("UtilsService", function ($http, uiGridConstants, $templateCache, Excel, uiGridExporterService, uiGridExporterConstants, uiGridGroupingService, $timeout, $uibModal, authService, APIService, $q) {
    var self = this;

    this.exportTo = function (grid, rowTypes, colTypes, separator, filename, type, modo) {

        var self = this;
        var exportService = uiGridExporterService;
        var groupingService = uiGridGroupingService;
        exportService.loadAllDataIfNeeded(grid, rowTypes, colTypes).then(function () {
            var aaa = grid.api.core.getVisibleRows(grid);
            var exportData = [];
            var exportColumnHeaders = grid.options.showHeader ? exportService.getColumnHeaders(grid, colTypes) : [];
            var niveles = grid.treeBase.numberLevels;
            if (niveles > 0 && modo == "todos") {
                var datosGroupingAll = grid.treeBase.tree;

                var obj = { value: "" };
                var objArray = [];
                angular.forEach(exportColumnHeaders, function (row) {
                    objArray.push(angular.copy(obj));
                });
                var j = 0;
                angular.forEach(datosGroupingAll, function (tree) {

                    var objArrayCopy = angular.copy(objArray);
                    for (entity in tree.row.entity) {
                        if (tree.row.entity[entity].rendered != undefined)
                            objArrayCopy[0].value = tree.row.entity[entity].rendered;
                    };
                    exportData.push(objArrayCopy);

                    var childrens = grid.api.treeBase.getRowChildren(tree.row);

                    angular.forEach(childrens, function (children) {

                        var objArrayCopy = angular.copy(objArray);
                        for (entity in children.entity) {
                            if (children.entity[entity].rendered != undefined)
                                objArrayCopy[0].value = tree.row.entity[entity].rendered;
                        };
                    });
                    if (niveles > 1) {
                        for (i = 1; i < niveles; i++) {
                            var objArrayCopy = angular.copy(objArray);
                            for (entity in children['0'].entity) {
                                if (tree.row.entity[entity].rendered != undefined)
                                    objArrayCopy[i].value = tree.row.entity[entity].rendered;
                            };
                            exportData.push(objArrayCopy);

                            var children = children['0'].grid.api.treeBase.getRowChildren(children['0'].treeNode.row);
                        }
                    }



                    var t = tree.row;
                    var children = grid.api.treeBase.getRowChildren(t);
                });
            } else {
                exportData = exportService.getData(grid, rowTypes, colTypes);
            };

            var csvContent = exportService.formatAsCsv(exportColumnHeaders, exportData, separator);
            var ext = '.' + type;
            var fileName = filename + ext;

            if (type === "xls") {
                exportToExcel(exportColumnHeaders, exportData, fileName, type);
            } else if (type === "csv") {
                exportService.downloadFile(fileName, csvContent, true, true)

            } else if (type === "txt") {
                exportService.downloadFile(fileName, csvContent, true, true)
            } else if (type === "pdf") {
                downloadFile(fileName, csvContent, true, true)
            }

        });
    };

    exportToExcel = function (exportColumnHeaders, exportData, filename, type) {

        var self = this;

        var bareHeaders = exportColumnHeaders.map(function (header) { return { value: header.displayName }; });
        var excel = "<table>";
        excel += "<tr>";
        angular.forEach(bareHeaders, function (value, key) {
            excel += "<th>" + value.value + "</th>";
        });
        excel += '</tr>';
        angular.forEach(exportData, function (row, key) {

            excel += "<tr>";
            angular.forEach(row, function (val, k) {

                if (val.value == undefined) val.value = "";
                excel += "<td>" + val.value.toString().replace(/"/g, "") + " </td>";
            });
            excel += '</tr>';
        });
        excel += '</table>'
        var exportHref = Excel.tableToExcel(excel, filename);
        $timeout(function () { location.href = exportHref; }, 100); // trigger download

    };

    this.getColumnDefs = function (gridOptions, isColumnDefs, columnsActions, columsNoVisibles) {

        var items = gridOptions.data;

        if (!isColumnDefs) {
            i = 0;
            gridOptions.columnDefs = [];
            for (property in items[0]) {
                ++i;
                gridOptions.columnDefs[i] = getJson(items, property);
            };
            //agrega al objeto las columnas adicionales que tienen acciones que se pasaron
            if (columnsActions) {
                angular.forEach(columnsActions, function (newColum) {
                    ++i;
                    gridOptions.columnDefs[i] = newColum;
                });
            }
            //ocultar columnas
            if (columsNoVisibles) {

                angular.forEach(gridOptions.columnDefs, function (columna) {

                    angular.forEach(columsNoVisibles, function (novisible) {
                        if (columna.field == novisible) {
                            columna.visible = false;

                        }
                    });
                });
            }

        } else {
            i = 0;
            for (property in items[0]) {
                ++i;
                gridOptions.columnDefs[i]["filters"][0]["selectOptions"] = getUnique(items, property);

            };
        };

        function getJson(items, property) {
            var unique = getUnique(items, property);
            var columnDefsJson = {
                displayName: property,
                field: property,
                minWidth: 80,
                filters: [{ selectOptions: unique, term: '', type: uiGridConstants.filter.SELECT, condition: uiGridConstants.filter.EXACT, disableCancelFilterButton: true, }, { condition: uiGridConstants.filter.CONTAINS, }],
                cellTooltip: function (row, col) { return row.entity[property] },
            };

            return columnDefsJson;
        };
    }

    function getUnique(items, propertyName) {

        var jsonSelect = { value: "", label: "" };
        var result = [];
        var resultArray = [];
        $.each(items, function (index, item) {
            if ($.inArray(item[propertyName], resultArray) == -1) {
                if (item[propertyName] != null) {
                    jsonSelect = { value: item[propertyName], label: item[propertyName] };
                    resultArray.push(item[propertyName]);
                    result.push(jsonSelect);
                }
            }


        });

        result.sort(function (a, b) {
            if (a.value < b.value)
                return -1;
            if (a.value > b.value)
                return 1;
            return 0;
        });

        //result.sort(function (a, b) {
        //    return parseFloat(a.value) - parseFloat(b.value);
        //});

        return result;
    };

    this.utilsGridOptions = function (gridOptions, actionJson) {
        if (actionJson) {
            var action = actionJson.action;
            var definition = actionJson.definition;
            var parameters = actionJson.parameters;

            switch (action) {
                case "CambiarDefinicion":

                    if (parameters) {

                        angular.forEach(gridOptions.columnDefs, function (columna) {
                            angular.forEach(parameters, function (parameter) {
                                if (columna.field == parameter.field) {
                                    columna[definition] = parameter.newProperty;
                                }
                            });
                        });
                    }
                    break;
                case "CambiarFecha": {
                    $templateCache.put('ui-grid/date-cell',
                        "<div class='ui-grid-cell-contents'>{{COL_FIELD | date:'dd/MM/yyyy'}}</div>"
                    );

                    // Custom template using Bootstrap DatePickerPopup
                    $templateCache.put('ui-grid/ui-grid-date-filter',
                        '<div class="ui-grid-filter-container" >' +
                        '<select class="select-date" ng-model="col.filters[0].term" ng-options="option.value as option.value for option in col.filters[0].options"></select>' +
                        '</div>' +
                        '<div class="ui-grid-filter-container" >' +
                        '<input type="text" uib-datepicker-popup="dd/MM/yyyy" class="input-date" ' +
                        'datepicker-options="datePicker.options" ' +
                        'datepicker-append-to-body="true" show-button-bar="false"' +
                        'is-open="showDatePopup[1].opened" class="ui-grid-filter-input ui-grid-filter-input-{{1}}"' +
                        'style="" ng-model="col.filters[1].term" ng-attr-placeholder="{{col.filters[1].placeholder || \'\'}}\" ' +
                        'aria-label="{{col.filters[1].ariaLabel || aria.defaultFilterLabel}}" />' +

                        '<span style="padding-left:0;"><button type="button" class="btn btn-default btn-sm btn-calendar" ng-click="showDatePopup[1].opened = true">' +
                        '<i class="fa fa-calendar"></i></button></span>' +

                        '<div role="button" class="ui-grid-filter-button" ng-click="removeFilter(col.filters[1], 1)" ng-if="!col.filters[1].disableCancelFilterButton" ng-disabled="col.filters[1].term === undefined || col.filters[1].term === null || col.filters[1].term === \'\'" ng-show="col.filters[1].term !== undefined && col.filters[1].term !== null && col.filters[1].term !== \'\'">' +
                        '<i class="ui-grid-icon-cancel btn-disable-calendar " ui-grid-one-bind-aria-label="aria.removeFilter">&nbsp;</i></div></div><div ng-if="col.filters[1].type === \'select\'"><select class="ui-grid-filter-select ui-grid-filter-input-{{1}}" ng-model="col.filters[1].term" ng-attr-placeholder="{{col.filters[1].placeholder || aria.defaultFilterLabel}}" aria-label="{{col.filters[1].ariaLabel || ""}}" ng-options="option.value as option.label for option in col.filters[1].selectOptions"><option value=""></option></select><div role="button" class="ui-grid-filter-button-select" ng-click="removeFilter(col.filters[1], 1)" ng-if="!col.filters[1].disableCancelFilterButton" ng-disabled="col.filters[1].term === undefined || col.filters[1].term === null || col.filters[1].term === \'\'" ng-show="col.filters[1].term !== undefined && col.filters[1].term != null"><i class="ui-grid-icon-cancel" ui-grid-one-bind-aria-label="aria.removeFilter">&nbsp;</i></div></div>' +

                        '</div>'

                    );
                    var dateColumn = {
                        cellTooltip: true,
                        cellFilter: 'date:\'dd/MM/yyyy\'',
                        cellTemplate: 'ui-grid/date-cell',
                        filterHeaderTemplate: 'ui-grid/ui-grid-date-filter',
                        width: 175,
                        minWidth: 175,
                        cellFilter: 'date:"longDate"',
                        filters: [
                            {
                                term: "",
                                condition: function (term, value, row, column) {
                                    if (!term) return true;
                                    var term = term.replace("\\", "");
                                    var term = term.replace("\\", "");
                                    var term = term.split("/");
                                    var term = Date.parse(term[1] + "/" + term[0] + "/" + term[2]);
                                    var valueDate = new Date(value);
                                    return +value === +term;
                                },
                            },
                            {
                                condition: function (term, value, row, column) {

                                    if (!term) return true;
                                    var valueDate = new Date(value);
                                    return +valueDate === +term;
                                },

                            }]
                    };

                    if (parameters) {

                        angular.forEach(gridOptions.columnDefs, function (columna) {
                            angular.forEach(parameters, function (parameter) {

                                if (columna.field == parameter.field) {
                                    angular.forEach(gridOptions.data, function (val) {
                                        val[columna.field] = val[columna.field] == null ? '' : new Date(val[columna.field]).setHours(0, 0, 0, 0);

                                    });

                                    var dateColumnCopy = angular.copy(dateColumn);
                                    for (definicion in dateColumnCopy) {

                                        columna[definicion] = dateColumnCopy[definicion];
                                    }

                                    uniques = getUnique(gridOptions.data, columna.field);
                                    angular.forEach(uniques, function (unique) {
                                        unique.value = new Date(unique.value).toLocaleDateString();
                                        unique.label = "dsada";
                                    });

                                    uniques.splice(0, 0, { value: "", label: "" });
                                    columna["filters"][0]["options"] = uniques;
                                }
                            });
                        });
                    }
                    break;
                }

            }

        }
    }

    this.getErrorMessages = function () {

        errorMessages = {};
        errorMessages.select = "Seleccione opción";
        errorMessages.inputText = "Campo obligatorio";
        errorMessages.email = "Email inválido";
        errorMessages.icon = '<i class="fa fa-exclamation-circle"></i>';
        errorMessages.fileRequired = 'Debe seleccionar un archivo ';
        errorMessages.maxSize = 'menor de 10 MB';
        errorMessages.comparePasswords = 'La contraseña es distinta a la confirmación';
        errorMessages.groupCheckbox = 'Debe seleccionar al menos una Opción de Menú';
        errorMessages.dateRequired = 'Debe indicar la fecha';
        errorMessages.dateNoMatch = 'La fecha inicial debe ser menor o igual a la fecha final';
        errorMessages.minlength = 'El tamaño mínimo es de 6 caracteres';
        errorMessages.delete = 'Se generó un error en la petición, no se eliminaron los datos';
        errorMessages.extension = 'Tipo de archivo no permitido';
        errorMessages.exception = 'Se ha producido una Excepción. Por favor intente nuevamente. Si la inconsistencia persiste por favor comuniquese con el administrador del RUSICST.'
        errorMessages.passInvalid = 'La contraseña debe contener 6 digitos, contener una letra y un número';

        return errorMessages;
    }

    this.isNotGroup = function (entity) {
        var isNotGroup = true;
        for (item in entity) {
            if ("groupVal" in entity[item]) isNotGroup = false;

        }
        return isNotGroup
    }

    this.getArrayCascade = function (items, nameId, nameValue) {
        var jsonSelect = { id: "", value: "" };
        var result = [];
        var resultArray = [];
        $.each(items, function (index, item) {
            if ($.inArray(item[nameId], resultArray) == -1) {
                resultArray.push(item[nameId]);
                jsonSelect = { id: item[nameId], value: item[nameValue] };
                result.push(jsonSelect);
            }
        });
        return result;
    }

    //------------Obtener el Menú De Exportación Personalizado------------------
    this.getMenuGridCustom = function (gridApi, isExporterPDF) {
        var filename = $(".titulo").text();
        // debugger;
        gridMenuCustomItems = [
            {
                icon: 'icono-exportacion pdf', title: 'PDF Todos',
                action: function ($event) {
                    debugger;
                    gridApi.exporter.pdfExport(uiGridExporterConstants.ALL, uiGridExporterConstants.ALL);
                },
                order: 110
            },
            {
                icon: 'icono-exportacion pdf', title: 'PDF Vista',
                action: function ($event) {
                    gridApi.exporter.pdfExport(uiGridExporterConstants.VISIBLE, uiGridExporterConstants.VISIBLE);
                },
                order: 120
            },
            {
                icon: 'icono-exportacion excel', title: 'XLS Todos',
                action: function ($event) {
                    var filename = $("#titulo").text() + ' (Todos)';
                    self.exportTo(gridApi.grid, uiGridExporterConstants.ALL, uiGridExporterConstants.ALL, ',', filename, 'xls', 'todos');
                },
                order: 130
            },
            {
                icon: 'icono-exportacion excel', title: 'XLS Vista',
                action: function ($event) {
                    var filename = $("#titulo").text() + ' (Vista)';
                    self.exportTo(gridApi.grid, uiGridExporterConstants.VISIBLE, uiGridExporterConstants.VISIBLE, ',', filename, 'xls', 'vista');
                },
                order: 140
            },
            {
                icon: 'icono-exportacion csv', title: 'CSV Todos',
                action: function ($event) {
                    var filename = $("#titulo").text() + ' (Todos)';
                    self.exportTo(gridApi.grid, uiGridExporterConstants.ALL, uiGridExporterConstants.ALL, ';', filename, 'csv', 'todos');
                },
                order: 150
            },
            {
                icon: 'icono-exportacion csv', title: 'CSV Vista',
                action: function ($event) {
                    var filename = $("#titulo").text() + ' (Vista)';
                    self.exportTo(gridApi.grid, uiGridExporterConstants.VISIBLE, uiGridExporterConstants.VISIBLE, ';', filename, 'csv', 'vista');
                },
                order: 160
            },
            {
                icon: 'icono-exportacion txt', title: 'TXT Todos',
                action: function ($event) {
                    var filename = $("#titulo").text() + ' (Todos)';
                    self.exportTo(gridApi.grid, uiGridExporterConstants.ALL, uiGridExporterConstants.ALL, ';', filename, 'txt', 'todos');
                },
                order: 170
            },
            {
                icon: 'icono-exportacion txt', title: 'TXT Vista',
                action: function ($event) {
                    var filename = $("#titulo").text() + ' (Vista)';
                    self.exportTo(gridApi.grid, uiGridExporterConstants.VISIBLE, uiGridExporterConstants.VISIBLE, ';', filename, 'txt', 'vista');
                },
                order: 180
            },
        ];
        return angular.copy(gridMenuCustomItems);
    }

    this.personalizarExportPDF = function (datosPDF, colPDF) {
        var pp = 0;
        var primeraFila = angular.copy(datosPDF[0]);
        for (var propiedad in primeraFila) {
            angular.forEach(colPDF, function (fila) {
                if (fila.columna === datosPDF[0][propiedad].text) fila.indice = pp;
            });
            pp++
        }
        datosPDF.shift();
        angular.forEach(datosPDF, function (fila) {
            angular.forEach(colPDF, function (fila2) {
                fila[fila2.indice] = self.exportPdfColumnLarge(fila2.col, fila[fila2.indice]);
            });
            // fila[3] = UtilsService.exportPdfColumnLarge($scope.colPregunta, fila[3]);
        });
        datosPDF.unshift(primeraFila);

    }

    this.autoajustarAltura = function (totalItems, paginationCurrentPage, paginationPageSize, className) {
        if (className == undefined) className = 'grid';
        var registrosAcutales = 0;
        var newHeight = 900;
        if (paginationCurrentPage > 1) {
            registrosAcutales = totalItems - ((paginationCurrentPage - 1) * paginationPageSize);
        } else {
            registrosAcutales = totalItems;
        }
        if (registrosAcutales < paginationPageSize) {
            newHeight = (registrosAcutales * 30) + 160;
        }

        var gridElem = angular.element(document.getElementsByClassName(className)[0]);

        if (gridElem.length > 0) {
            var viewports = angular.element(gridElem[0].getElementsByClassName('ui-grid-viewport'));

            angular.forEach(viewports, function (item, index) {
                angular.element(item).css('height', (newHeight - 123) + 'px');
            });
        }

        return angular.element(document.getElementsByClassName(className)[0]).css('height', newHeight + 'px');
    };

    //-------------Exportat PDF para columnas muy anchas-------------------------
    this.exportPdfColumnLarge = function (col, value) {
        // debugger
        var separador = "\n", i = 1;
        var numLetras = Math.floor(col.drawnWidth / 8);
        while (value.charAt(i * numLetras + i - 1)) {
            value = value.substr(0, i * numLetras + i - 1) + separador + value.substr(i * numLetras + i - 1);
            i++;
        }
        return value;
    }

    this.abrirRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    var enviar = mensaje;
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {

            });
    }

    this.getDefinicionesReportesEjecutivos = function () {

        var definiciones = {};

        //===== Definiciones de Encabezado============
        var getLogosEncabezado = function () {
            var logoMininterior = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAagAAABYCAIAAAAvNfQ6AAAACXBIWXMAAC4jAAAuIwF4pT92AAAGymlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDIgNzkuMTYwOTI0LCAyMDE3LzA3LzEzLTAxOjA2OjM5ICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOCAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDE4LTEyLTAzVDEyOjA0OjIyLTA1OjAwIiB4bXA6TW9kaWZ5RGF0ZT0iMjAxOC0xMi0wNVQxMzoyMTo0NS0wNTowMCIgeG1wOk1ldGFkYXRhRGF0ZT0iMjAxOC0xMi0wNVQxMzoyMTo0NS0wNTowMCIgZGM6Zm9ybWF0PSJpbWFnZS9wbmciIHBob3Rvc2hvcDpDb2xvck1vZGU9IjMiIHBob3Rvc2hvcDpJQ0NQcm9maWxlPSJzUkdCIElFQzYxOTY2LTIuMSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpmODQ2NjIxMC03OTE1LTc1NDItYjc2OC01NTI1YzE0NzZlMTciIHhtcE1NOkRvY3VtZW50SUQ9ImFkb2JlOmRvY2lkOnBob3Rvc2hvcDpiOTFjZTM0Ny1mNGYzLTMwNGEtOGQ3Yy1mYzU3MGJiNGIwODgiIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxZmM3YzkzMC01Y2VmLWNiNGQtOGEwOS0yNmU3MzQzZWE5ZGQiPiA8eG1wTU06SGlzdG9yeT4gPHJkZjpTZXE+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJjcmVhdGVkIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOjFmYzdjOTMwLTVjZWYtY2I0ZC04YTA5LTI2ZTczNDNlYTlkZCIgc3RFdnQ6d2hlbj0iMjAxOC0xMi0wM1QxMjowNDoyMi0wNTowMCIgc3RFdnQ6c29mdHdhcmVBZ2VudD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTggKFdpbmRvd3MpIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJzYXZlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDoxMGRhODhkMi1lMjY3LTJiNGUtOTJmOS1mOWMwMjdiMmZmMTEiIHN0RXZ0OndoZW49IjIwMTgtMTItMDVUMTM6MjE6NDUtMDU6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE4IChXaW5kb3dzKSIgc3RFdnQ6Y2hhbmdlZD0iLyIvPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6Zjg0NjYyMTAtNzkxNS03NTQyLWI3NjgtNTUyNWMxNDc2ZTE3IiBzdEV2dDp3aGVuPSIyMDE4LTEyLTA1VDEzOjIxOjQ1LTA1OjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOCAoV2luZG93cykiIHN0RXZ0OmNoYW5nZWQ9Ii8iLz4gPC9yZGY6U2VxPiA8L3htcE1NOkhpc3Rvcnk+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+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';
            var logoTodosPorUnNuevoPais = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAO0AAAAyCAYAAACwJVx1AAABN2lDQ1BBZG9iZSBSR0IgKDE5OTgpAAAokZWPv0rDUBSHvxtFxaFWCOLgcCdRUGzVwYxJW4ogWKtDkq1JQ5ViEm6uf/oQjm4dXNx9AidHwUHxCXwDxamDQ4QMBYvf9J3fORzOAaNi152GUYbzWKt205Gu58vZF2aYAoBOmKV2q3UAECdxxBjf7wiA10277jTG+38yH6ZKAyNguxtlIYgK0L/SqQYxBMygn2oQD4CpTto1EE9AqZf7G1AKcv8ASsr1fBBfgNlzPR+MOcAMcl8BTB1da4Bakg7UWe9Uy6plWdLuJkEkjweZjs4zuR+HiUoT1dFRF8jvA2AxH2w3HblWtay99X/+PRHX82Vun0cIQCw9F1lBeKEuf1UYO5PrYsdwGQ7vYXpUZLs3cLcBC7dFtlqF8hY8Dn8AwMZP/fNTP8gAAAAJcEhZcwAAFxIAABcSAWef0lIAAATzaVRYdFhNTDpjb20uYWRvYmUueG1wAAAAAAA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/PiA8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJBZG9iZSBYTVAgQ29yZSA1LjYtYzE0MiA3OS4xNjA5MjQsIDIwMTcvMDcvMTMtMDE6MDY6MzkgICAgICAgICI+IDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+IDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIiB4bWxuczpwaG90b3Nob3A9Imh0dHA6Ly9ucy5hZG9iZS5jb20vcGhvdG9zaG9wLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bXA6Q3JlYXRvclRvb2w9IkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE4IChXaW5kb3dzKSIgeG1wOkNyZWF0ZURhdGU9IjIwMTgtMTItMjFUMTA6MjQ6MTgtMDU6MDAiIHhtcDpNb2RpZnlEYXRlPSIyMDE4LTEyLTIxVDEwOjI1OjA2LTA1OjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDE4LTEyLTIxVDEwOjI1OjA2LTA1OjAwIiBkYzpmb3JtYXQ9ImltYWdlL3BuZyIgcGhvdG9zaG9wOkNvbG9yTW9kZT0iMyIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpiNDcxNGIyOC04MzYxLTIyNDktOWVjNi1jNTVkZDdmOWQ3MWYiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6YjQ3MTRiMjgtODM2MS0yMjQ5LTllYzYtYzU1ZGQ3ZjlkNzFmIiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6YjQ3MTRiMjgtODM2MS0yMjQ5LTllYzYtYzU1ZGQ3ZjlkNzFmIj4gPHhtcE1NOkhpc3Rvcnk+IDxyZGY6U2VxPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0iY3JlYXRlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDpiNDcxNGIyOC04MzYxLTIyNDktOWVjNi1jNTVkZDdmOWQ3MWYiIHN0RXZ0OndoZW49IjIwMTgtMTItMjFUMTA6MjQ6MTgtMDU6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE4IChXaW5kb3dzKSIvPiA8L3JkZjpTZXE+IDwveG1wTU06SGlzdG9yeT4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz4OObz+AAAo+UlEQVR4nO2dd4AU5d3HPzOzs/12726v9zvg6EgTpIgS7Io9WIg9Gl/LG2OLJcEaY0tiSzRRY4kFe4tdFAEFpPfO9d6295l5/3j27sAYAwgx5t2vHrc7O/PM7O58n1/7/p6T6ju1BsDNDxRZGTI7mmJcfM8GApEkDqvyfV/S/2tEo1EKCwsZOrSKeBwM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';
            var logoUnidad = 'data:image/jpeg;base64,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';
            var logosEncabezado = {
                margin: [20, 20, 20, 10],
                alignment: 'center',
                table: {
                    widths: ['*', '*', '*'],
                    body: [[{ image: logoMininterior, width: 100, margin: [0, 15, 0, 0], }, { image: logoTodosPorUnNuevoPais, width: 100 }, { image: logoUnidad, width: 100, margin: [0, 15, 0, 0], }]
                    ]
                }, layout: 'noBorders'
            }
            return logosEncabezado;
        };

        //=====Definiciones de Estilo================
        var fillColor = '#63002D';
        var getEstilos = function () {
            return {
                'tableHeader': {
                    fontSize: 6,
                    fillColor: fillColor,
                    color: 'white',
                    alignment: 'center',
                },
                'tableBody': {
                    fontSize: 6,
                    fillColor: fillColor,
                    alignment: 'center',
                },
                'tableHeader1': {
                    bold: true,
                    fontSize: 10,
                    color: '#FFF5BA',
                    alignment: 'center',
                    margin: [50, 0, 50, 0]
                },
                'tableHeader2': {
                    bold: true,
                    fontSize: 9,
                    color: 'white',
                    alignment: 'center',
                },
                'tableHeader3': {
                    fontSize: 7,
                    color: 'white',
                    alignment: 'center',
                },
                'image': {
                    width: 150,
                    height: 150,
                },
                'tableFooter': {
                    fillColor: '#008080',
                    color: 'white',
                    alignment: 'center',
                },
                'fila-titulo-1': {
                    fillColor: '#FDECDB',
                    color: '#7C2828',
                    alignment: 'center',
                },
                'fila-titulo-2': {
                    fillColor: '#FFF',
                    color: 'gray',
                    alignment: 'center',
                    fontSize: 6,
                },
                'fila-titulo-3': {
                    fillColor: '#FFF',
                    color: 'gray',
                    alignment: 'center',
                    fontSize: 6,
                },
                'fila-departamento': {
                    margin: [150, 0, 150, 0],
                    fontSize: 9,
                    alignment: 'center',
                    fillColor: '#D2D2D2',
                    color: '#7C2828',
                },
                'fila-pregunta': {
                    fillColor: '#E6E6E6',
                    color: '#7C2828',
                },
                'fila-encabezado-tabla': {
                    fillColor: '#7C2828',
                    color: 'white',
                    alignment: 'center',
                    bold: true,
                },
                'fila-tabla': {
                    alignment: 'center',
                },
                'fila-seccion': {
                    fontSize: 7,
                    fillColor: '#FDECDB',
                    color: '#7C2828',
                    alignment: 'center',
                    bold: true,
                },
                'reporte-subtitulo': {
                    bold: true,
                    color: '#7C2828',
                    fontSize: 9,
                },
            }
        }

        definiciones.logosEncabezado = getLogosEncabezado();
        definiciones.estilos = getEstilos();
        definiciones.colorInstitucional = fillColor;

        return definiciones;
    }

    this.getLayout = function (tipo) {

        switch (tipo) {
            case 'header':
                var layout = getLayoutHeader();
                break;

            case 'tabla':
                var layout = getLayoutTabla();
                break;

            case 'tabla2':
                var layout = getLayoutTabla2();
                break;

            case 'imagenes':
                var layout = getLayoutImagenes();
                break;

            case 'preguntasRespuestas':
                var layout = getLayoutpreguntasRespuestas();
                break;

        }

        function getLayoutHeader() {
            return {
                hLineWidth: function () {
                    return 0.5;
                },
                vLineWidth: function () {
                    return 0;
                },
                hLineColor: function () {
                    return 'white';
                },
                vLineColor: function () {
                    return 'white';
                }
            };
        };

        function getLayoutTabla() {
            return {
                hLineWidth: function () {
                    return 1;
                },
                vLineWidth: function () {
                    return 0;
                },
                hLineColor: function () {
                    return '#BDBDBD';
                },
                vLineColor: function () {
                    return 'white';
                }
            };
        };

        function getLayoutTabla2() {
            return {
                hLineWidth: function () {
                    return 0.5;
                },
                vLineWidth: function () {
                    return 0.5;
                },
                hLineColor: function () {
                    return 'black';
                },
                vLineColor: function () {
                    return 'black';
                }
            };
        };

        function getLayoutImagenes() {
            return {
                hLineWidth: function () {
                    return 0.1;
                },
                vLineWidth: function () {
                    return 0.1;
                },
                hLineColor: function () {
                    return 'white';
                },
                vLineColor: function () {
                    return 'white';
                }
            };
        };

        function getLayoutpreguntasRespuestas() {
            return {
                hLineWidth: function () {
                    return 0.5;
                },
                vLineWidth: function () {
                    return 0.0;
                },
                hLineColor: function () {
                    return 'gray';
                },
                vLineColor: function () {
                    return 'gray';
                }
            };
        };

        return layout;
    }

    this.getDatosUsuarioAutenticado = function () {
        var respuesta = function () {
            debugger
            var deferred = $q.defer();
            var autenticacion = authService.authentication;
            var url = '/api/Usuarios/Usuarios/BuscarXUsuario';
            var registro = { UserName: autenticacion.userName };
            var datosUsuario = {};
            var servCall = APIService.saveSubscriber(registro, url);
            servCall.then(function (response) {
                debugger;
                if (response.data[0]) {
                    datosUsuario = response.data[0];
                }
                deferred.resolve(datosUsuario)
            }, function (error) {
                deferred.reject(error);
            });

            return deferred.promise;
        }


        return {
            respuesta: respuesta
        };
    };

    this.getDatosFormatados = function (datos, tipo) {

        var resultado;

        switch (tipo) {
            case 'HTML':
                resultado = obtenerDatosFormatadosHTML(datos);
                break
            case 'PDF':
                resultado = obtenerDatosFormatadosPDF(datos);
                break
            default:
                break
        }

        return resultado;

        //Funciones
        function obtenerDatosFormatadosHTML(datos) {
            var idSeccionAnterior = null;

            for (var i = 0; i < datos.length; i++) {

                switch (datos[i].codigotipopregunta) {
                    case 'MONEDA':
                        datos[i].respuesta = datos[i].respuesta.splice(0, 0, "$ ");
                        break;
                    default:
                        break
                }

                if (datos[i].codigoseccion == idSeccionAnterior) {
                    datos[i].nombreseccion = null;
                }

                idSeccionAnterior = datos[i].codigoseccion;
            }

            //Datos de la paginación
            var resultado = {
                paginacion: {
                    totalItems: datos.length,
                    paginaActual: 1,
                    itemsPorPagina: 25,// $scope.viewby;
                    tamanhoMaximo: 20, //Number of pager buttons to show
                },
                datos: datos
            }
            return resultado;
        }
    }

    this.funcionesReportes = function (funcion, codigos, datos, maxCol, orientacionPagina) {
        var resultado;
        var index;
        orientacionPagina === 'horizontal' ? index = 284 : index = 85

        switch (funcion) {
            case 'obtenerPreguntasXCodigo':
                var codigosPreguntas = codigos;
                resultado = obtenerPreguntasXCodigo(codigosPreguntas, datos)
                break;
            case 'obtenerPreguntasXCodigo2':
                var codigosPreguntas = codigos;
                resultado = obtenerPreguntasXCodigo2(codigosPreguntas, datos)
                break;
            case 'obtenerRepuestaTablaXCodigo':
                var tabla = codigos;
                resultado = obtenerRepuestaTablaXCodigo(tabla, datos);
                break;
            case 'organizarDatos':
                var datosFormatadosPDF = datos;
                organizarDatos(datosFormatadosPDF);
                break;
            default:
                break;

        }

        //-----------------Obtener los códigos de pregunta---------------
        function obtenerPreguntasXCodigo(codigosPreguntas, datos) {

            var retorno = [];
            var pregunta;
            var respuesta;
            for (var i = 0; i < codigosPreguntas.length; i++) {
                for (var j = 0; j < datos.length; j++) {
                    if (codigosPreguntas[i] === datos[j].codigopregunta) {
                        if (datos[j].descripcionpregunta.length > index) {
                            datos[j].descripcionpregunta = insertarEspacios(datos[j].descripcionpregunta, index);
                        }
                        if (datos[j].respuesta.length === 0 || datos[j].respuesta === null) datos[j].respuesta = ' ';
                        pregunta = [{ text: datos[j].descripcionpregunta + ' - ' + datos[j].codigopregunta, style: 'fila-pregunta', colSpan: maxCol }];
                        respuesta = [{ text: datos[j].respuesta, colSpan: maxCol }];
                        //Adicionar las columnas vacías
                        for (var k = 1; k < maxCol; k++) {
                            pregunta.push({ text: '' })
                            respuesta.push({ text: '' })
                        }
                        //Se adiciona a respuesta
                        retorno.push(pregunta);
                        retorno.push(respuesta);
                        break;
                    }
                }
            }
            return retorno;
        }

        //-----------------Obtener los códigos de pregunta 2---------------
        function obtenerPreguntasXCodigo2(codigosPreguntas, datos) {

            var retorno = [];
            var pregunta;
            var respuesta;
            for (var i = 0; i < codigosPreguntas.length; i++) {
                for (var j = 0; j < datos.length; j++) {
                    if (codigosPreguntas[i] === datos[j].codigopregunta) {
                        if (datos[j].descripcionpregunta.length > index) {
                            datos[j].descripcionpregunta = insertarEspacios(datos[j].descripcionpregunta, index);
                        }
                        if (datos[j].respuesta === '') datos[j].respuesta = ' ';
                        pregunta = [{ text: datos[j].descripcionpregunta + ' - ' + datos[j].codigopregunta, style: 'fila-pregunta', colSpan: maxCol / 2 }];
                        respuesta = { text: datos[j].respuesta, colSpan: maxCol / 2 };
                        //Adicionar las columnas vacías
                        for (var k = 1; k < maxCol / 2 ; k++) {
                            pregunta.push({ text: '' })
                        }
                        pregunta.push(respuesta)
                        for (var k = (maxCol / 2) + 1; k < maxCol; k++) {
                            pregunta.push({ text: '' })
                        }
                        //Se adiciona a respuesta
                        retorno.push(pregunta);
                        break;
                    }
                }
            }
            return retorno;
        }

        //----------OBTENER CÓDIGOS DE LAS TABLAS-------------
        function obtenerRepuestaTablaXCodigo(tabla, datos) {
            var celda;
            var celdaString;
            try {
                //Recorremos la tabla
                for (var i = 0; i < tabla.length; i++) {
                    for (var j = 0; j < tabla[i].length; j++) {
                        celda = tabla[i][j].text;
                        if (typeof (celda) == 'number') {
                            celdaString = celda.toString();
                            //Recorremos los datos donde esté el valor de la celda
                            for (var k = 0; k < datos.length; k++) {
                                if (datos[k].codigopregunta === celdaString) {
                                    if (datos[k].respuesta.length === 0 || datos[k].respuesta === null) {
                                        tabla[i][j].text = ' ';
                                    } else
                                        if (!isNaN(datos[k].respuesta)) {
                                            //if (angular.isNumber(datos[k].respuesta)) {
                                            tabla[i][j].text = datos[k].respuesta;
                                        } else {
                                            var date = new Date(datos[k].respuesta);
                                            if (date instanceof Date && !isNaN(date.valueOf())) {
                                                tabla[i][j].text = new Date(datos[k].respuesta).toLocaleDateString();
                                            } else {
                                                tabla[i][j].text = datos[k].respuesta;
                                            }
                                        }
                                    break;
                                } else {
                                    tabla[i][j].text = ' ';
                                }
                            }
                        }
                    }
                }
            } catch (e) {

            }
        }

        //----------organizar datos
        function organizarDatos(datosFormatadosPDF) {
            for (var i = 0; i < columnas.length; i++) {
                datosFormatadosPDF.push(columnas[i]);
            }

        }

        function insertarColumnas(columnasOriginal, ColumnasXInsertar, index) {
            var long = ColumnasXInsertar.length;
            for (var i = 0; i < long; i++) {
                columnasOriginal.splice(index, 0, ColumnasXInsertar[i]);
            }
        }

        //----------UTILIDADES------------------------------
        function insertarEspacios(texto, index) {
            String.prototype.splice = function (idx, rem, str) {
                return this.slice(0, idx) + str + this.slice(idx + Math.abs(rem));
            };

            var long = texto.length;
            var i = 1;
            do {
                texto = texto.splice(index, 0, " ");
                i += 1;
                index = index * i;
            } while (index < long);

            return texto;
        }

        return resultado;
    }
});