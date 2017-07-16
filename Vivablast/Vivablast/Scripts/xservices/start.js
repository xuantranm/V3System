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

    autosize($('.auto-size'));
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
