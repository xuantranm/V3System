$(document).ready(function () {
    $(document).on("keydown", function (e) {
        if (e.which === 8 && !$(e.target).is("input, textarea")) {
            e.preventDefault();
        }
    });

    loadMenu();

    $('.input-group.date').datepicker({
        format: "dd/mm/yyyy",
        autoclose: true,
        todayHighlight: true
    });

    $('.datepicker').datepicker({
        format: "dd/mm/yyyy",
        autoclose: true,
        todayHighlight: true
    });

    $(".multiselect").multiselect({
        enableClickableOptGroups: true
    });

    $('.quantity-input').on('keyup blur change', function (event) {
        if (event.which == 13 || (event.which >= 16 && event.which <= 18) || (event.which >= 37 && event.which <= 40)) return;
        if (event.ctrlKey && (event.which == 65 || event.which == 67 || event.which == 86)) return;

        var thisVal = $(this).val().replace(',', '.');
        var regex = /^\d+(\.\d{0,2})?$/g;
        if (!regex.test(thisVal)) {
            thisVal = '';
        } 
        this.value = thisVal;
    });

    autosize($('.auto-size'));

    $("#searchStockCode").autocomplete({
        source: "/Stock/ListCode?term" + $("#searchStockCode").val()
    });

    $("#searchStockName").autocomplete({
        source: "/Stock/ListName?term" + $("#searchStockName").val()
    });

    $("#searchStockCode").on("keyup blur change", function (event) {
        var form = $(this).closest('form');
        if ($(this).val() != '' || $(this).val() != 'Not found') {
            loadStockName(form, $(this), $('#searchStockName'));
        }
    });

    $("#searchStockName").on("keyup blur change", function (event) {
        var form = $(this).closest('form');
        if ($(this).val() != '' || $(this).val() != 'Not found') {
            loadStockCode(form, $(this), $('#searchStockCode'));
        }
    });

    $('#searchStockType').on('change', function (e) {
        var typeId = 0;
        if ($(this).val() !== "") {
            typeId = $(this).val();
        }
        var url = "/Stock/LoadCategoryByType";
        $.ajax({
            url: url,
            data: { type: typeId },
            cache: false,
            type: "POST",
            success: function (data) {
                var markup = "<option value=''>All</option>";
                for (var x = 0; x < data.length; x++) {
                    markup += "<option value=" + data[x].Value + ">" + data[x].Text + "</option>";
                }
                $("#searchStockCategory").html(markup);
                //$("#searchStockCategory").trigger("chosen:updated");
            },
            error: function () {
                openErrorDialog({
                    title: "Can't load Category Data",
                    data: "Please contact Administrator support."
                });
            }
        });
    });
});

function loadMenu() {
    $.ajax({
        url: '/Home/LoadMenu',
        type: 'GET',
        asysn: true,
        datatype: 'json',
        contentType: 'application/json; charset=utf-8',
        success: function (data) {
            if (data.length != 0) {
                $('#bs-navbar').empty().append(data);
            }
            activeMenu();
            loadSystemInformation();
        },
        error: function () {
            errorSystem();
        }
    });
}

function activeMenu() {
    var controller = $('#controller').val().toLowerCase();
    switch (controller) {
        case 'user':
            $('#userMenu').addClass('active');
            break;
        case 'project':
            $('#projectMenu').addClass('active');
            break;
        case 'store':
            $('#storeMenu').addClass('active');
            $('#storeMenuSub').addClass('active');
            break;
        case 'stock':
            $('#storeMenu').addClass('active');
            $('#stockMenuSub').addClass('active');
            break;
        case 'requisition':
            $('#storeMenu').addClass('active');
            $('#requisitionMenuSub').addClass('active');
            break;
        case 'stockreturn':
            $('#storeMenu').addClass('active');
            $('#stockreturnMenuSub').addClass('active');
            break;
        case 'stockout':
            $('#storeMenu').addClass('active');
            $('#stockoutMenuSub').addClass('active');
            break;
        case 'stockin':
            $('#storeMenu').addClass('active');
            $('#stockinMenuSub').addClass('active');
            break;
        case 'reactivestock':
            $('#storeMenu').addClass('active');
            $('#reactivestockMenuSub').addClass('active');
            break;

        case 'pe':
            $('#procurementMenu').addClass('active');
            $('#peMenuSub').addClass('active');
            break;
        case 'supplier':
            $('#procurementMenu').addClass('active');
            $('#supplierMenuSub').addClass('active');
            break;
        case 'price':
            $('#procurementMenu').addClass('active');
            $('#priceMenuSub').addClass('active');
            break;
        case 'service':
            $('#procurementMenu').addClass('active');
            $('#serviceMenuSub').addClass('active');
            break;
        case 'accounting':
            $('#accountingMenu').addClass('active');
            break;
    }
}

function loadSystemInformation() {
    //$('#systemWelcome').html("Welcome <b>" + $('#systemLastName').val() + " " + $('#systemFirstName').val() + " (" + $('#systemUserName').val() + ")" + "</b>");
    $('.systemWelcome').html($('#systemUserName').val());
    var pathArray = window.location.pathname;
    var lenghPathArray = pathArray.length;
    var secondLevelLocation = pathArray.substring(1, lenghPathArray);
    //$('#systemPageInformation').html(secondLevelLocation);
}

function getAppParams() {
    return '?rand=' + randomString(8);
}

function addAppParams(url) {
    if (url.indexOf('?') == -1) return url + getAppParams();
    return url;
}

function logOut() {
    //account/logoff
    openYesNoDialog({
        title: "Are you sure to log out!",
        data: '',
        yesCallback: function () {
            window.location = '/login/signout';
        },
        noCallback: function () {
        }
    });
}

var config = {
    '.chosen-select': {},
    '.chosen-select-deselect': { allow_single_deselect: true },
    '.chosen-select-no-single': { disable_search_threshold: 10 },
    '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
    '.chosen-select-width': { width: "95%" }
};

for (var selector in config) {
    $(selector).chosen(config[selector]);
}

