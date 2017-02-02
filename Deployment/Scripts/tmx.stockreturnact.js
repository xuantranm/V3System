$(document).ready(function() {
    tmx.vivablast.stockreturnact.init();
});

(function($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || { };

    tmx.vivablast.stockreturnact = {
        init: function() {
            $('#loading-indicator').hide();
            $('#Mode').val("StockReturn");
            tmx.vivablast.stockreturnact.registerEventCreateForm();
        },

        registerEventCreateForm: function () {
            var form = $('#stock-return-create-form');
            searchStockFunction.init();

            $('#ProjectName').val($('#vProjectID').val());

            $('#vProjectID').on('change', function (e) {
                $('#ProjectName').val($('#vProjectID').val());
            });

            $('#ProjectName').on('change', function (e) {
                $('#vProjectID').val($('#ProjectName').val());
            });

            $('#StockCode', form).keydown(function () {
                clearVal();
            });
            
            $('#StockCode', form).blur(function () {
                if ($(this).val().length > 5) {
                    tmx.vivablast.stockreturnact.loadStockInformation(form);
                }
            });
            
            $('#StockCode', form).bind("enterKey", function (e) {
                if ($(this).val().length > 5) {
                    tmx.vivablast.stockreturnact.loadStockInformation(form);
                }
            });
            
            $('#StockCode', form).keyup(function (e) {
                if (e.keyCode == 13) {
                    $(this).trigger("enterKey");
                }
            });

            $("#StockCode").on('change keyup paste', function () {
                if ($(this).val().length > 5) {
                    tmx.vivablast.stockreturnact.loadStockInformation(form);
                }
            });

            $('.btnAddItem', form).off('click').on('click', function () {
                var check = tmx.vivablast.stockreturnact.checkValidateAddStock(form);
                if (check == true) {
                    var htmls = '<tr class="vbcolum">' +
                                        '<td class="center">' +
                                            '<button type="button" class="btnEdit btn btn-xs btn-primary"><span class="glyphicon glyphicon-edit"></span>Edit</button>' +
                                            '<button type="button" class="btnDelete btn btn-xs btn-danger marginleft2"><span class="glyphicon glyphicon-remove"></span>Delete</button>' +
                                            '<input type="hidden" value="@item.Id" class="DetailId" />' +
                                            '<input type="hidden" value="' + $('#StockId').val() + '" class="StockId" />' +
                                            '<input type="hidden" value="0" class="ModifyQty" />' +
                                            '<input type="hidden" value="' + $('#bQuantity').val() + '" class="hidQuantity" />' +
                                        '</td>' +
                                        '<td class="center StockCode"> ' + $('#StockCode').val() + '</td> ' +
                                        '<td class="center StockName"> ' + $('#lblStockName').text() + '</td> ' +
                                        '<td class="center Quantity"> ' + $('#bQuantity').val() + '</td> ' +
                                        '<td class="center Remark">' +$('#vCondition').val()+ '</td>' +
                                    '</tr>';
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
                        tmx.vivablast.stockreturnact.EnableDDL();
                    });
                    $('.btnEdit').off('click').on('click', function() {
                        $('.editing button').removeAttr('disabled');
                        $('.editing').removeClass('editing');

                        $(this).closest('tr').addClass('editing');
                        $('#StockId').val($('.editing .StockId').val());
                        $('#StockCode').val($('.editing .StockCode').text().trim());
                        tmx.vivablast.stockreturnact.loadStockInformation();
                        $('#bQuantity').val($('.editing .hidQuantity').val().trim());
                        $('#vCondition').val($('.editing .Remark').text().trim());
                        $('.btnAddItem').hide();
                        $('.btnUpdateItem').show();
                        $('.editing button').attr('disabled', 'disabled');
                    });
                    $('#StockCode').val('');
                    tmx.vivablast.stockreturnact.clearStockInformation();
                    tmx.vivablast.stockreturnact.DisableDDL();
                }
            });
            
            $('.btnEdit').off("click").on("click", function () {
                $('.editing button').removeAttr('disabled');
                $('.editing').removeClass('editing');

                $(this).closest('tr').addClass('editing');
                $('#StockId').val($('.editing .StockId').val());
                $('#StockCode').val($('.editing .StockCode').text().trim());
                tmx.vivablast.stockreturnact.loadStockInformation();
                $('#bQuantity').val($('.editing .hidQuantity').val().trim());
                $('#vCondition').val($('.editing .Remark').text().trim());
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
                tmx.vivablast.stockreturnact.EnableDDL();
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
                    $('.editing .hidQuantity').val($('#bQuantity').val());
                    $('.editing .Remark').val($('#vCondition').val());
                    tmx.vivablast.stockreturnact.clearStockInformation();
                    $('#StockCode', form).val('');
                    $('.editing button').removeAttr('disabled');
                    $('.editing').removeClass('editing');
                    $('.btnUpdateItem').hide();
                    $('.btnAddItem').show();
                }
            });
            
            $('#btnSave').off('click').on('click', function () {
                var check = tmx.vivablast.stockreturnact.checkValidateSaveReturn();
                if (check == true) {
                    clearVal();
                    var arrDetails = [];
                    $('#LstItem .vbcolum').each(function () {
                        arrDetails.push({
                            bReturnListID: $(this).find('.DetailId').val(),
                            vStockID: $(this).find('.StockId').val(),
                            vProjectID: $('#vProjectID').val(),
                            bQuantity: $(this).find('.hidQuantity').val(),
                            vCondition: $(this).find('.Remark').text(),
                            ToStore: $('#ToStore').val()
                        });
                    });
                    var dataV3 = {
                        V3: check,
                        LoginId: $('#iLogin').val(),
                        ReturnStockItemList: arrDetails,
                        LstDeleteDetailItem: $('#hidDeleteItemDetail').val()
                    };
                    SaveEntity(dataV3, 0);
                }
            });
        },

        loadStockInformation: function (form) {
            if ($('#StockCode', form).val() != "" && $('#StockCode', form).val().length > 5) {
                $.ajax({
                    url: "/Ajax/GetStockInformationByProjectAssigned",
                    type: "POST",
                    data: {
                        code: $('#StockCode', form).val(),
                        project: $('#vProjectID', form).val()
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
                        tmx.vivablast.stockreturnact.clearStockInformation(form);
                    }
                });
            }
        },

        checkValidateAddStock: function (form) {
            if ($('#vProjectID').val() == "") {
                clearVal();
                $('#vProjectID').after('<label id="validate" class="red">Please select Project.</label>');
                return false;
            }
            if ($('#ToStore').val() == "") {
                clearVal();
                $('#ToStore').after('<label id="validate" class="red">Please select Store.</label>');
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
                $('#bQuantity').after('<label id="validate" class="red">Quantity return greatest project quantity: ' + parseFloat($('#lblStockQty').text().trim()) + '</label>');
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

        checkValidateSaveReturn: function () {
            if ($('#vProjectID').val() == "") {
                clearVal();
                $('#vProjectID').after('<label id="validate" class="red">Please select Project.</label>');
                return false;
            }
            if ($('#ToStore').val() == "") {
                clearVal();
                $('#ToStore').after('<label id="validate" class="red">Please select Store.</label>');
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
            $('#bQuantity', form).val('');
            $('#vCondition', form).val('');
            $('#lblStockQty', form).text('');
            clearVal();
        },

        DisableDDL: function () {
            $('#vProjectID').attr('disabled', 'disabled');
            $('#ProjectName').attr('disabled', 'disabled');
            $('#ToStore').attr('disabled', 'disabled');
        },

        EnableDDL: function () {
            if ($('#LstItem tr').hasClass("vbcolum") == false) {
                $('#vProjectID').removeAttr('disabled');
                $('#ProjectName').removeAttr('disabled');
                $('#ToStore').removeAttr('disabled');
            }
        },
    };
})(jQuery, window.tmx = window.tmx || { });