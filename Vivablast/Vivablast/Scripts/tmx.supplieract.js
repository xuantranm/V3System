$(document).ready(function() {
    tmx.vivablast.supplieract.init();
});

(function($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || { };

    tmx.vivablast.supplieract = {
        init: function() {
            $('#loading-indicator').hide();
            tmx.vivablast.supplieract.registerEventCreateForm();
            $("#vSupplierName").autocomplete({
                source: "/Supplier/ListName?term" + $("#vSupplierName").val()
            });
        },

        registerEventCreateForm: function () {
            var form = $('#supplier-create-form');
            searchStockFunction.init('all');
            $('#StockCode', form).keydown(function () {
                clearVal();
            });
            
            $('#StockCode', form).blur(function () {
                tmx.vivablast.supplieract.loadStockInformation(form);
            });
            
            $('#StockCode', form).bind("enterKey", function (e) {
                tmx.vivablast.supplieract.loadStockInformation(form);
            });
            
            $('#StockCode', form).keyup(function (e) {
                if (e.keyCode == 13) {
                    $(this).trigger("enterKey");
                }
            });
            
            $('#iStore', form).on('change', function (e) {
                if ($(this).val != "") {
                    tmx.vivablast.supplieract.loadStockInformation(form);
                }
            });
            
            $('.btnAddItem', form).off('click').on('click', function () {
                var check = tmx.vivablast.supplieract.checkValidateAddStock(form);
                if (check == true) {
                    var htmls = '<tr class="vbcolum">' +
                                    '<td class="center">' +
                                        '<input type="hidden" value="0" class="DetailId" />' +
                                        '<input type="hidden" value="' + $('#StockId').val() + '" class="StockId" />' +
                                        '<button type="button" class="btnEdit btn btn-xs btn-primary"><span class="glyphicon glyphicon-edit"></span>Edit</button>' +
                                        '<button type="button" class="btnDelete btn btn-xs btn-danger marginleft2"><span class="glyphicon glyphicon-remove"></span>Delete</button>' +
                                    '</td>' +
                                    '<td class="center StockCode">' + $('#StockCode').val() + '</td>' +
                                    '<td class="center StockName">' + $('#lblStockName').text() + '</td>' +
                                    '<td class="center StockType">' + $('#lblStockType').text() + '</td>' +
                                        '<td class="center Unit">' + $('#lblStockUnit').text() + '</td>' +
                                       '<td class="center Description">' + $('#vDescription').val() + '</td>' +
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
                        tmx.vivablast.supplieract.loadStockInformation();
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
                    tmx.vivablast.supplieract.clearStockInformation();
                }
            });
            
            $('.btnEdit').off("click").on("click", function () {
                $('.editing button').removeAttr('disabled');
                $('.editing').removeClass('editing');

                $(this).closest('tr').addClass('editing');
                $('#StockId').val($('.editing .StockId').val());
                $('#StockCode').val($('.editing .StockCode').text().trim());
                tmx.vivablast.supplieract.loadStockInformation();
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
                else {
                    $('.editing .StockId').val($('#StockId').val());
                    $('.editing .StockCode').text($('#StockCode').val());
                    $('.editing .StockName').text($('#lblStockName').text());
                    $('.editing .StockType').text($('#lblStockType').text());
                    $('.editing .Unit').text($('#lblStockUnit').text());
                    $('.editing .Description').text($('#vDescription').val());
                    tmx.vivablast.supplieract.clearStockInformation();
                    $('#StockCode', form).val('');
                    $('.editing button').removeAttr('disabled');
                    $('.editing').removeClass('editing');
                    $('.btnUpdateItem').hide();
                    $('.btnAddItem').show();
                }
            });
            
            $('#btnSave').off('click').on('click', function () {
                var check = tmx.vivablast.supplieract.checkValidateSaveSupplier();
                var id = 0;
                if ($('#Id').val() !== "") {
                    id = $('#Id').val();
                }
                if (check == true) {
                    clearVal();
                    var arrDetails = [];
                    $('#LstItem .vbcolum').each(function () {
                        arrDetails.push({
                            Id: $(this).find('.DetailId').val(),
                            vProductID: $(this).find('.StockId').val(),
                            vDescription: $(this).find('.Description').text()
                        });
                    });
                    var dataV3 = {
                        V3: check,
                        LoginId: $('#iLogin').val(),
                        CheckName: $('#hidCheckName').val(),
                        Supplier: {
                            bSupplierID: id,
                            vSupplierName: $('#vSupplierName').val(),
                            vAddress: $('#vAddress').val(),
                            vCity: $('#vCity').val(),
                            vPhone1: $('#Telephone1').val(),
                            vPhone2: $('#Telephone2').val(),
                            vMobile: $('#Mobile').val(),
                            vFax: $('#vFax').val(),
                            vEmail: $('#Email').val(),
                            vContactPerson: $('#vContactPerson').val(),
                            bSupplierTypeID: $('#bSupplierTypeID').val(),
                            CountryId: $('#CountryId').val(),
                            iStore: $('#iStore').val(),
                            iService: 1,
                            iMarket: 1,
                            Timestamp: $('#Timestamp').val()
                        },
                        ListProducts: arrDetails,
                        LstDeleteDetailItem: $('#hidDeleteItemDetail').val()
                    };
                    console.log(dataV3);
                    SaveEntity(dataV3, id);
                }
            });
        },

        loadStockInformation: function (form) {
            var store = 0;
            if ($('#iStore', form).val() != "") {
                store = $('#iStore', form).val();
            }
            if ($('#StockCode', form).val() != "" && $('#StockCode', form).val().length > 5) {
                $.ajax({
                    url: "/Ajax/GetStockInformationByCode",
                    type: "POST",
                    data: {
                        code: $('#StockCode', form).val(),
                        store: store
                    },
                    success: function (stock) {
                        $('#StockId', form).val(stock.Id);
                        $('#lblStockName', form).text(stock.Stock_Name);
                        $('#lblStockType', form).text(stock.Type);
                        if ($('#iStore', form).val() != "") {
                            if (stock.Quantity != null) {
                                $('#lblStockQty', form).text(stock.Quantity);
                            }
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
                        tmx.vivablast.supplieract.clearStockInformation(form);
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
        
        checkValidateSaveSupplier: function () {
            if ($.trim($('#vSupplierName').val()) == "") {
                clearVal();
                $('#vSupplierName').after('<label id="validate" class="red">Supplier not empty.</label>');
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
            $('#lblStockQty', form).text('');
            $('#StockId', form).val('');
            //$('#StockCode', form).val('');
            $('#vDescription', form).val('');
            clearVal();
        }
    };
})(jQuery, window.tmx = window.tmx || { });