$(document).ready(function() {
    tmx.vivablast.requisitionact.init();
});

(function($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || { };

    tmx.vivablast.requisitionact = {
        init: function() {
            $('#loading-indicator').hide();
            tmx.vivablast.requisitionact.registerEventCreateForm();
        },

        registerEventCreateForm: function () {
            var form = $('#requisition-create-form');

            searchStockFunction.init();

            $('#ProjectName').val($('#vProjectID').val());

            $('#StockCode', form).keydown(function () {
                clearVal();
            });
            
            $('#StockCode', form).blur(function () {
                tmx.vivablast.requisitionact.loadStockInformation(form);
            });
            
            $('#StockCode', form).bind("enterKey", function (e) {
                tmx.vivablast.requisitionact.loadStockInformation(form);
            });
            
            $('#vProjectID').on('change', function (e) {
                var typeId = 0;
                if ($('#iType').val() !== "") {
                    typeId = $('#vProjectID').val();
                }
                $('#ProjectName').val(typeId);
            });

            $('#ProjectName').on('change', function (e) {
                var typeId = 0;
                if ($('#iType').val() !== "") {
                    typeId = $('#ProjectName').val();
                }
                $('#vProjectID').val(typeId);
            });

            $('#StockCode', form).keyup(function (e) {
                if (e.keyCode == 13) {
                    $(this).trigger("enterKey");
                }
            });
            
            $('#StoreId', form).on('change', function (e) {
                tmx.vivablast.requisitionact.loadStockInformation(form);
            });
            
            $('.btnAddItem', form).off('click').on('click', function () {
                var check = tmx.vivablast.requisitionact.checkValidateAddStock(form);
                if (check == true) {
                    var htmls = '<tr class="vbcolum">' +
                                    '<td class="center">' +
                                        '<input type="hidden" value="0" class="DetailId" />' +
                                        '<input type="hidden" value="' + $('#StockId').val() + '" class="StockId" />' +
                                        '<button type="button" class="btnEdit btn btn-xs btn-primary"><span class="glyphicon glyphicon-edit"></span>Edit</button>' +
                                        '<button type="button" class="btnDelete btn btn-xs btn-danger marginleft6"><span class="glyphicon glyphicon-remove"></span>Delete</button>' +
                                    '</td>' +
                                    '<td class="center StockCode">' + $('#StockCode').val() + '</td>' +
                                    '<td class="center StockName">' + $('#lblStockName').text() + '</td>' +
                                    '<td class="center Quantity">' + $('#fQuantity').val() + '</td>' +
                                    '<td class="center QuantityPe">' + $('#fTobePurchased').val() + '</td>' +
                                    '<td class="center hidden-xs Remark">' + $('#Remark').val() + '</td>' +
                                    '<td class="center Purchased">' + $('#iPurchased').val() + '</td>' +
                                    '<td class="center Sent">' + $('#iSent').val() + '</td>' +
                                    '<td class="center CreatedDate">' + getDateFormatddmmyyyy() + '</td>' +
                                '</tr>';
                    if ($("#LstItem tr").hasClass("vbcolum")) {
                        $(htmls).insertAfter($('#LstItem tbody tr:last-child'));
                    }
                    else {
                        $('#LstItem tbody').append(htmls);
                    }
                    
                    $('.btnEdit').off("click").on("click", function () {
                        $('.editing button').removeAttr('disabled');
                        $('.editing').removeClass('editing');
                        
                        $(this).closest('tr').addClass('editing');
                        $('#StockId').val($('.editing .StockId').val());
                        $('#StockCode').val($('.editing .StockCode').text().trim());
                        tmx.vivablast.requisitionact.loadStockInformation();
                        $('#fQuantity').val($('.editing .Quantity').text().trim());
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
                    });
                    $('#StockCode').val('');
                    tmx.vivablast.requisitionact.clearStockInformation();
                }
            });
            
            $('.btnEdit').off("click").on("click", function () {
                $('.editing button').removeAttr('disabled');
                $('.editing').removeClass('editing');

                $(this).closest('tr').addClass('editing');
                $('#StockId').val($('.editing .StockId').val());
                $('#StockCode').val($('.editing .StockCode').text().trim());
                tmx.vivablast.requisitionact.loadStockInformation();
                $('#fQuantity').val($('.editing .Quantity').text().trim());
                $('#fTobePurchased').val($('.editing .QuantityPe').text().trim());
                $('#Remark').val($('.editing .Remark').text().trim());
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
                if ($.trim($('#fQuantity', form).val()) == "") {
                    clearVal();
                    $('#fQuantity', form).after('<label id="validate" class="red">Quantity not empty</label>');
                    return false;
                }
                if ($.trim($('#fQuantity', form).val()) == "0") {
                    clearVal();
                    $('#fQuantity', form).after('<label id="validate" class="red">Quantity not equal 0</label>');
                    return false;
                }
                else {
                    $('.editing .StockId').val($('#StockId').val());
                    $('.editing .StockCode').text($('#StockCode').val());
                    $('.editing .StockName').text($('#lblStockName').text());
                    $('.editing .Quantity').text($('#fQuantity').val());
                    $('.editing .QuantityPe').text($('#fTobePurchased').val());
                    $('.editing .Remark').text($('#Remark').val());
                    $('.editing .CreatedDate').text(getDateFormatddmmyyyy());
                    tmx.vivablast.requisitionact.clearStockInformation();
                    $('#StockCode', form).val('');
                    $('.editing button').removeAttr('disabled');
                    $('.editing').removeClass('editing');
                    $('.btnUpdateItem').hide();
                    $('.btnAddItem').show();
                }
            });
            
            $('#btnSave').off('click').on('click', function () {
                var check = tmx.vivablast.requisitionact.checkValidateSaveRequisition();
                var id = 0;
                if ($('#Id').val() !== "") {
                    id = $('#Id').val();
                }
                if (check == true) {
                    clearVal();
                    var arrDetails = [];
                    $('#LstItem .vbcolum').each(function () {
                        arrDetails.push({
                            ID: $(this).find('.DetailId').val(),
                            vStockID: $(this).find('.StockId').val(),
                            fQuantity: $(this).find('.Quantity').text(),
                            fTobePurchased: $(this).find('.QuantityPe').text(),
                            Remark: $(this).find('.Remark').text()
                        });
                    });
                    var dataV3 = {
                        V3: check,
                        LoginId: $('#iLogin').val(),
                        CheckCode: $('#hidCheckCode').val(),
                        RequisitionMaster: {
                            Id: id,
                            vMRF: $('#vMRF').val(),
                            vFrom: $('#vFrom').val(),
                            vProjectID: $('#vProjectID').val(),
                            vDeliverLocation: $('#vDeliverLocation').val(),
                            iStore: $('#StoreId').val(),
                            Timestamp: $('#Timestamp').val()
                        },
                        DeliverDateTemp: $('#dDeliverDate').val(),
                        ListRequisitionDetails: arrDetails,
                        LstDeleteDetailItem: $('#hidDeleteItemDetail').val()
                    };
                    SaveEntity(dataV3, id);
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
                        store: $('#StoreId', form).val()
                    },
                    success: function (stock) {
                        $('#StockId', form).val(stock.Id);
                        $('#fQuantity', form).removeAttr('disabled');
                        $('#fTobePurchased', form).removeAttr('disabled');
                        $('#lblStockName', form).text(stock.Stock_Name);
                        $('#lblStockType', form).text(stock.Type);
                        $('#lblQtyPurchased', form).text('0');
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
                        tmx.vivablast.requisitionact.clearStockInformation(form);
                    }
                });
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
            if ($.trim($('#fQuantity', form).val()) == "") {
                clearVal();
                $('#fQuantity', form).after('<label id="validate" class="red">Quantity not empty</label>');
                return false;
            }
            if ($.trim($('#fQuantity', form).val()) == "0") {
                clearVal();
                $('#fQuantity', form).after('<label id="validate" class="red">Quantity not equal 0</label>');
                return false;
            }
            var checkExist = true;
            // Check exist on list
            $(".StockId").each(function () {
                //var a = $(this).val();
                //var b = $.trim($('#StockId').val());
                if ($.trim($('#StockId').val()) == $(this).val())
                {
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
        
        checkValidateSaveRequisition: function () {
            //if ($('#dDeliverDate').val() == "") {
            //    clearVal();
            //    $('#dDeliverDate').after('<label id="validate" class="red">Please input Deliver Date.</label>');
            //    return false;
            //}
            if (typeof $("#LstItem .vbcolum .StockId").val() === "undefined") {
                $('.alert-danger').show();
                return false;
            }
            return true;
        },
        
        clearStockInformation: function (form) {
            $('#lblQtyPurchased', form).text('');
            $('#lblStockName', form).text('');
            $('#lblStockType', form).text('');
            $('#lblStockUnit', form).text('');
            $('#lblPartNo', form).text('');
            $('#lblRalNo', form).text('');
            $('#lblColor', form).text('');
            $('#lblStockQty', form).text('');
            $('#StockId', form).val('');
            $('#fQuantity', form).val('');
            $('#fQuantity', form).attr('disabled', 'disabled');
            $('#fTobePurchased', form).val('');
            $('#fTobePurchased', form).attr('disabled', 'disabled');
            $('#Remark').val('');
            clearVal();
        }
    };
})(jQuery, window.tmx = window.tmx || { });