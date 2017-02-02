$(document).ready(function() {
    tmx.vivablast.priceact.init();
    // Format
    $('#Price').val(parseFloat($('#Price').val()));
});

(function($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || { };

    tmx.vivablast.priceact = {
        init: function() {
            $('#loading-indicator').hide();
            tmx.vivablast.priceact.registerEventCreateForm();
        },

        registerEventCreateForm: function () {
            var form = $('#price-create-form');

            searchStockFunction.init('all');

            $('#StockCode', form).keydown(function () {
                clearVal();
            });

            $('#StockCode', form).blur(function () {
                tmx.vivablast.priceact.loadStockInformation(form);
            });

            $('#StockCode', form).bind("enterKey", function (e) {
                tmx.vivablast.priceact.loadStockInformation(form);
            });

            $('#StockCode', form).keyup(function (e) {
                if (e.keyCode == 13) {
                    $(this).trigger("enterKey");
                }
            });

            $('#StoreId', form).on('change', function (e) {
                tmx.vivablast.priceact.loadStockInformation(form);
            });

            $('#btnSave').off('click').on('click', function () {
                var check = tmx.vivablast.priceact.checkValidateSavePrice();
                if (check == true) {
                    clearVal();
                    var dataV3 = {
                        V3: check,
                        LoginId: $('#iLogin').val(),
                        ProductPrice: {
                            Id: $('#Id').val(),
                            StockId: $('#StockId').val(),
                            Price: $('#Price').val(),
                            CurrencyId: $('#CurrencyId').val(),
                            SupplierId: $('#SupplierId').val(),
                            StoreId: $('#StoreId').val(),
                            dStart: convertDateToMMDDYYYY($('#dStart').val()),
                            dEnd: convertDateToMMDDYYYY($('#dEnd').val()),
                            Timestamp: $('#Timestamp').val()
                        },
                        dStartTemp: convertDateToMMDDYYYY($('#dStart').val()),
                        dEndTemp: convertDateToMMDDYYYY($('#dEnd').val())
                    };
                    
                    SaveEntity(dataV3, $('#Id').val());
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
                        $('#lblStockName', form).text(stock.Stock_Name);
                        $('#lblStockType', form).text(stock.Type);
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
                    },
                    error: function () {
                        tmx.vivablast.priceact.clearStockInformation(form);
                    }
                });
            }
        },

        checkValidateSavePrice: function () {
            if ($.trim($('#StockCode').val()) == "") {
                clearVal();
                $('#StockCode').after('<label id="validate" class="red">Stock Code can\'t empty.</label>');
                return false;
            }
            if ($.trim($('#Price').val()) == "") {
                clearVal();
                $('#Price').after('<label id="validate" class="red">Price can\'t empty.</label>');
                return false;
            }
            if ($.trim($('#CurrencyId').val()) == "") {
                clearVal();
                $('#CurrencyId').after('<label id="validate" class="red">Please select Currency.</label>');
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
            clearVal();
        }
    };
})(jQuery, window.tmx = window.tmx || { });