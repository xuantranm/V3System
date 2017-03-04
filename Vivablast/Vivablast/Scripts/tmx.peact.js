var decimalNum = 4;
$(document).ready(function () {
    tmx.vivablast.peact.init();
    //$("#Store_Id option[value='1']").remove();
});

(function ($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.peact = {
        init: function () {
            $('.money-input').each(function () {
                $(this).on('focus', function () {
                    $(this).val($(this).val().replace(/\ đ/g, "").replace(/\ %/g, "").replace(/\ năm/g, ""));
                }).on('keydown', function (e) {
                    if ((e.keyCode == 44))
                        alert('Please using . for decimal');
                    // Allow: backspace, delete, tab, escape, enter and .
                    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
                        // Allow: Ctrl+A
                        (e.keyCode == 65 && e.ctrlKey === true) ||
                        // Allow: Ctrl+C
                        (e.keyCode == 67 && e.ctrlKey === true) ||
                        // Allow: Ctrl+X
                        (e.keyCode == 88 && e.ctrlKey === true) ||
                        // Allow: home, end, left, right
                        (e.keyCode >= 35 && e.keyCode <= 39) ||
                        (e.keyCode == 46)) {
                        // let it happen, don't do anything
                        return;
                    }
                    //if (this.value.length > 13) e.preventDefault();
                    //hundreds of millions (50 billion: 11 lenght)
                    //console.log($(this).val());

                    // Ensure that it is a number and stop the keypress
                    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                        e.preventDefault();
                    }
                })
                    .on('keyup', function (e) {
                        if (this.value == '' || e.keyCode == 37 || e.keyCode == 39) return; // check null and arrow button
                        // store current cursor  positions in variables
                        var start = this.selectionStart;
                        var bcount = this.value.length;
                        var main = this.value.replace(/\,/g, "").toString().split('.')[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                        var decimal = this.value.toString().split('.')[1];
                        console.log(decimal);
                        var result = main;

                        if (typeof decimal !== "undefined") {
                            result += '.' + decimal;
                        }
                        $(this).val(result);

                        var end = this.selectionEnd;
                        var acount = this.value.length;
                        //start = start + 4 == end ? start + 1 : start; //have input 3 chars will have 1 space
                        if (bcount != acount) {
                            start = start + 1;
                        }
                        end = bcount != acount ? start : end;
                        end = start != end ? start : end;
                        // set cursor  positions after format 

                        this.setSelectionRange(start, end);
                        $('.hidden', $(this).closest('div')).val(this.value.replace(/\,/g, "").toString());
                        if ($('.hidden', $(this).closest('div')).val() <= 0) {
                            $(this).val(0);
                        }
                        //$('.money-text', $(this).closest('div')).text('');
                        //$('.money-text', $(this).closest('div')).text(DocTienBangChu($('.hidden', $(this).closest('div')).val() * 1000000));

                    })
                    .on('focusout', function () {
                        tmx.vivablast.peact.calculatorAmountPrice();
                    });
            });
            
            $('#loading-indicator').hide();
            $('#Mode').val("PE");
            $('#Mrf').tooltip({ 'trigger': 'focus', 'title': "Mrf can multible, divide by ' ; '" });
            $('#Mrf').val(0);
            tmx.vivablast.peact.registerEventCreateForm();

            $('#btnNewVAT').on('click', function () {
                var html = '<div class="modal fade" id="dynamic-model-box" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">';
                html = html + '<div class="modal-dialog modal-md"><div class="modal-content"><div class="modal-header"><h4 class="modal-title">New VAT</h4></div>';
                html = html + '<div class="modal-body"></div>';
                html = html + '<div class="modal-footer" style="text-align:center">';
                html = html + '<button type="button" id="btnYes" class="btn btn-primary enable-for-officer">Save</button>';
                html = html + '<button type="button" id="btnNo" class="btn btn-warning enable-for-officer">Close</button>';
                html = html + '</div></div> </div></div>';
                $('body').append(html);
                var modelBox = $('#dynamic-model-box');

                $.ajax({
                    url: '/PE/NewVAT',
                    type: 'GET',
                    datatype: 'json',
                    contentType: 'application/json; charset=utf-8',
                    success: function (data) {
                        $('.modal-body').empty().append(data);
                    }
                });

                var name;
                modelBox.find('#btnYes').on('click', function () {
                    $.ajax({
                        url: '/PE/NewVAT',
                        dataType: 'json',
                        async: false,
                        contentType: 'application/json',
                        type: 'POST',
                        data: ko.toJSON({
                            vat: $('#new-vat', modelBox).val()
                        }),
                        success: function (response) {
                            name = $('#new-vat', modelBox).val().trim();
                            $.ajax({
                                url: '/PE/LoadVAT',
                                cache: false,
                                type: "POST",
                                success: function (data) {
                                    var markup = "<option value='0'>0</option>";
                                    for (var x = 0; x < data.length; x++) {
                                        markup += "<option value=" + data[x].Value + ">" + data[x].Text + "</option>";
                                    }
                                    $("#VAT").html(markup);
                                    $("#VAT option").filter(function () {
                                        //may want to use $.trim in here
                                        return $(this).text() == name;
                                    }).prop('selected', true);
                                    tmx.vivablast.peact.calculatorAmountPrice();
                                },
                                error: function () {
                                    openErrorDialog({
                                        title: "Can't load VAT Data",
                                        data: "Please contact Administrator support."
                                    });
                                }
                            });
                        }
                    });
                    closeDialog();
                });
                modelBox.find('#btnNo').on('click', function () {
                    closeDialog();
                });

                $('#dynamic-model-box').modal({ show: true, backdrop: 'static' });
            });
        },

        registerEventCreateForm: function () {
            var form = $('#pe-create-form');
            searchStockFunction.init();

            

            $('#ProjectName').val($('#vProjectID').val());

            $('#vProjectID').on('change', function (e) {
                $('#ProjectName').val($('#vProjectID').val());
            });

            $('#ProjectName').on('change', function (e) {
                $('#vProjectID').val($('#ProjectName').val());
            });

            $("#Payment").autocomplete({
                source: "/PE/ListPayment?term" + $("#Payment").val()
            });

            $('#StockCode', form).keydown(function () {
                clearVal();
            });

            $('#StockCode', form).blur(function () {
                if ($(this).val().length > 5) {
                    tmx.vivablast.peact.loadStockInformation(form);
                }
            });

            $('#StockCode', form).bind("enterKey", function (e) {
                if ($(this).val().length > 5) {
                    tmx.vivablast.peact.loadStockInformation(form);
                }
            });

            $('#StockCode', form).keyup(function (e) {
                if (e.keyCode == 13) {
                    $(this).trigger("enterKey");
                }
            });

            $("#StockCode").on('change keyup paste', function () {
                if ($(this).val().length > 5) {
                    tmx.vivablast.peact.loadStockInformation(form);
                }
            });

            $('#iStore').on('change', function () {
                clearVal();
                //tmx.vivablast.peact.loadPrice(form);
                tmx.vivablast.peact.loadMrf(form);
            });

            $('#bSupplierID').on('change', function () {
                tmx.vivablast.peact.loadPaymentType(form, $('#bSupplierID').val());
                if ($('#bSupplierID').val() > 0) {
                    $('.more-product').removeClass('hidden');
                    $('.more-product a').attr('href', '/Supplier/Create/' + $('#bSupplierID').val());
                } else {
                    $('.more-product').addClass('hidden');
                }
                clearVal();
            });

            $('#priceCreateFormPO').on('change', function (e) {
                tmx.vivablast.peact.calculatorAmountPrice();
            });

            $('#fUnitPrice').blur(function () {
                tmx.vivablast.peact.calculatorAmountPrice();
            });

            $('#Quantity').blur(function () {
                tmx.vivablast.peact.calculatorAmountPrice();
            });

            $('#Discount').blur(function () {
                tmx.vivablast.peact.calculatorAmountPrice();
            });

            //$('#VAT').blur(function () {
            //    tmx.vivablast.peact.calculatorAmountPrice();
            //});

            $('#VAT').change(function () {
                tmx.vivablast.peact.calculatorAmountPrice();
            });

            $('.btnAddItem').off('click').on('click', function () {
                var check = tmx.vivablast.peact.checkValidateAddStock(form);
                if (check == true) {
                    var htmls = '<tr class="vbcolum">' +
                        '<td class="center">' +
                        '<button type="button" class="btnEdit btn btn-xs btn-primary"><span class="glyphicon glyphicon-edit"></span>Edit</button>' +
                        '<button type="button" class="btnDelete btn btn-xs btn-danger marginleft2"><span class="glyphicon glyphicon-remove"></span>Delete</button>' +
                        '<input type="hidden" value="0" class="DetailId" />' +
                        '<input type="hidden" value="' + $('#StockId').val() + '" class="StockId" />' +
                        //'<input type="hidden" value="' + $("#priceCreateFormPO").val() + '" class="PriceId" />' +
                        '<input type="hidden" value="' + $("#mrfCreateFormPO").val() + '" class="MRFId" />' +
                        '</td>' +
                        '<td class="center StockCode">' + $('#StockCode').val() + '</td>' +
                        '<td class="center StockName">' + $('#lblStockName').text() + '</td>' +
                        '<td class="center Quantity">' + $('#Quantity').val() + '</td>' +
                        '<td class="center UnitPrice">' + $("#fUnitPrice").val() + '</td>' +
                        '<td class="center Discount">' + $('#Discount').val() + '</td>' +
                        '<td class="center VAT">' + $('#VAT').val() + '</td>' +
                        '<td class="center TotalPrice">' + $('#lblAmountPrice').text() + '</td>' +
                        '<td class="center MRF">' + $("#Mrf").val() + '</td>' +
                        '<td class="center Remark">' + $('#RemarkDetail').val() + '</td>' +
                        '<td class="center PODetailStatus">Open</td>' +
                        '<td class="center StockType">' + $('#lblStockType').text() + '</td>' +
                        '<td class="center Unit">' + $('#lblStockUnit').text() + '</td>' +
                        '</tr>';

                    if ($("#LstItem tr").hasClass("vbcolum")) {
                        $(htmls).insertAfter($('#LstItem tbody tr:last-child'));
                    } else {
                        $('#LstItem tbody').append(htmls);
                    }
                    $('.divTotalAmount').css("display", "block");
                    tmx.vivablast.peact.calculatorAmountTotal(form);

                    $('.btnEdit').off("click").on("click", function () {
                        $('.editing button').removeAttr('disabled');
                        $('.editing').removeClass('editing');

                        $(this).closest('tr').addClass('editing');
                        $('#StockId').val($('.editing .StockId').val());
                        $('#StockCode').val($('.editing .StockCode').text().trim());
                        tmx.vivablast.peact.loadStockInformation(form);
                        $('#Quantity').val($('.editing .Quantity').text());
                        $('#Discount').val($('.editing .Discount').text());
                        $('#VAT').val($('.editing .VAT').text());
                        $('#lblAmountPrice').text($('.editing .TotalPrice').text());
                        $('#fUnitPrice').val($('.editing .UnitPrice').text());
                        //tmx.vivablast.peact.loadPrice();
                        tmx.vivablast.peact.loadMrf();
                        $('#RemarkDetail').val($('.editing .Remark').text());
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
                            } else {
                                $('#hidDeleteItemDetail').val(temp + ';' + id);
                            }
                        }
                        $(this).closest('tr').remove();
                        tmx.vivablast.peact.calculatorAmountTotal(form);
                    });
                    tmx.vivablast.peact.clearStockInformation();
                    $('#bSupplierID').attr('disabled', 'disabled');
                    $('#bCurrencyTypeID').attr('disabled', 'disabled');
                    $('#iStore').attr('disabled', 'disabled');
                    $('#StockCode').val('');
                }
            });

            $('.btnEdit').off("click").on("click", function () {
                $('.editing button').removeAttr('disabled');
                $('.editing').removeClass('editing');

                $(this).closest('tr').addClass('editing');
                $('#StockId').val($('.editing .StockId').val());
                $('#StockCode').val($('.editing .StockCode').text().trim());
                tmx.vivablast.peact.loadStockInformation(form);
                $('#Quantity').val($('.editing .Quantity').text().trim());
                $('#Discount').val($('.editing .Discount').text().trim());
                $('#VAT').val($('.editing .VAT').text().trim());
                $('#lblAmountPrice').text($('.editing .TotalPrice').text().trim());
                $('#fUnitPrice').val($('.editing .UnitPrice').text().trim());
                $('#Mrf').val($('.editing .MRF').text().trim());
                //tmx.vivablast.peact.loadPrice();
                tmx.vivablast.peact.loadMrf();
                $('#RemarkDetail').val($('.editing .Remark').text());
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
                    } else {
                        $('#hidDeleteItemDetail').val(temp + ';' + id);
                    }
                }
                $(this).closest('tr').remove();
                tmx.vivablast.peact.calculatorAmountTotal(form);
            });

            $('.btnUpdateItem').off('click').on('click', function () {
                var check = tmx.vivablast.peact.checkValidateAddStock();
                if (check == true) {
                    $('#LstItem .editing').find('.StockId').val($('#StockId').val());
                    $('#LstItem .editing').find('.PriceId').val($('#priceCreateFormPO').val());
                    $('#LstItem .editing').find('.MRFId').val($('#mrfCreateFormPO').val());
                    $('#LstItem .editing').find('.StockCode').text($('#StockCode').val());
                    $('#LstItem .editing').find('.StockName').text($('#lblStockName').text());
                    $('#LstItem .editing').find('.Quantity').text($('#Quantity').val());
                    //$('#LstItem .editing').find('.UnitPrice').text($('#priceCreateFormPO option:selected').text());
                    $('#LstItem .editing').find('.UnitPrice').text($('#fUnitPrice').val());
                    $('#LstItem .editing').find('.Discount').text($('#Discount').val());
                    $('#LstItem .editing').find('.VAT').text($('#VAT').val());
                    $('#LstItem .editing').find('.TotalPrice').text($('#lblAmountPrice').text());
                    $('#LstItem .editing').find('.MRF').text($('#Mrf').val());
                    $('#LstItem .editing').find('.DeliveryDate').text($('#dDeliveryDate').val());
                    $('#LstItem .editing').find('.Remark').text($('#RemarkDetail').val());
                    $('#LstItem .editing').find('.StockType').text($('#lblStockType').text());
                    $('#LstItem .editing').find('.Unit').text($('#lblStockUnit').text());
                    tmx.vivablast.peact.calculatorAmountTotal(form);
                    tmx.vivablast.peact.clearStockInformation(form);
                    $('#StockCode').val('');
                    $('.editing button').removeAttr('disabled');
                    $('#LstItem .editing').removeClass('editing');
                    $('.btnUpdateItem').hide();
                    $('.btnAddItem').show();
                }
            });

            $('#btnSave').off('click').on('click', function () {
                var check = tmx.vivablast.peact.checkValidateSavePE();
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
                            MRFId: $(this).find('.MRF').text(),
                            //Price_Id: $(this).find('.PriceId').val(),
                            UnitPrice: $(this).find('.UnitPrice').text(),
                            Discount: $(this).find('.Discount').text(),
                            StockId: $(this).find('.StockId').val(),
                            Quantity: $(this).find('.Quantity').text(),
                            VAT: $(this).find('.VAT').text(),
                            ItemTotal: checkNumeric($(this).find('.TotalPrice').text()),
                            Remark: $(this).find('.Remark').text(),
                            Status: $(this).find('.PODetailStatus').text()
                        });
                    });

                    var dataV3 = {
                        V3: check,
                        LoginId: $('#iLogin').val(),
                        CheckCode: $('#hidCheckCode').val(),
                        PurchaseOrder: {
                            Id: $('#Id').val(),
                            vPOID: $('#vPOID').val(),
                            vProjectID: $('#vProjectID').val(),
                            bSupplierID: $('#bSupplierID').val(),
                            bPOTypeID: $('#bPOTypeID').val(),
                            bCurrencyTypeID: $('#bCurrencyTypeID').val(),
                            //dPODate: $('#dPODate').val(),
                            fPOTotal: checkNumeric($('.lblTotalAmount').text()),
                            vRemark: $('#vRemark').val(),
                            iPayment: $('#iPayment').val(),
                            vTermOfPayment: $('#Payment').val(),
                            vLocation: $('#vLocation').val(),
                            dDeliverDate: $('#dDeliverDate').val(),
                            iStore: $('#iStore').val(),
                            iExample: $("#samplePE").is(':checked') ? 1 : 0,
                            Timestamp: $('#Timestamp').val(),
                            vFromCC: $('#vFromCC').val(),
                            vFromContact: $('#vFromContact').val(),
                            Address: $('#Address').val(),
                            TaxCode: $('#TaxCode').val(),
                            vFromTel: $('#vFromTel').val(),
                            vFromFax: $('#vFromFax').val()
                        },
                        ListPoDetailData: arrDetails,
                        LstDeleteDetailItem: $('#hidDeleteItemDetail').val(),
                        sPODate: $('#dPODate').val(),
                    };
                    SaveEntity(dataV3, id);
                }
            });
        },

        loadStockInformation: function (form) {
            if ($('#bSupplierID', form).val() != "" && $('#iStore', form).val() != "" && $('#StockCode', form).val() != "" && $('#StockCode', form).val().length > 5) {
                $.ajax({
                    url: "/Ajax/PeGetStockInformation",
                    type: "POST",
                    asysn: false,
                    data: {
                        code: $('#StockCode', form).val(),
                        store: $('#iStore', form).val(),
                        supplier: $('#bSupplierID', form).val()
                    },
                    success: function (stock) {
                        $('#StockId', form).val(stock.Id);
                        $('#fQuantity', form).removeAttr('disabled');
                        $('#lblStockName', form).text(stock.Stock_Name);
                        $('#lblStockType', form).text(stock.Type);
                        $('#lblStockCategory', form).text(stock.Category);
                        $('#lblQtyPurchased', form).text('0');
                        if (stock.Quantity != null) {
                            $('#lblStockQty', form).text(stock.Quantity);
                        } else {
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
                        //tmx.vivablast.peact.loadPrice(form);
                        tmx.vivablast.peact.loadMrf(form);
                    },
                    error: function () {
                        tmx.vivablast.peact.clearStockInformation(form);
                    }
                });
            } else {
                clearVal();
                if ($('#bSupplierID', form).val() == "") {
                    $('#bSupplierID', form).after('<label id="validate" class="red">Please select Supplier!</label>');
                }
                if ($('#iStore', form).val() == "") {
                    $('#iStore', form).after('<label id="validate" class="red">Please select Store!</label>');
                }
            }
        },

        calculatorAmountPrice: function (form) {
            var unitPrice = $("#fUnitPrice").val();
            var quantity = $("#Quantity").val();
            var discount = $('#Discount').val();
            var vat = $('#VAT', form).val();
            //amountPrice = Math.round((checkNumeric($("#fUnitPrice", form).val()) * $("#Quantity", form).val()) * 100) / 100;
            var amountPrice =  unitPrice * quantity;
            if (discount > 0) {
                amountPrice = amountPrice - (amountPrice * discount / 100);
            }
            if (vat > 0) {
                amountPrice = amountPrice + (amountPrice * vat)/100;
            }
            // format thousand
            amountPrice = parseFloat(amountPrice.toFixed(decimalNum));
            console.log(amountPrice);
            var main = amountPrice.toString().replace(/\,/g, "").toString().split('.')[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            var decimal = amountPrice.toString().split('.')[1];
            var result = main;
            if (typeof decimal !== "undefined") {
                result += '.' + decimal;
            }
            $('#lblAmountPrice').text(result);
            //$('#lblAmountPrice', form).text(formatThousands(parseFloat(amountPrice).toString()));
        },

        calculatorAmountTotal: function (form) {
            var amountTotal = 0;
            $('#LstItem .vbcolum', form).each(function () {
                amountTotal = Math.floor(checkNumeric('' + amountTotal + '') * 100) / 100;
                var temp = Math.floor(checkNumeric($(this).find('.TotalPrice', form).text()) * 100) / 100;
                amountTotal = Math.round((amountTotal + temp) * 100) / 100;
            });
            $('.lblTotalAmount', form).text(formatThousands(amountTotal));
            $('.lblCurrency', form).text($('#bCurrencyTypeID option:selected').text());
        },

        loadMrf: function (form, valMrf) {
            if ($('#StockId', form).val() != 0 && $('#iStore', form).val() != '') {
                var url = "/PE/LoadMrfByStock";
                $.ajax({
                    url: url,
                    data: {
                        stock: $('#StockId', form).val(),
                        store: $('#iStore', form).val()
                    },
                    cache: false,
                    asysn: false,
                    type: "POST",
                    success: function (data) {
                        //var markup = "<option value='0'>0</option>";
                        //for (var x = 0; x < data.length; x++) {
                        //    markup += "<option value=" + data[x].Value + ">" + data[x].Text + "</option>";
                        //}
                        //$("#mrfCreateFormPO", form).html(markup);
                        //if (valMrf != '') {
                        //    $("#mrfCreateFormPO option[value='" + valMrf + "']", form).attr("selected", "selected");
                        //}
                        var markup = "";
                        for (var x = 0; x < data.length; x++) {
                            if (x == 0) {
                                markup += data[x].Text;
                            } else {
                                markup += " ; "+data[x].Text;
                            }
                        }
                        $('.mrf-suggestion').empty();
                        $(".mrf-area", form).after('<div class="mrf-suggestion"><label class="sr-only col-xs-3 control-label"></label><div class="col-sm-9">10 lastest MRF code: <b>'+markup+'</b></div></div>');
                    },
                    error: function () {
                        errorSystem();
                    }
                });
            }
        },

        loadPaymentType: function (form, supplier) {
            if (supplier != '') {
                var url = "/PE/LoadPaymentTypeBySupplier";
                $.ajax({
                    url: url,
                    data: {
                        supplier: supplier
                    },
                    cache: false,
                    asysn: false,
                    type: "POST",
                    success: function (data) {
                        $("#Payment", form).val(data);
                    },
                    error: function () {
                        errorSystem();
                    }
                });
            }
        },

        checkValidateAddStock: function (form) {
            if ($.trim($('#StockId').val()) == 0) {
                clearVal();
                $('#StockId').after('<label id="validate" class="red">Stock Code not empty.</label>');
                return false;
            }
            if ($.trim($('#fUnitPrice').val()) == "") {
                clearVal();
                $('#fUnitPrice').after('<label id="validate" class="red">Select price.</label>');
                return false;
            }
            //if ($.trim($('#priceCreateFormPO').val()) == "") {
            //    clearVal();
            //    $('#priceCreateFormPO').after('<label id="validate" class="red">Select price.</label>');
            //    return false;
            //}
            if ($.trim($('#Quantity').val()) == "" && $('#Quantity').val() == 0) {
                clearVal();
                $('#Quantity').after('<label id="validate" class="red">Quantity not empty or 0.</label>');
                return false;
            }
            if ($.trim($('#Discount').val()) > 100) {
                clearVal();
                $('#Discount').after('<label id="validate" class="red">Discount wrong.</label>');
                return false;
            }
            if ($.trim($('#VAT').val()) > 100) {
                clearVal();
                $('#VAT').after('<label id="validate" class="red">VAT wrong.</label>');
                return false;
            }
            var checkExist = true;
            // Check exist on list
            $(".StockId").each(function () {
                var a = $(this).text();
                var b = $.trim($('#StockId').val());
                if ($.trim($('#StockId').val()) == $(this).text()) {
                    checkExist = false;
                }
            });

            if (checkExist != true) {
                clearVal();
                $('.btnAddItem').after('<label id="validate" class="red">This stock exist.</label>');
                return false;
            }
            return true;
        },

        checkValidateSavePE: function (form) {
            if ($('#dPODate', form).val() == "") {
                clearVal();
                $('#dPODate', form).after('<label id="validate" class="red">Please enter PE Date.</label>');
                return false;
            }
            if ($('#bSupplierID', form).val() == "") {
                clearVal();
                $('#bSupplierID', form).after('<label id="validate" class="red">Please select Supplier.</label>');
                return false;
            }
            if ($('#bCurrencyTypeID', form).val() == "") {
                clearVal();
                $('#bCurrencyTypeID', form).after('<label id="validate" class="red">Please select Currency.</label>');
                return false;
            }
            if (typeof $("#LstItem .vbcolum .StockId", form).val() === "undefined") {
                openErrorDialog({
                    title: "Error",
                    data: "No product.Add product before save."
                });
                return false;
            }
            return true;
        },

        clearStockInformation: function (form) {
            clearVal();
            $('.lblredbol').text('');
            $('#StockId').val('');
            $('#fUnitPrice').val(0);
            $('#Quantity').val(0);
            $('#Discount').val(0);
            $('#VAT').val(0);
            $('#dDeliveryDate').val('');
            $('#RemarkDetail').val('');
            var price = "<option value=''>Select</option>";
            $("#priceCreateFormPO").html(price);
            $("#Mrf").val(0);
            $('.mrf-suggestion').remove();
            $('#lblAmountPrice').text('N/A');
        }
    };
})(jQuery, window.tmx = window.tmx || {});