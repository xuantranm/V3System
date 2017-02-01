$(document).ready(function() {
    tmx.vivablast.stockact.init();
});

(function($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || { };

    tmx.vivablast.stockact = {
        init: function(uid) {
            $('#loading-indicator').hide();
            tmx.vivablast.stockact.registerEventCreateForm(uid);
            
            //$("#vStockID").autocomplete({
            //    source: "/Stock/ListCode?term" + $("#vStockID").val(),
            //});
            
            $("#vStockName").autocomplete({
                source: "/Stock/ListName?term" + $("#vStockName").val(),
            });
            
            $('#iType').on('change', function (e) {
                var typeId = 0;
                if ($(this).val() > 0) {
                    $('#Type').val($("option:selected", this).text());
                    console.log($('#Type').val());
                    typeId = $('#iType').val();
                } else {
                    $('#Type').val('');
                }

                tmx.vivablast.stockact.loadStock(typeId,0);
                tmx.vivablast.stockact.loadCategory(typeId);
                tmx.vivablast.stockact.loadUnit(typeId);
                //tmx.vivablast.stockact.loadLabel(typeId);
            });

            $('#bCategoryID').on('change', function (e) {
                if ($(this).val() > 0) {
                    $('#Category').val($("option:selected", this).text());
                } else {
                    $('#Category').val('');
                }
            });

            $('#bUnitID').on('change', function (e) {
                if ($(this).val() > 0) {
                    
                    $('#Unit').val($("option:selected", this).text());
                } else {
                    $('#Unit').val('');
                }
            });

            $('#bPositionID').on('change', function (e) {
                if ($(this).val() > 0) {
                    $('#Position').val($("option:selected", this).text());
                } else {
                    $('#Position').val('');
                }
            });
        },

        loadStock: function (typeId, categoryId) {
            var url = "/Stock/LoadStockCodeByType";
            $.ajax({
                url: url,
                data: { type: typeId, category: categoryId },
                cache: false,
                type: "POST",
                success: function (data) {
                    $("#vStockID").val(data);
                },
                error: function () {
                    alert("Error: Can't load Stock Code.Please contact Administrator support.");
                }
            });
        },

        loadCategory: function (typeId) {
            var url = "/Stock/LoadCategoryByType";
            $.ajax({
                url: url,
                data: { type: typeId },
                cache: false,
                type: "POST",
                success: function (data) {
                    var markup = "<option value=''>Select</option>";
                    for (var x = 0; x < data.length; x++) {
                        markup += "<option value=" + data[x].Value + ">" + data[x].Text + "</option>";
                    }
                    $("#bCategoryID").html(markup);
                    $("#bCategoryID").trigger("chosen:updated");
                },
                error: function () {
                    alert("Error: Can't load Category Data.Please contact Administrator support.");
                }
            });
        },
        
        loadUnit: function (typeId) {
            var url = "/Stock/LoadUnitByType";
            $.ajax({
                url: url,
                data: { type: typeId },
                cache: false,
                type: "POST",
                success: function (data) {
                    var markup = "<option value=''>Select</option>";
                    for (var x = 0; x < data.length; x++) {
                        markup += "<option value=" + data[x].Value + ">" + data[x].Text + "</option>";
                    }
                    $("#bUnitID").html(markup);
                    $("#bUnitID").trigger("chosen:updated");
                },
                error: function () {
                    alert("Error: Can't load Category Data.Please contact Administrator support.");
                }
            });
        },
        
        //loadLabel: function (typeId) {
        //    var url = "/Stock/LoadLabelByType";
        //    $.ajax({
        //        url: url,
        //        data: { type: typeId },
        //        cache: false,
        //        type: "POST",
        //        success: function (data) {
        //            var markup = "<option value=''>Select</option>";
        //            for (var x = 0; x < data.length; x++) {
        //                markup += "<option value=" + data[x].Value + ">" + data[x].Text + "</option>";
        //            }
        //            $("#bLabelID").html(markup);
        //            $("#bLabelID").trigger("chosen:updated");
        //        },
        //        error: function () {
        //            alert("Error: Can't load Category Data.Please contact Administrator support.");
        //        }
        //    });
        //},
        
        registerEventCreateForm: function() {
           $('#btnSave').off('click').on('click', function() {
                var check = tmx.vivablast.stockact.checkValidateSaveStock();
                var id = 0;
                if ($('#Id').val() !== "") {
                    id = $('#Id').val();
                }
                if (check == true) {
                    clearVal();
                    var dataV3 = {
                        V3: check,
                        LoginId: $('#iLogin').val(),
                        CheckName: $('#hidCheckName').val(),
                        CheckCode: $('#hidCheckCode').val(),
                        Stock: {
                            Id: id,
                            vStockID: $('#vStockID').val(),
                            vStockName: $('#vStockName').val(),
                            iType: $('#iType').val(),
                            bCategoryID: $('#bCategoryID').val(),
                            vBrand: $('#vBrand').val(),
                            vAccountCode: $('#vAccountCode').val(),
                            bUnitID: $('#bUnitID').val(),
                            bPositionID: $('#bPositionID').val(),
                            //bLabelID: $('#bLabelID').val(),
                            bWeight: $('#bWeight').val(),
                            vRemark: $('#vRemark').val(),
                            RalNo: $('#RalNo').val(),
                            ColorName: $('#ColorName').val(),
                            PartNo: $('#PartNo').val(),
                            PartNoFor: $('#PartNoFor').val(),
                            PartNoMiniQty: $('#PartNoMiniQty').val(),
                            SubCategory: $('#SubCategory').val(),
                            Timestamp: $('#Timestamp').val(),
                            Type: $('#Type').val(),
                            Category: $('#Category').val(),
                            Unit: $('#Unit').val(),
                            Position: $('#Position').val(),
                        }
                    };
                    
                    $.ajax({
                        url: $('#hidSaveUrl').val(),
                        dataType: 'json',
                        contentType: 'application/json',
                        type: 'POST',
                        data: ko.toJSON(dataV3),
                        success: function (response) {
                            if (response.result === $('#hidSuccess').val()) {
                                if (id > 0) {
                                    openYesNoDialog({
                                        sectionTitle: "Save Successful!",
                                        title: "Yes: go to list page.<br>No: stay this page.",
                                        data: '',
                                        yesCallback: function () {
                                            var controller = $('#controller').val().toLowerCase();
                                            window.location.href = 'http://' + window.location.host + '/' + controller;
                                        },
                                        noCallback: function () {
                                            location.reload();
                                        }
                                    });
                                } else {
                                    openYesNoDialog({
                                        sectionTitle: "Save Successful!",
                                        title: "Yes: add PICTURE, FILE.<br>No: List page.",
                                        data: '',
                                        yesCallback: function () {
                                            var controller = $('#controller').val().toLowerCase();
                                            window.location.href = 'http://' + window.location.host + '/' + controller + '/Create/' + response.id;
                                        },
                                        noCallback: function () {
                                            var controller = $('#controller').val().toLowerCase();
                                            window.location.href = 'http://' + window.location.host + '/' + controller;
                                        }
                                    });
                                    
                                }
                            } else if (response.result == $('#hidDuplicateCode').val()) {
                                clearVal();
                                openYesNoDialog({
                                    sectionTitle: "Error: Code is used",
                                    title: "Yes: go to list page.<br>No: stay this page.",
                                    data: '',
                                    yesCallback: function () {
                                        var controller = $('#controller').val().toLowerCase();
                                        window.location.href = 'http://' + window.location.host + '/' + controller;
                                        //window.location = '/login/signout';
                                        //window.history.back();
                                    },
                                    noCallback: function () {
                                    }
                                });
                            } else if (response.result == $('#hidDuplicate').val()) {
                                clearVal();
                                openYesNoDialog({
                                    sectionTitle: "Error: Name is used",
                                    title: "Yes: go to list page.<br>No: stay this page.",
                                    data: '',
                                    yesCallback: function () {
                                        var controller = $('#controller').val().toLowerCase();
                                        window.location.href = 'http://' + window.location.host + '/' + controller;
                                    },
                                    noCallback: function () {
                                    }
                                });
                            } else if (response.result === $('#hidDataJustChanged').val()) {
                                clearVal();
                                openYesNoDialog({
                                    sectionTitle: "Error: Data changed by another.",
                                    title: "Yes: go previous page.<br>No: refresh new data",
                                    data: '',
                                    yesCallback: function () {
                                        var controller = $('#controller').val().toLowerCase();
                                        window.location.href = 'http://' + window.location.host + '/' + controller;
                                    },
                                    noCallback: function () {
                                        location.reload();
                                    }
                                });
                            } else {
                                clearVal();
                                openYesNoDialog({
                                    sectionTitle: "System error. Contact IT to support.",
                                    title: "Yes: go to list page.<br>No: stay this page.",
                                    data: '',
                                    yesCallback: function () {
                                        var controller = $('#controller').val().toLowerCase();
                                        window.location.href = 'http://' + window.location.host + '/' + controller;
                                    },
                                    noCallback: function () {
                                    }
                                });
                            }
                        }
                    });
                }
            });
        },

        checkValidateSaveStock: function() {
            if ($.trim($('#iType').val()) == "") {
                clearVal();
                $('#iType').after('<div class="clearboth"></div><label id="validate" class="red">Please select Type.</label>');
                return false;
            }
            if ($.trim($('#vStockID').val()) == "") {
                clearVal();
                $('#vStockID').after('<div class="clearboth"></div><label id="validate" class="red">Stock Id can\'t empty.</label>');
                return false;
            }
            if ($.trim($('#vStockName').val()) == "") {
                clearVal();
                $('#vStockName').after('<div class="clearboth"></div><label id="validate" class="red">Stock Name can\'t empty.</label>');
                return false;
            }
            if ($.trim($('#bUnitID').val()) == "") {
                clearVal();
                $('#bUnitID').after('<div class="clearboth"></div><label id="validate" class="red">Please select Unit.</label>');
                return false;
            }
            return true;
        }
    };
})(jQuery, window.tmx = window.tmx || { });