$(document).ready(function() {
    tmx.vivablast.storeact.init();
});

(function($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || { };

    tmx.vivablast.storeact = {
        init: function () {
            $('#loading-indicator').hide();
            tmx.vivablast.storeact.registerEventCreateForm();
            
            $("#Code").autocomplete({
                source: "/Store/ListCode?term" + $("#Code").val()
            });
            
            $("#Name").autocomplete({
                source: "/Store/ListName?term" + $("#Name").val()
            });
        },

        registerEventCreateForm: function() {
            $('#btnSave').off('click').on('click', function () {
                var check = tmx.vivablast.storeact.checkValidateSaveStore();
                
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
                        Store: {
                            Id: id,
                            CountryId: $('#CountryId').val(),
                            Name: $('#Name').val(),
                            Code: $('#Code').val(),
                            Address: $('#Address').val(),
                            //Tel: $('#Tel').val(),
                            //Phone: $('#Phone').val(),
                            //Description: $('#Description').val(),
                            Timestamp: $('#Timestamp').val()
                        }
                    };
                    
                    SaveEntity(dataV3, id);
                }
            });
        },

        checkValidateSaveStore: function () {
            clearVal();
            if ($.trim($('#CountryId').val()) == "") {
                $('#CountryId').focus();
                $('#CountryId').addClass('errorClass');
                $('#CountryId').after('<label id="validate" class="errorLabel">Please select Country.</label>');
                return false;
            }
            if ($.trim($('#Name').val()) == "") {
                $('#Name').focus();
                $('#Name').addClass('errorClass');
                $('#Name').after('<label id="validate" class="errorLabel">Name can\'t empty.</label>');
                return false;
            }
            if ($.trim($('#Code').val()) == "") {
                $('#Code').focus();
                $('#Code').addClass('errorClass');
                $('#Code').after('<label id="validate" class="errorLabel">Code can\'t empty.</label>');
                return false;
            }
            return true;
        }
    };
})(jQuery, window.tmx = window.tmx || { });