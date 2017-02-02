$(document).ready(function() {
    tmx.vivablast.stocktypeaction.init();
});

(function($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || { };

    tmx.vivablast.stocktypeaction = {
        init: function () {
            $('#loading-indicator').hide();
            tmx.vivablast.stocktypeaction.registerEventCreateForm();
            
            $("#TypeName").autocomplete({
                source: "/StockType/ListName?term" + $("#TypeName").val()
            });
            
            $("#TypeCode").autocomplete({
                source: "/StockType/ListCode?term" + $("#TypeCode").val()
            });
        },

        registerEventCreateForm: function() {
            $('#btnSave').off('click').on('click', function () {
                var check = tmx.vivablast.stocktypeaction.checkValidateSaveEntity();
                
                var id = 0;
                if ($('#Id').val() !== "") {
                    id = $('#Id').val();
                }
                if (check == true) {
                    clearVal();
                    var dataV3 = {
                        V3: check,
                        LoginId: $('#iLogin').val(),
                        CheckCode: $('#hidCheckCode').val(),
                        CheckName: $('#hidCheckName').val(),
                        Entity: {
                            Id: id,
                            TypeName: $('#TypeName').val(),
                            TypeCode: $('#TypeCode').val(),
                            Timestamp: $('#Timestamp').val()
                        }
                    };
                    
                    SaveEntity(dataV3, id);
                }
            });
        },

        checkValidateSaveEntity: function () {
            clearVal();
            if ($.trim($('#TypeName').val()) == "") {
                $('#TypeName').focus();
                $('#TypeName').addClass('errorClass');
                $('#TypeName').after('<label id="validate" class="errorLabel">Name can\'t empty.</label>');
                return false;
            }
            if ($.trim($('#TypeCode').val()) == "") {
                $('#TypeCode').focus();
                $('#TypeCode').addClass('errorClass');
                $('#TypeCode').after('<label id="validate" class="errorLabel">Code can\'t empty.</label>');
                return false;
            }
            return true;
        }
    };
})(jQuery, window.tmx = window.tmx || { });