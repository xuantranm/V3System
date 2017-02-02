$(document).ready(function() {
    tmx.vivablast.stockinact.init();
});

(function($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || { };

    tmx.vivablast.stockinact = {
        init: function() {
            $('#loading-indicator').hide();
            $('#Mode').val("StockIn");
            tmx.vivablast.stockinact.registerEventCreateForm();
        },

        registerEventCreateForm: function () {
            var form = $('#stock-in-create-form');

            searchStockFunction.init();

            $('#iStore').on('change', function (e) {
                tmx.vivablast.stockinact.LoadPeCondition();
            });

            $('#SupplierId').on('change', function (e) {
                tmx.vivablast.stockinact.LoadPeCondition();
            });

           $('#vPOID').on('change', function (e) {
                tmx.vivablast.stockinact.LoadSupplierCondition();
            });

            $('#dReceivedQuantity').blur(function () {
                tmx.vivablast.stockinact.calculatorPendingQty();
            });

            $('#StockCode', form).keydown(function () {
                clearVal();
            });
            
            $('#StockCode', form).blur(function () {
                tmx.vivablast.stockinact.loadStockInformation(form);
            });
            
            $('#StockCode', form).bind("enterKey", function (e) {
                tmx.vivablast.stockinact.loadStockInformation(form);
            });
            
            $('#StockCode', form).keyup(function (e) {
                if (e.keyCode == 13) {
                    $(this).trigger("enterKey");
                }
            });

            $('.btnAddItem', form).off('click').on('click', function () {
                var check = tmx.vivablast.stockinact.checkValidateAddStock(form);
                if (check == true) {
                    var htmls = '<tr class="vbcolum">' +
                                    '<td class="center">' +
                                        '<input type="hidden" value="0" class="DetailId" />' +
                                        '<input type="hidden" value="' + $('#StockId').val() + '" class="StockId" />' +
                                        '<button type="button" class="btnEdit btn btn-xs btn-primary"><span class="glyphicon glyphicon-edit"></span>Edit</button>' +
                                        '<button type="button" class="btnDelete btn btn-xs btn-danger marginleft2"><span class="glyphicon glyphicon-remove"></span>Delete</button>' +
                                    '</td>' +
                                    '<td class="center StockCode">' + $('#StockCode').val() + '</td>' +
                                    '<td class="StockName">' + $('#lblStockName').text() + '</td>' +
                                    '<td class="center QtyPO">' + $('#lblPoQty').text() + '</td>' +
                                    '<td class="center QtyReceived">' + $('#dReceivedQuantity').val() + '</td>' +
                                    '<td class="center QtyPending">' + $('#lblPendingQty').text() + '</td>' +
                                    '<td class="center ImportTaxt">' + $('#dImportTax').val() + '</td>' +
                                    '<td class="center InNo">' + $('#vInvoiceNo').val() + '</td>' +
                                    '<td class="center InDate">' + $('#dInvoiceDate').val() + '</td>' +
                                    '<td class="center Remark">' + $('#tDescription').val() + '</td>' +
                                    '<td class="center MRF">' + $('#lblMRF').text() + '</td>' +
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
                        tmx.vivablast.stockinManager.EnableDDL();
                    });
                    $('.btnEdit').off('click').on('click', function() {
                        $('.editing button').removeAttr('disabled');
                        $('.editing').removeClass('editing');

                        $(this).closest('tr').addClass('editing');
                        $('#StockId').val($('.editing .StockId').val());
                        $('#StockCode').val($('.editing .StockCode').text().trim());
                        tmx.vivablast.stockinact.loadStockInformation();
                        $('#dReceivedQuantity').val($('.editing .QtyReceived').text().trim());
                        $('#dImportTax').val($('.editing .ImportTax').text().trim());
                        $('#dInvoiceDate').val($('.editing .InDate').text().trim());
                        $('#vInvoiceNo').val($('.editing .InNo').text().trim());
                        $('#tDescription').val($('.editing .Remark').text().trim());
                        $('.btnAddItem').hide();
                        $('.btnUpdateItem').show();
                        $('.editing button').attr('disabled', 'disabled');
                    });
                    $('#StockCode').val('');
                    tmx.vivablast.stockinact.clearStockInformation();
                    tmx.vivablast.stockinact.DisableDDL();
                }
            });
            
            $('.btnEdit').off("click").on("click", function () {
                $('.editing button').removeAttr('disabled');
                $('.editing').removeClass('editing');

                $(this).closest('tr').addClass('editing');
                $('#StockId').val($('.editing .StockId').val());
                $('#StockCode').val($('.editing .StockCode').text().trim());
                tmx.vivablast.stockinact.loadStockInformation();
                $('#dReceivedQuantity').val($('.editing .QtyReceived').text().trim());
                $('#dImportTax').val($('.editing .ImportTax').text().trim());
                $('#dInvoiceDate').val($('.editing .InDate').text().trim());
                $('#vInvoiceNo').val($('.editing .InNo').text().trim());
                $('#tDescription').val($('.editing .Remark').text().trim());
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
                tmx.vivablast.stockinManager.EnableDDL();
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
                var receivedQty = $.trim($('#dReceivedQuantity').val());
                if (receivedQty == "" || receivedQty == "0") {
                    clearVal();
                    $('#dReceivedQuantity').after('<label id="validate" class="red">Quantity incorrect.</label>');
                    return false;
                }
                if ($.trim($('#dInvoiceDate', form).val()) == "") {
                    clearVal();
                    $('#dInvoiceDate', form).after('<label id="validate" class="red">Invoice Date not empty.</label>');
                    return false;
                }
                else {
                    if ($('.editing .ImportTax').text() != $('#dReceivedQuantity').val()) {
                        $('.editing .ModifyQty').val(1);
                    }
                    $('.editing .QtyReceived').text($('#dReceivedQuantity').val());
                    $('.editing .QtyPending').text($('#lblPendingQty').text());
                    $('.editing .ImportTax').text($('#dImportTax').val());
                    $('.editing .InNo').text($('#vInvoiceNo').val());
                    $('.editing .InDate').text($('#dInvoiceDate').val());
                    $('.editing .Remark').text($('#tDescription').val());
                    tmx.vivablast.stockinact.clearStockInformation();
                    $('#dInvoiceDate').val($('#nowDate').val());
                    $('#StockCode', form).val('');
                    $('.editing button').removeAttr('disabled');
                    $('.editing').removeClass('editing');
                    $('.btnUpdateItem').hide();
                    $('.btnAddItem').show();
                }
            });
            
            $('#btnSave').off('click').on('click', function () {
                var check = tmx.vivablast.stockinact.checkValidateSaveFulfillment();
                if (check == true) {
                    clearVal();
                    var arrDetails = [];
                    $('#LstItem .vbcolum').each(function () {
                        arrDetails.push({
                            ID: $(this).find('.DetailId').val(),
                            vPOID: $('#vPOID').val(),
                            vStockID: $(this).find('.StockId').val(),
                            dQuantity: $(this).find('.QtyPO').text(),
                            dReceivedQuantity: $(this).find('.QtyReceived').text(),
                            dPendingQuantity: $(this).find('.QtyPending').text(),
                            //dDateDelivery: $(this).find('.Quantity').text(),
                            //iShipID: $(this).find('.ShipId').text(),
                            tDescription: $(this).find('.Remark').text(),
                            vMRF: $(this).find('.MRF').text(),
                            //dCurrenQuantity: $(this).find('.Quantity').text(),
                            dInvoiceDate: $(this).find('.InDate').text(),
                            vInvoiceNo: $(this).find('.InNo').text(),
                            dImportTax: $(this).find('.ImportTax').text(),
                            //dDateAssign: $(this).find('.Quantity').text(),
                            //SRV: $(this).find('.Quantity').text(),
                            iStore: $('#iStore').val(),
                            iModified: $(this).find('.ModifyQty').val(),
                        });
                    });
                    var dataV3 = {
                        V3: check,
                        LoginId: $('#iLogin').val(),
                        ListFulfillmentDetail: arrDetails,
                        LstDeleteDetailItem: $('#hidDeleteItemDetail').val()
                    };
                    SaveEntity(dataV3, 0);
                }
            });
        },

        loadStockInformation: function (form) {
            if ($('#StockCode', form).val() != "" && $('#StockCode', form).val().length > 5) {
                $.ajax({
                    url: "/Ajax/StockInGetStockInformation",
                    type: "POST",
                    asysn: false,
                    data: {
                        code: $('#StockCode', form).val(),
                        store: $('#iStore', form).val(),
                        pe: $('#vPOID', form).val()
                    },
                    success: function (stock) {
                        $('#StockId', form).val(stock.Id);
                        $('#fQuantity', form).removeAttr('disabled');
                        $('#lblStockName', form).text(stock.Stock_Name);
                        $('#lblStockType', form).text(stock.Type);
                        //$('#lblPoQty', form).text(stock.PEQuantity);
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
                        tmx.vivablast.stockinact.loadStockInQuantity(form);
                    },
                    error: function () {
                        tmx.vivablast.stockinact.clearStockInformation(form);
                    }
                });
            }
        },
       
        loadStockInQuantity: function (form)
        {
            if ($('#StockCode', form).val() != "" && $('#StockCode', form).val().length > 5 && $('#vPOID', form).val() !="") {
                $.ajax({ 
                    url: "/Ajax/StockInGetQuantity",
                    type: "POST",
                    asysn: false,
                    data: {
                        code: $('#StockId', form).val(),
                        pe: $('#vPOID', form).val()
                    },
                    success: function (data) {
                        console.log(data);
                        $('#lblPoQty', form).text(data.PeQuantity);
                        $('#lblPendingQty', form).text(data.PendingQuantity);
                        $('#hidPendingQty', form).val(data.PendingQuantity);
                        if (data.ReceivedQuantity > 0) {
                            $('#ReceivedQty').removeClass('hidden');
                            $('#ReceivedQty', form).text(data.ReceivedQuantity);
                        } else {
                            $('#lblPendingQty', form).text(data.PeQuantity);
                            $('#hidPendingQty', form).val(data.PeQuantity);
                        }
                        if (data.Mrf == null) {
                            $('#lblMRF', form).text('0');
                        } else {
                            $('#lblMRF', form).text(data.Mrf);
                        }
                        $('#dInvoiceDate').val($('#nowDate').val());
                        if ($('.editing .DetailId').val() > 0) {
                            $("#hidPendingQty").val(parseFloat($("#hidPendingQty").val()) + parseFloat($('.editing .QtyReceived').text().trim()));
                        }
                    },
                    error: function () {
                        //tmx.vivablast.stockinact.clearStockInformation(form);
                    }
                });
            }
        },

        LoadPeCondition: function (form) {
            var url;
            if ($('#iStore', form).val() != '' && $('#SupplierId', form).val() != '') {
                url = "/StockIn/LoadPeAdd";
                $.ajax({
                    url: url,
                    data: {
                        page: 1,
                        size: 100,
                        supplier: $('#SupplierId', form).val(),
                        store: $('#iStore', form).val()
                    },
                    cache: false,
                    type: "POST",
                    success: function (data) {
                        if (data.TotalRecords == 0) {
                            clearVal();
                            var price = "<option value=''>Select</option>";
                            $("#vPOID", form).html(price);
                            $('#vPOID', form).after('<label id="validate" class="red">No PE!</label>');
                        } else {
                            clearVal();
                            var markup = "<option value=''>Select</option>";
                            $.each(data.PEs, function(i, item) {
                                markup += "<option value=" + item.Id + ">" + item.Code + "</option>";
                            });
                            $('#vPOID', form).html(markup);
                        }
                    },
                    error: function() {
                        errorSystem();
                    }
                });
            } else {
                if ($('#iStore', form).val() != '') {
                    url = "/StockIn/LoadPeOpen";
                    $.ajax({
                        url: url,
                        data: {
                            page: 1,
                            size: 100,
                            store: $('#iStore', form).val()
                        },
                        cache: false,
                        type: "POST",
                        success: function (data) {
                            console.log(data);
                            if (data.TotalRecords == 0) {
                                clearVal();
                                var price = "<option value=''>Select</option>";
                                $("#vPOID", form).html(price);
                                $('#vPOID', form).after('<label id="validate" class="red">No PE!</label>');
                            } else {
                                clearVal();
                                var markup = "<option value=''>Select</option>";
                                $.each(data.PEs, function(i, item) {
                                    markup += "<option value=" + item.Id + ">" + item.Code + "</option>";
                                });
                                $('#vPOID', form).html(markup);
                            }
                        },
                        error: function () {
                            errorSystem();
                        }
                    });
                }
            }
        },

        LoadSupplierCondition: function (form) {
            if ($('#vPOID', form).val() != '') {
                var url = "/StockIn/LoadSupplierPe";
                $.ajax({
                    url: url,
                    data: {
                        pe: $('#vPOID', form).val()
                    },
                    cache: false,
                    type: "POST",
                    success: function (data) {
                        if (data.length == 0) {
                            clearVal();
                            $('#SupplierId', form).val('');
                        } else {
                            clearVal();
                            $('#SupplierId', form).val(data.Id);
                        }
                    },
                    error: function () {
                        errorSystem();
                    }
                });
            }
        },

        calculatorPendingQty: function () {
            if ($('#dReceivedQuantity').val() != '' || $('#dReceivedQuantity').val() != 0) {
                var qtyCanFul = Math.round((parseFloat($('#lblPoQty').text()) + parseFloat($('#lblPoQty').text()) * 3 / 100) * 100) / 100;
                //if ($('#dReceivedQuantity').val() > qtyCanFul) {
                //    $('#dReceivedQuantity').focus();
                //    $('#dReceivedQuantity').addClass('error');
                //    return false;
                //}
                var qtyCheck;
                var qty;
                qty = Math.round((checkNumeric($("#hidPendingQty").val()) - $("#dReceivedQuantity").val()) * 100) / 100;
                if (qty < 0) {
                    // Not fulfillment
                    if (parseFloat($('#hidPendingQty').val()) == parseFloat($('#lblPoQty').text())) {
                        qtyCheck = qtyCanFul - parseFloat($("#dReceivedQuantity").val());
                        if (qtyCheck < 0) {
                            $("#dReceivedQuantity").after('<label id="validate" class="red">Quantity Receive allow equal Quantity Order + 3%</label>');
                            $("#dReceivedQuantity").val("");
                            $("#dReceivedQuantity").focus();
                            $('#lblPendingQty').text($('#hidPendingQty').val());
                        }
                        else {
                            clearVal();
                            $('#lblPendingQty').text("0");
                        }
                    }
                        // Fulfilled but not complete
                    else {
                        var qtyReceived = parseFloat($('#lblPoQty').val()) - parseFloat($('#hidPendingQty').val());
                        qtyCheck = qtyCanFul - (qtyReceived + parseFloat($('#dReceivedQuantity').val()));
                        if (qtyCheck < 0) {
                            $("#dReceivedQuantity").after('<label id="validate" class="red">Quantity Receive allow equal Quantity Order + 3%</label>');
                            $("#dReceivedQuantity").val("");
                            $("#dReceivedQuantity").focus();
                            $('#lblPendingQty').text($('#hidPendingQty').val());
                        }
                        else {
                            clearVal();
                            $('#lblPendingQty').text("0");
                        }
                    }
                } else {
                    clearVal();
                    $('#lblPendingQty').text(qty);
                }
            }
        },

        checkValidateAddStock: function (form) {
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
            var receivedQty = $.trim($('#dReceivedQuantity').val());
            if (receivedQty == "" || receivedQty == "0") {
                clearVal();
                $('#dReceivedQuantity').after('<label id="validate" class="red">Quantity incorrect.</label>');
                return false;
            }
            if ($.trim($('#dInvoiceDate', form).val()) == "") {
                clearVal();
                $('#dInvoiceDate', form).after('<label id="validate" class="red">Invoice Date not empty.</label>');
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

        checkValidateSaveFulfillment: function () {
            if ($('#vPOID').val() == "") {
                clearVal();
                $('#vPOID').after('<label id="validate" class="red">Please select PE.</label>');
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
            $('#lblPoQty').text('');
            $('#dReceivedQuantity').val('');
            $('#dImportTax').val('');
            $('#dInvoiceDate').val('');
            $('#vInvoiceNo').val('');
            $('#tDescription').val('');
            $('#lblMRF').text('');
            clearVal();
        },

        DisableDDL: function () {
            $('#iStore').attr('disabled', 'disabled');
            $('#SupplierId').attr('disabled', 'disabled');
            $('#vPOID').attr('disabled', 'disabled');
        },

        EnableDDL: function () {
            if ($('#LstItem tr').hasClass("vbcolum") == false) {
                $('#iStore').removeAttr('disabled');
                $('#SupplierId').removeAttr('disabled');
                $('#vPOID').removeAttr('disabled');
            }
        },
    };
})(jQuery, window.tmx = window.tmx || { });