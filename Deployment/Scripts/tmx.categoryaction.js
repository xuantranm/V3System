$(document).ready(function() {
    tmx.vivablast.categoryaction.init();
});

(function($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || { };

    tmx.vivablast.categoryaction = {
        init: function () {
            $('#loading-indicator').hide();
            tmx.vivablast.categoryaction.registerEventCreateForm();
            
            $("#CategoryCode").autocomplete({
                source: "/Category/ListCode?term" + $("#CategoryCode").val()
            });
            
            $("#vCategoryName").autocomplete({
                source: "/Category/ListName?term" + $("#vCategoryName").val()
            });
        },

        registerEventCreateForm: function() {
            $('#btnSave').off('click').on('click', function () {
                var check = tmx.vivablast.categoryaction.checkValidateSaveEntity();
                
                var id = 0;
                if ($('#bCategoryID').val() !== "") {
                    id = $('#bCategoryID').val();
                }
                if (check == true) {
                    clearVal();
                    var dataV3 = {
                        V3: check,
                        LoginId: $('#iLogin').val(),
                        CheckCode: $('#hidCheckCode').val(),
                        CheckName: $('#hidCheckName').val(),
                        Entity: {
                            bCategoryID: id,
                            iType: $('#iType').val(),
                            vCategoryType: $('#iType option:selected').text(),
                            vCategoryName: $('#vCategoryName').val(),
                            CategoryCode: $('#CategoryCode').val(),
                            Timestamp: $('#Timestamp').val()
                        }
                    };
                    
                    SaveEntity(dataV3, id);
                }
            });
        },

        checkValidateSaveEntity: function () {
            clearVal();
            if ($.trim($('#iType').val()) == "") {
                $('#iType').focus();
                $('#iType').addClass('errorClass');
                $('#iType').after('<label id="validate" class="errorLabel">Please select Type.</label>');
                return false;
            }
            if ($.trim($('#vCategoryName').val()) == "") {
                $('#vCategoryName').focus();
                $('#vCategoryName').addClass('errorClass');
                $('#vCategoryName').after('<label id="validate" class="errorLabel">Name can\'t empty.</label>');
                return false;
            }
            if ($.trim($('#CategoryCode').val()) == "") {
                $('#CategoryCode').focus();
                $('#CategoryCode').addClass('errorClass');
                $('#CategoryCode').after('<label id="validate" class="errorLabel">Code can\'t empty.</label>');
                return false;
            }
            return true;
        }
    };
})(jQuery, window.tmx = window.tmx || { });