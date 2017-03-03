$(document).ready(function() {
    tmx.vivablast.stockoutact.init();
});

(function($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || { };

    tmx.vivablast.stockoutact = {
        init: function() {
            $('#loading-indicator').hide();
            $('#Mode').val("StockOut");
            $('#vMRF').tooltip({ 'trigger': 'focus', 'title': "Mrf can multible, divide by ' ; '" });
            $('#vMRF').val(0);
            tmx.vivablast.stockoutact.registerEventCreateForm();
        },

        registerEventCreateForm: function () {
            var form = $('#stock-out-create-form');
            searchStockFunction.init();

            $('#ProjectName').val($('#vProjectID').val());

            $('#vProjectID').on('change', function (e) {
                $('#ProjectName').val($('#vProjectID').val());
            });

            $('#ProjectName').on('change', function (e) {
                $('#vProjectID').val($('#ProjectName').val());
            });

            $('#iStore').on('change', function (e) {
                tmx.vivablast.stockoutact.LoadPeCondition();
            });

            $('#StockCode', form).keydown(function () {
                clearVal();
            });
            
            $('#StockCode', form).blur(function () {
                if ($(this).val().length > 5) {
                    tmx.vivablast.stockoutact.loadStockInformation(form);
                }
            });
            
            $('#StockCode', form).bind("enterKey", function (e) {
                if ($(this).val().length > 5) {
                    tmx.vivablast.stockoutact.loadStockInformation(form);
                }
            });
            
            $('#StockCode', form).keyup(function (e) {
                if (e.keyCode == 13) {
                    $(this).trigger("enterKey");
                }
            });

            $("#StockCode").on('change keyup paste', function () {
                if ($(this).val().length > 5) {
                    tmx.vivablast.stockoutact.loadStockInformation(form);
                }
            });

            $('.btnAddItem', form).off('click').on('click', function () {
                var check = tmx.vivablast.stockoutact.checkValidateAddStock(form);
                if (check == true) {
                    var htmls = '<tr class="vbcolum"> ' +
                                    '<td class="center">' +
                                        '<button type="button" class="btnEdit btn btn-xs btn-primary"><span class="glyphicon glyphicon-edit"></span>Edit</button>' +
                                        '<button type="button" class="btnDelete btn btn-xs btn-danger marginleft2"><span class="glyphicon glyphicon-remove"></span>Delete</button>' +
                                        '<input type="hidden" value="0" class="DetailId" />' +
                                        '<input type="hidden" value="0" class="ModifyQty" />' +
                                        '<input type="hidden" value="' + $('#StockId').val() + '" class="StockId" />' +
                                    '</td>' +
                                    '<td class="center StockCode"> ' + $('#StockCode').val() + '</td> ' +
                                    '<td class="center StockName"> ' + $('#lblStockName').text() + '</td> ' +
                                    '<td class="center Quantity"> ' + $('#bQuantity').val() + '</td> ' +
                                    '<td class="center Remark"> ' + $('#Description').val() + '</td> ' +
                                '</tr> ';
                   
                    if ($("#LstItem tr").hasClass("vbcolum")) {
                        $(htmls).insertAfter($('#LstItem tbody tr:last-child'));
                    }
                    else {
                        $('#LstItem tbody').append(htmls);
                    }
                    $('.btnDelete').off("click").on("click", function() {
                        var id = $(this).closest('tr').find('.DetailId').val();
                        if (id != 0) {
                            var temp = $('#hidDeleteItemDetail').val();
                            if (temp.length == 0) {
                                $('#hidDeleteItemDetail').val(id);
                            }
                            else {
                                $('#hidDeleteItemDetail').val(temp + ';' + id);
                            }
                        }
                        $(this).closest('tr').remove();
                        tmx.vivablast.stockoutManager.EnableDDL();
                    });
                    $('.btnEdit').off('click').on('click', function() {
                        $('.editing button').removeAttr('disabled');
                        $('.editing').removeClass('editing');

                        $(this).closest('tr').addClass('editing');
                        $('#StockId').val($('.editing .StockId').val());
                        $('#StockCode').val($('.editing .StockCode').text().trim());
                        tmx.vivablast.stockoutact.loadStockInformation();
                        $('#bQuantity').val($('.editing .Quantity').text().trim());
                        $('#Description').val($('.editing .Remark').text().trim());
                        $('.btnAddItem').hide();
                        $('.btnUpdateItem').show();
                        $('.editing button').attr('disabled', 'disabled');
                    });
                    $('#StockCode').val('');
                    tmx.vivablast.stockoutact.clearStockInformation();
                    tmx.vivablast.stockoutact.DisableDDL();
                }
            });
            
            $('.btnEdit').off("click").on("click", function () {
                $('.editing button').removeAttr('disabled');
                $('.editing').removeClass('editing');

                $(this).closest('tr').addClass('editing');
                $('#StockId').val($('.editing .StockId').val());
                $('#StockCode').val($('.editing .StockCode').text().trim());
                tmx.vivablast.stockoutact.loadStockInformation();
                $('#bQuantity').val($('.editing .Quantity').text().trim());
                $('#Description').val($('.editing .Remark').text().trim());
                $('.btnAddItem').hide();
                $('.btnUpdateItem').show();
                $('.editing button').attr('disabled', 'disabled');
            });

            $('.btnDelete').off("click").on("click", function () {
                var id = $(this).closest('tr').find('.DetailId').val();
                if (id != 0) {
                    var temp = $('#hidDeleteItemDetail').val();
                    if (temp.length == 0) {
                        $('#hidDeleteItemDetail').val(id);
                    }
                    else {
                        $('#hidDeleteItemDetail').val(temp + ';' + id);
                    }
                }
                $(this).closest('tr').remove();
                tmx.vivablast.stockoutManager.EnableDDL();
            });
            
            $('.btnUpdateItem').off('click').on('click', function () {
                if ($.trim($('#StockCode', form).val()) == "") {
                    clearVal();
                    $('#StockCode', form).after('<label id="validate" class="red">Stock Code not empty.</label>');
                    return false;
                }
                if ($.trim($('#lblStockName', form).text()) == "") {
                    clearVal();
                    $('#lblStockName', form).after('<label id="validate" class="red">Stock Code incorrect.</label>');
                    return false;
                }
                if ($.trim($('#bQuantity', form).val()) == "") {
                    clearVal();
                    $('#bQuantity', form).after('<label id="validate" class="red">Quantity not empty</label>');
                    return false;
                }
                if ($.trim($('#bQuantity', form).val()) == "0") {
                    clearVal();
                    $('#bQuantity', form).after('<label id="validate" class="red">Quantity not equal 0</label>');
                    return false;
                }
                else {
                    $('.editing .StockId').val($('#StockId').val());
                    $('.editing .StockCode').text($('#StockCode').val());
                    $('.editing .StockName').text($('#lblStockName').text());
                    $('.editing .Quantity').text($('#bQuantity').val());
                    $('.editing .Description').text($('#Description').val());
                   tmx.vivablast.stockoutact.clearStockInformation();
                    $('#StockCode', form).val('');
                    $('.editing button').removeAttr('disabled');
                    $('.editing').removeClass('editing');
                    $('.btnUpdateItem').hide();
                    $('.btnAddItem').show();
                }
            });
            
            $('#btnSave').off('click').on('click', function () {
                var check = tmx.vivablast.stockoutact.checkValidateSaveStockOut();
                if (check == true) {
                    clearVal();
                    var arrDetails = [];
                    $('#LstItem .vbcolum').each(function () {
                        arrDetails.push({
                            bAssignningStockID: $(this).find('.DetailId').val(),
                            vStockID: $(this).find('.StockId').val(),
                            vProjectID: $('#vProjectID').val(),
                            bQuantity: $(this).find('.Quantity').text().trim(),
                            vMRF: $('#vMRF').val(),
                            Description: $(this).find('.Remark').text().trim(),
                            FromStore: $('#FromStore').val(),
                            DateStockOut: $('#dDateStockOut').val(),
                        });
                    });
                    var data = {
                        V3: check,
                        LoginId: $('#iLogin').val(),
                        AssignStockItemList: arrDetails,
                        LstDeleteDetailItem: $('#hidDeleteItemDetail').val(),
                    };
                    SaveEntity(data, 0);
                }
            });
        },

        loadStockInformation: function (form) {
            if ($('#StockCode', form).val() != "" && $('#StockCode', form).val().length > 5) {
                $.ajax({
                    url: "/Ajax/GetStockInformationByCode",
                    type: "POST",
                    data: {
                        code: $('#StockCode', form).val(),
                        store: $('#FromStore', form).val()
                    },
                    success: function (stock) {
                        $('#StockId', form).val(stock.Id);
                        $('#bQuantity', form).removeAttr('disabled');
                        $('#lblStockName', form).text(stock.Stock_Name);
                        $('#lblStockType', form).text(stock.Type);
                        if (stock.Quantity != null) {
                            $('#lblStockQty', form).text(stock.Quantity);
                        }
                        else {
                            $('#lblStockQty', form).text(0);
                        }
                        if (stock.Unit != null) {
                            $('#lblStockUnit', form).text(stock.Unit);
                        }
                        if (stock.Part_No != null) {
                            $('#lblPartNo', form).text(stock.Part_No);
                        }
                        if (stock.Ral_No != null) {
                            $('#lblRalNo', form).text(stock.Ral_No);
                        }
                        if (stock.Color != null) {
                            $('#lblColor', form).text(stock.Color);
                        }
                        loadPictureStock(stock.Id);
                    },
                    error: function () {
                        tmx.vivablast.stockoutact.clearStockInformation(form);
                    }
                });
            }
        },

        checkValidateAddStock: function (form) {
            if ($('#FromStore').val() == "") {
                clearVal();
                $('#FromStore').after('<label id="validate" class="red">Please select store.</label>');
                return false;
            }
            if ($('#vProjectID').val() == "") {
                clearVal();
                $('#vProjectID').after('<label id="validate" class="red">Please select project.</label>');
                return false;
            }
            if ($.trim($('#StockCode', form).val()) == "") {
                clearVal();
                $('#StockCode', form).after('<label id="validate" class="red">Stock Code not empty.</label>');
                return false;
            }
            if ($.trim($('#lblStockName', form).text()) == "") {
                clearVal();
                $('#lblStockName', form).after('<label id="validate" class="red">Stock Code incorrect.</label>');
                return false;
            }
            var receivedQty = $.trim($('#bQuantity').val());
            if (receivedQty == "" || receivedQty == "0") {
                clearVal();
                $('#bQuantity').after('<label id="validate" class="red">Quantity incorrect.</label>');
                return false;
            }
            if (parseFloat($('#bQuantity').val()) > parseFloat($('#lblStockQty').text().trim())) {
                clearVal();
                $('#bQuantity').after('<label id="validate" class="red">Quantity greatest store quantity: ' + parseFloat($('#lblStockQty').text().trim()) +'</label>');
                return false;
            }
            var checkExist = true;
            // Check exist on list
            $(".StockId").each(function () {
                if ($.trim($('#StockId').val()) == $(this).text()) {
                    checkExist = false;
                }
            });

            if (checkExist != true) {
                clearVal();
                $('.btnAddItem').after('<label id="validate" class="red" style="margin-left:10px;">This stock exist.</label>');
                return false;
            }
            return true;
        },

        checkValidateSaveStockOut: function () {
            if ($('#vProjectID').val() == "") {
                clearVal();
                $('#vProjectID').after('<label id="validate" class="red">Please select project.</label>');
                return false;
            }
            if (typeof $("#LstItem .vbcolum .StockId").val() === "undefined") {
                $('.alert-danger').show();
                return false;
            }
            return true;
        },

        clearStockInformation: function (form) {
            $('#lblStockName', form).text('');
            $('#lblStockType', form).text('');
            $('#lblStockUnit', form).text('');
            $('#lblPartNo', form).text('');
            $('#lblRalNo', form).text('');
            $('#lblColor', form).text('');
            $('#StockId', form).val('');
            $('#bQuantity').val('');
            $('#Description').val('');
            clearVal();
        },

        DisableDDL: function () {
            $('#FromStore').attr('disabled', 'disabled');
            $('#vProjectID').attr('disabled', 'disabled');
            $('#ProjectName').attr('disabled', 'disabled');
        },

        EnableDDL: function () {
            if ($('#LstItem tr').hasClass("vbcolum") == false) {
                $('#FromStore').removeAttr('disabled');
                $('#vProjectID').removeAttr('disabled');
                $('#ProjectName').removeAttr('disabled');
            }
        },
    };
})(jQuery, window.tmx = window.tmx || { });