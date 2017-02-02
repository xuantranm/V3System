$(document).ready(function() {
    tmx.vivablast.serviceact.init();
});

(function($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || { };

    tmx.vivablast.serviceact = {
        init: function(uid) {
            $('#loading-indicator').hide();
            tmx.vivablast.serviceact.registerEventCreateForm(uid);
            $("#vIDServiceItem").autocomplete({
                source: "/Service/ListCode?term" + $("#vIDServiceItem").val(),
            });
            $("#vServiceItemName").autocomplete({
                source: "/Service/ListName?term" + $("#vServiceItemName").val(),
            });
        },

        registerEventCreateForm: function() {
            $('#btnSave').off('click').on('click', function() {
                var check = tmx.vivablast.serviceact.checkValidateSave();
                var id = $('#Id').val();
                if (check == true) {
                    clearVal();
                    var dataV3 = {
                        V3: check,
                        Id: id,
                        vIDServiceItem: $('#vIDServiceItem').val(),
                        vServiceItemName: $('#vServiceItemName').val(),
                        vDescription: $('#vDescription').val(),
                        bCategoryID: $('#bCategoryID').val(),
                        bUnitID: $('#bUnitID').val(),
                        StoreId: $('#StoreId').val(),
                        bPositionID: $('#bPositionID').val(),
                        bWeight: $('#bWeight').val(),
                        vAccountCode: $('#vAccountCode').val(),
                        dCreated: $('#dCreated').val(),
                        iCreated: $('#iCreated').val(),
                        Timestamp: $('#Timestamp').val()
                    };
                    SaveEntity(dataV3, id);
                }
            });
        },

        checkValidateSave: function() {
            if ($.trim($('#vIDServiceItem').val()) == "") {
                clearVal();
                $('#vIDServiceItem').after('<div class="clearboth"></div><label id="validate" class="red">Code can\'t empty.</label>');
                return false;
            }
            if ($.trim($('#vServiceItemName').val()) == "") {
                clearVal();
                $('#vServiceItemName').after('<div class="clearboth"></div><label id="validate" class="red">Name can\'t empty.</label>');
                return false;
            }
            return true;
        }
    };
})(jQuery, window.tmx = window.tmx || { });