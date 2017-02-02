$(document).ready(function () {
    tmx.vivablast.useraction.init();

    $('#Password').keyup(function () {
        var ucase = new RegExp("[A-Z]+");
        var lcase = new RegExp("[a-z]+");
        var num = new RegExp("[0-9]+");

        if ($("#Password").val().length >= 8) {
            $("#8char").removeClass("glyphicon-remove");
            $("#8char").addClass("glyphicon-ok");
            $("#8char").css("color", "#00A41E");
        } else {
            $("#8char").removeClass("glyphicon-ok");
            $("#8char").addClass("glyphicon-remove");
            $("#8char").css("color", "#FF0004");
        }

        if (ucase.test($("#Password").val())) {
            $("#ucase").removeClass("glyphicon-remove");
            $("#ucase").addClass("glyphicon-ok");
            $("#ucase").css("color", "#00A41E");
        } else {
            $("#ucase").removeClass("glyphicon-ok");
            $("#ucase").addClass("glyphicon-remove");
            $("#ucase").css("color", "#FF0004");
        }

        if (lcase.test($("#Password").val())) {
            $("#lcase").removeClass("glyphicon-remove");
            $("#lcase").addClass("glyphicon-ok");
            $("#lcase").css("color", "#00A41E");
        } else {
            $("#lcase").removeClass("glyphicon-ok");
            $("#lcase").addClass("glyphicon-remove");
            $("#lcase").css("color", "#FF0004");
        }

        if (num.test($("#Password").val())) {
            $("#num").removeClass("glyphicon-remove");
            $("#num").addClass("glyphicon-ok");
            $("#num").css("color", "#00A41E");
        } else {
            $("#num").removeClass("glyphicon-ok");
            $("#num").addClass("glyphicon-remove");
            $("#num").css("color", "#FF0004");
        }
    });

    $('#RePassword').keyup(function () {
        if ($("#Password").val() == $("#RePassword").val()) {
            $("#pwmatch").removeClass("glyphicon-remove");
            $("#pwmatch").addClass("glyphicon-ok");
            $("#pwmatch").css("color", "#00A41E");
        } else {
            $("#pwmatch").removeClass("glyphicon-ok");
            $("#pwmatch").addClass("glyphicon-remove");
            $("#pwmatch").css("color", "#FF0004");
        }
    });

    $('#Email').keyup(function () {
        if ($.trim($('#Email').val()) == "") {
            $("#emok").removeClass("glyphicon-ok");
            $("#emok").addClass("glyphicon-remove");
            $("#emok").css("color", "#FF0004");
            return false;
        }
        if (!validateEmail($.trim($('#Email').val()))) {
            $("#emok").removeClass("glyphicon-ok");
            $("#emok").addClass("glyphicon-remove");
            $("#emok").css("color", "#FF0004");
            return false;
        }
        if ($('#hidEmailCurrent').val() !== $('#Email').val()) {
            var url = "/User/CheckEmail";
            $.ajax({
                url: url,
                data: {
                    email: $('#Email').val(),
                    currentEmail: $('#hidEmailCurrent').val()
                },
                cache: false,
                type: "POST",
                success: function (data) {
                    if (data.result === true) {
                        $("#emok").removeClass("glyphicon-remove");
                        $("#emok").addClass("glyphicon-ok");
                        $("#emok").css("color", "#00A41E");
                    } else {
                        $("#emok").removeClass("glyphicon-ok");
                        $("#emok").addClass("glyphicon-remove");
                        $("#emok").css("color", "#FF0004");
                    }
                },
                error: function () {
                    openErrorDialog({
                        title: "Can't check Current Password.",
                        data: "Please contact Administrator support."
                    });
                }
            });
        }
    });
});

