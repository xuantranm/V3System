$(document).ready(function() {
    tmx.vivablast.projectact.init();
});

(function($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || { };

    tmx.vivablast.projectact = {
        init: function() {
            $('#loading-indicator').hide();
            tmx.vivablast.projectact.registerEventCreateForm();
            
            $("#vProjectID").autocomplete({
                source: "/Project/ListCode?term" + $("#vProjectID").val()
            });
            
            $("#vProjectName").autocomplete({
                source: "/Project/ListName?term" + $("#vProjectName").val()
            });

            $('#btnNewClient').on('click', function () {
                var html = '<div class="modal fade" id="dynamic-model-box" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">';
                html = html + '<div class="modal-dialog modal-md"><div class="modal-content"><div class="modal-header"><h4 class="modal-title">New Client</h4></div>';
                html = html + '<div class="modal-body"></div>';
                html = html + '<div class="modal-footer" style="text-align:center">';
                html = html + '<button type="button" id="btnYes" class="btn btn-primary enable-for-officer">Save</button>';
                html = html + '<button type="button" id="btnNo" class="btn btn-warning enable-for-officer">Close</button>';
                html = html + '</div></div> </div></div>';
                $('body').append(html);
                var modelBox = $('#dynamic-model-box');
                
                $.ajax({
                    url: '/Project/NewClient',
                    type: 'GET',
                    datatype: 'json',
                    contentType: 'application/json; charset=utf-8',
                    success: function (data) {
                        $('.modal-body').empty().append(data);
                        $("#Name", modelBox).autocomplete({
                            source: "/Project/ListNameClient?term" + $("#Name").val()
                        });
                    }
                });

                var name;
                modelBox.find('#btnYes').on('click', function () {
                    $.ajax({
                        url: '/Project/NewClient',
                        dataType: 'json',
                        async: false,
                        contentType: 'application/json',
                        type: 'POST',
                        data: ko.toJSON({
                            Name: $('#Name', modelBox).val(),
                            iCreated: $('#iLogin').val()
                        }),
                        success: function (response) {
                            name = $('#Name', modelBox).val().trim();
                            $.ajax({
                                url: '/Project/LoadClient',
                                cache: false,
                                type: "POST",
                                success: function (data) {
                                    var markup = "<option value=''>All</option>";
                                    for (var x = 0; x < data.length; x++) {
                                        markup += "<option value=" + data[x].Value + ">" + data[x].Text + "</option>";
                                    }
                                    $("#ClientId").html(markup);
                                    $("#ClientId option").filter(function () {
                                        //may want to use $.trim in here
                                        return $(this).text() == name;
                                    }).prop('selected', true);
                                },
                                error: function () {
                                    openErrorDialog({
                                        title: "Can't load Client Data",
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

        registerEventCreateForm: function() {
            $('#btnSave').off('click').on('click', function () {
                var check = tmx.vivablast.projectact.checkValidateSaveProject();
                var id = 0;
                if ($('#vProjectID').val() !== "") {
                    id = $('#vProjectID').val();
                }
                if (check == true) {
                    clearVal();
                    var dataV3 = {
                        V3: check,
                        LoginId: $('#iLogin').val(),
                        CheckName: $('#hidCheckName').val(),
                        CheckCode: $('#hidCheckCode').val(),
                        Project: {
                            Id: $('#Id').val(),
                            vProjectID : id,
                            vProjectName:$('#vProjectName').val(),
                            vLocation: $('#vLocation').val(),
                            vMainContact: $('#vMainContact').val(),
                            vCompanyName: $('#vCompanyName').val(),
                            dBeginDate: $('#dBeginDate').val(),
                            dEnd: convertDateToMMDDYYYY($('#dEnd').val()),
                            StatusId: $('#StatusId').val(),
                            ClientId: $('#ClientId').val(),
                            CountryId: $('#CountryId').val(),
                            vDescription: $('#vDescription').val(),
                            Timestamp: $('#Timestamp').val()
                        },
                        dBeginDate: $('#dBeginDate').val(),
                        dEnd: $('#dEnd').val(),
                    };
                    
                    SaveEntity(dataV3, id);
                }
            });
        },

        checkValidateSaveProject: function () {
            clearVal();
            if ($.trim($('#vProjectID').val()) == "") {
                $('#vProjectID').focus();
                $('#vProjectID').addClass('errorClass');
                $('#vProjectID').after('<label id="validate" class="errorLabel">Please enter Project Code.</label>');
                return false;
            }
            if ($.trim($('#vProjectName').val()) == "") {
                $('#vProjectName').focus();
                $('#vProjectName').addClass('errorClass');
                $('#vProjectName').after('<label id="validate" class="errorLabel">Please enter Project Name.</label>');
                return false;
            }
            if ($.trim($('#vLocation').val()) == "") {
                $('#vLocation').focus();
                $('#vLocation').addClass('errorClass');
                $('#vLocation').after('<label id="validate" class="errorLabel">Please enter Location.</label>');
                return false;
            }
            if ($.trim($('#vCompanyName').val()) == "") {
                $('#vCompanyName').focus();
                $('#vCompanyName').addClass('errorClass');
                $('#vCompanyName').after('<label id="validate" class="errorLabel">Please enter Company Name.</label>');
                return false;
            }
            if ($.trim($('#vMainContact').val()) == "") {
                $('#vMainContact').focus();
                $('#vMainContact').addClass('errorClass');
                $('#vMainContact').after('<label id="validate" class="errorLabel">Please enter Main Contact.</label>');
                return false;
            }
            if ($.trim($('#dBeginDate').val()) == "") {
                $('#dBeginDate').focus();
                $('#dBeginDate').addClass('errorClass');
                $('#dBeginDate').after('<label id="validate" class="errorLabel">Please enter Begin Date.</label>');
                return false;
            }
            return true;
        }
    };
})(jQuery, window.tmx = window.tmx || { });