(function ($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.useraction = {
        init: function () {
            tmx.vivablast.useraction.registerEventCreateForm();
            // tmx.vivablast.useraction.loadDepartment();
            $("#UserName").autocomplete({
                source: "/User/ListUserName?term" + $("#UserName").val()
            });
            $("#Email").autocomplete({
                source: "/User/ListEmail?term" + $("#Email").val()
            });
        },

        registerEventCreateForm: function () {
            $('#btnChangePw').off('click').on('click', function () {
                $('#changePassArea').toggle();
                $('#btnNotChangePw').toggle();
                $('#btnChangePw').toggle();
            });

            $('#btnNotChangePw').off('click').on('click', function () {
                $('#changePassArea').toggle();
                $('#btnNotChangePw').toggle();
                $('#btnChangePw').toggle();
            });

            $('#btnSave').off('click').on('click', function () {
                var id = 0;
                if ($('#UserId').val() !== "") {
                    id = $('#Id').val();
                }
                var check = tmx.vivablast.useraction.checkValidateSaveUser();
                if (check == true) {
                    clearVal();
                    var dataV3 = {
                        V3: check,
                        CheckName: $('#hidCheckName').val(),
                        EmailCurrent: $('#hidEmailCurrent').val(),
                        LoginId: $('#iLogin').val(),
                        PasswordCurrent: $('#hidPasswordCurrent').val(),
                        Entity: {
                            Id: id,
                            UserName: $('#UserName').val(),
                            Password: $('#Password').val(),
                            FirstName: $('#FirstName').val(),
                            LastName: $('#LastName').val(),
                            Department: $("#DepartmentId option:selected").text(),
                            DepartmentId: $('#DepartmentId').val(),
                            Telephone: $('#Telephone').val(),
                            Mobile: $('#Mobile').val(),
                            Email: $('#Email').val(),
                            StoreId: $('#StoreId').val(),
                            Store: $("#StoreId option:selected").text(),
                            UserR: $('#UserR').val(),
                            ProjectR: $('#ProjectR').val(),
                            StoreR: $('#StoreR').val(),
                            StockR: $('#StockR').val(),
                            RequisitionR: $('#RequisitionR').val(),
                            StockInR: $('#StockInR').val(),
                            StockOutR: $('#StockOutR').val(),
                            StockReturnR: $('#StockReturnR').val(),
                            ReActiveStockR: $("#ReActiveStockR").val(),
                            StockTypeR: $("#StockTypeR").val(),
                            CategoryR: $("#CategoryR").val(),
                            PER: $('#PER').val(),
                            SupplierR: $('#SupplierR').val(),
                            PriceR: $('#PriceR').val(),
                            StockServiceR: $('#StockServiceR').val(),
                            AccountingR: $('#AccountingR').val(),
                            MaintenanceR: $('#MaintenanceR').val(),
                            Timestamp: $('#Timestamp').val()
                        }
                    };

                    $.ajax({
                        url: $('#hidSaveUrl').val(),
                        dataType: 'json',
                        contentType: 'application/json',
                        type: 'POST',
                        data: ko.toJSON(dataV3),
                        success: function (response) {
                            if (response.result === $('#hidSuccess').val()) {
                                successNotice(id);
                            } else if (response.result == $('#hidDuplicate').val()) {
                                clearVal();
                                openYesNoDialog({
                                    sectionTitle: "Error: Name is used",
                                    title: "Yes: go to list page.<br>No: stay this page.",
                                    data: '',
                                    yesCallback: function () {
                                        var controller = $('#controller').val().toLowerCase();
                                        window.location.href = 'http://' + window.location.host + '/' + controller;
                                    },
                                    noCallback: function () {
                                    }
                                });
                            } else if (response.result == "Email duplicated") {
                                clearVal();
                                openYesNoDialog({
                                    sectionTitle: "Error: Email is used",
                                    title: "Yes: go to list page.<br>No: stay this page.",
                                    data: '',
                                    yesCallback: function () {
                                        var controller = $('#controller').val().toLowerCase();
                                        window.location.href = 'http://' + window.location.host + '/' + controller;
                                    },
                                    noCallback: function () {
                                    }
                                });
                            } else if (response.result === $('#hidDataJustChanged').val()) {
                                clearVal();
                                openYesNoDialog({
                                    sectionTitle: "Error: Data changed by another.",
                                    title: "Yes: go previous page.<br>No: refresh new data",
                                    data: '',
                                    yesCallback: function () {
                                        var controller = $('#controller').val().toLowerCase();
                                        window.location.href = 'http://' + window.location.host + '/' + controller;
                                    },
                                    noCallback: function () {
                                        location.reload();
                                    }
                                });
                            } else {
                                clearVal();
                                openYesNoDialog({
                                    sectionTitle: "System error. Contact IT to support.",
                                    title: "Yes: go to list page.<br>No: stay this page.",
                                    data: '',
                                    yesCallback: function () {
                                        var controller = $('#controller').val().toLowerCase();
                                        window.location.href = 'http://' + window.location.host + '/' + controller;
                                    },
                                    noCallback: function () {
                                    }
                                });
                            }
                        }
                    });
                }
            });
        },

        checkValidateSaveUser: function () {
            clearVal();
            if ($.trim($('#StoreId').val()) == "") {
                $('#StoreId').focus();
                $('#StoreId').addClass('errorClass');
                $('#StoreId').after('<label id="validate" class="errorLabel">Please select Store.</label>');
                return false;
            }
            if ($.trim($('#UserName').val()) == "") {
                $('#UserName').focus();
                $('#UserName').addClass('errorClass');
                $('#UserName').after('<label id="validate" class="errorLabel">Field not blank.</label>');
                return false;
            }
            if ($('#Password').is(":visible")) {
                if ($('span').hasClass('glyphicon-remove')) {
                    $('#Password').focus();
                    $('#Password').addClass('errorClass');
                    return false;
                }
            }
            if ($.trim($('#FirstName').val()) == "") {
                $('#FirstName').focus();
                $('#FirstName').addClass('errorClass');
                $('#FirstName').after('<label id="validate" class="errorLabel">Field not blank.</label>');
                return false;
            }
            if ($.trim($('#LastName').val()) == "") {
                $('#LastName').focus();
                $('#LastName').addClass('errorClass');
                $('#LastName').after('<label id="validate" class="errorLabel">Field not blank.</label>');
                return false;
            }
            return true;
        }
    };
})(jQuery, window.tmx = window.tmx || {});