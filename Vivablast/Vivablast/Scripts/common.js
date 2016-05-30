/*
    name: ajaxPostJson
    description: Using for post ajax with json data
    author: Nam Hoang
*/

function ajaxPostJson(options) {
    var settings = $.extend({
        url: null,
        data: null,
        showLoading: true,
        beforeSubmit: null,
        success: null,
        error: null,
        sender: null,
        dataType: 'json'
    }, options);

    var sender = options.sender;

    //validate before submitting
    if (settings.beforeSubmit != null && !settings.beforeSubmit()) return;

    if (settings.showLoading && sender != null) actingButton(sender);
    //submit the form
    $.post(addAppParams(settings.url), options.data,
        function (response) {
            if (settings.showLoading && sender != null) reloadButton(sender);
            if (settings.success != null) settings.success(response);
        }
    ).error(function (xhr, textStatus, error) {
        if (settings.showLoading && sender != null) reloadButton(sender);
        if (settings.error != null) settings.error();
    });
}

/*
    name: ajaxGetHtml
    description: Using ajax to get html data
    author: Nam Hoang
*/

function ajaxGetHtml(options) {
    var settings = $.extend({
        url: null,
        data: null,
        showLoading: true,
        beforeSubmit: null,
        success: null,
        error: null,
        sender: null,
        dataType: 'json'
    }, options);

    var sender = options.sender;

    //validate before submitting
    if (settings.beforeSubmit != null && !settings.beforeSubmit()) return;

    if (settings.showLoading && sender != null) actingButton(sender);

    //submit the form
    //settings.url += '&rand=' + randomString(8);
    $.get(addAppParams(settings.url) + '&rand=' + randomString(8), options.data,
        function (response) {
            if (settings.showLoading && sender != null) reloadButton(sender);
            if (settings.success != null) settings.success(response);
        }
    ).error(function (xhr, textStatus, error) {
        if (settings.showLoading && sender != null) reloadButton(sender);
        if (settings.error != null) settings.error();
    });
}

$(document).ajaxSend(function () {
    $('#loading-indicator').show();
});

$(document).ajaxComplete(function () {
    $('#loading-indicator').hide();
});

var processing = false;

function actingButton(element, requireLogin) {
    if (requireLogin && !window.loggedIn) {
        alert('Please login to continue');
        return true;
    }
    if (processing || $(element).hasClass('disabled')) {
        return true;
    }

    processing = true;
    $(element).attr('data-originhtml', $(element).html()).prop('disabled', true).html('Processing...');

    return false;
}

function reloadButton(element, setDisable) {
    processing = false;
    $(element).html($(element).attr('data-originhtml')).prop('disabled', false);
    if (setDisable)
        $(element).addClass('disabled');
}

function showLoading() {
    $('body').addClass('loading');
}

function hideLoading() {
    $('body').removeClass('loading');
}

function showAlert(message) {
    $('#alert-modal-body').html(message);
    $('#alert-modal').modal();
}

function showMessage(message, error, title) {
    var $globalmsg = window.parent.$('#global-message');
    //message type
    if (!error) $globalmsg.addClass('success');
    else $globalmsg.removeClass('success');

    //bind content
    $globalmsg.html((title == undefined ? '' : '<div>' + title + '</div>') + message);

    //calculate position and show message
    var left = window.parent.$(window).width() / 2 - $globalmsg.width() / 2;
    $globalmsg.css('left', left + 'px').hide().slideDown();
}

function hideMessage() {
    $('#global-message').empty().slideUp();
}

function clearVal() {
    $('label[id^="val"]').remove();
    $('.alert-error').hide();
    //$("input[id^='input']").removeClass('errorClass');
    $("input").removeClass('errorClass');
    $("select").removeClass('errorClass');
    $('.errorLabel').remove();
    $('.alert').addClass("hide");
}

function CloseCustom() {
    $('.popup-box').detach();
    $('#overlay').detach();
}

function CloseSecondPopup() {
    $('.popupsecond').closest('.popup-box').detach();
}

function SaveSuccess(timeTamp) {
    $('#btnSave').before('<label id="validate" class="red" style="margin-right:10px">Save Successful.</label>');
    $('#btnSave').before('<button id="btnUpdate" type="button" class="btn btn-primary ' + timeTamp + '" data-dismiss="modal">Update</button>');
    $('#btnSave').before('<button id="btnNew" type="button" class="btn btn-primary ' + timeTamp + '" data-dismiss="modal">New</button>');
    $('#btnSave').hide();
    $('.popup-box input').attr("disabled", "true");
    $('.popup-box select').attr("disabled", "true");
}

function EmtyField() {
    $('input').removeAttr("disabled");
    $('select').removeAttr("disabled");

    $('#validate').remove();
    $('input:text').val('');
    $('input:password').val('');
    $('input:radio').removeAttr('checked');
    var $radios = $('input:radio');
    if ($radios.is(':checked') === false) {
        $radios.filter('[value=0]').prop('checked', true);
    }
    $('input:checkbox').attr('checked', false);
    $('select').val('');

    $('#btnSave').show();
}

function UpdateInput() {
    $('.popup-box input').removeAttr("disabled");
    $('.popup-box select').removeAttr("disabled");
    $('#validate').remove();
}

function UpdateInputSave() {
    $('#btnSave').show();
    $('#btnUpdate').hide();
    $('#btnNew').hide();
}

function NewInput() {
    UpdateInput();
    $('.popup-box input:text').val('');
    $('.popup-box input:password').val('');
    $('.popup-box input:radio').removeAttr('checked');
    var $radios = $('.popup-box input:radio');
    if ($radios.is(':checked') === false) {
        $radios.filter('[value=0]').prop('checked', true);
    }
    $('.popup-box input:checkbox').attr('checked', false);
    $('.popup-box select').val('');
    UpdateInputSave();
}

function checkNumeric(objName) {
    var lstLetters = objName;
    return lstLetters.replace(/\,/g, '');
}

function validateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

function validatePhone(phone) {
    var filter = /^[0-9-+]+$/;
    if (filter.test(phone)) {
        return true;
    }
    else {
        return false;
    }
};

function formatNumber(number) {
    number = number.toFixed(2) + '';
    x = number.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
}

function formatDecimal(input) {
    if (!isNaN(parseFloat(input))) {
         return parseFloat(input).toFixed(2);
    }
    return input;
}

function addCommas(nStr) {
    nStr += '';
    x = nStr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
};

// Formatting function for outputting numbers with separator.
function numberWithSeparator(x, separator, decimals, decimal_separator) {
    x = x.toFixed(decimals);
    x = x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, separator);
    if (decimals > 0 && decimal_separator == ',') {
        x = x.substring(0, x.lastIndexOf(".")) + ',' + x.substring(x.lastIndexOf(".") + 1);
    }
    return x;
}

function formatThousands(n, dp) {
    var s = '' + (Math.floor(n)), d = n % 1, i = s.length, r = '';
    while ((i -= 3) > 0) { r = ',' + s.substr(i, 3) + r; }
    return s.substr(0, i + 3) + r + (d ? '.' + Math.round(d * Math.pow(10, dp || 2)) : '');
}

function getDateFormatmmddyyyy() {
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1; //January is 0!
    var yyyy = today.getFullYear();

    if (dd < 10) {
        dd = '0' + dd;
    }

    if (mm < 10) {
        mm = '0' + mm;
    }

    return mm + '/' + dd + '/' + yyyy;
}

function getDateFormatddmmyyyy() {
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1; //January is 0!
    var yyyy = today.getFullYear();

    if (dd < 10) {
        dd = '0' + dd;
    }

    if (mm < 10) {
        mm = '0' + mm;
    }

    return dd + '/' + mm + '/' + yyyy;
}

function resolveUrl(url) {
    return $('#resolve-url').val() + url;
}

function htmlEncode(value) {
    //create a in-memory div, set it's inner text(which jQuery automatically encodes)
    //then grab the encoded contents back out.  The div never exists on the page.
    return $('<div/>').text(value).html();
}

function htmlDecode(value) {
    return $('<div/>').html(value).text();
}

function getTextMessage(code) {
    var result;
    if (code === 947) {
        result = "File size is greater than 3 MB; we cannot accept files of over 3mb";
    }
    if (code === 995) {
        result = "Please select the file before uploading it.";
    }
    if (code === 941) {
        result = "Please select a file before removing it.";
    }
    return result;
}

function dateFormat(date, format) {
    // Calculate date parts and replace instances in format string accordingly
    format = format.replace("DD", (date.getDate() < 10 ? '0' : '') + date.getDate()); // Pad with '0' if needed
    format = format.replace("MM", (date.getMonth() < 9 ? '0' : '') + (date.getMonth() + 1)); // Months are zero-based
    format = format.replace("YYYY", date.getFullYear());
    return format;
}

function jsonToDate(date) {
    return new Date(parseInt(date.replace("/Date(", "").replace(")/", ""), 10));
}

/*Convert Date*/
function convertDateToMMYY(input) {
    var date = new Date(parseInt(input.substr(6))),
        month = ("0" + (date.getMonth() + 1)).slice(-2),
        year = date.getFullYear();
    return month + "/" + year;
}

function convertDateToDDMMYYYY(input) {

    var date = new Date(parseInt(input.substr(6))),
        day = ("0" + date.getDate()).slice(-2),
        month = ("0" + (date.getMonth() + 1)).slice(-2),
        year = date.getFullYear();
    return day + '/' + month + '/' + year;
}

function convertDateToDDMMYY(input) {

    var date = new Date(parseInt(input.substr(6))),
        day = ("0" + date.getDate()).slice(-2),
        month = ("0" + (date.getMonth() + 1)).slice(-2),
        year = date.getFullYear().toString().slice(-2);
    return day + '/' + month + '/' + year;
}
// Xuan custom for search/add data
function convertDateToMMDDYYYY(input) {
    if (input != "") {
        var parts = input.split('/');
        var dmyDate = parts[1] + '/' + parts[0] + '/' + parts[2];
        return dmyDate;
    }
    return "";
}

function daysBetween(startDate, endDate) {
    // The number of milliseconds in one day
    var oneDay = 1000 * 60 * 60 * 24;
    //var diffDays = Math.abs((firstDate.getTime() - secondDate.getTime()) / (oneDay));
    var diffDays = Math.round((endDate.getTime() - startDate.getTime()) / (oneDay));
    return diffDays;
}

function randomString(length) {

    var text = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz",
        result = "";
    for (var j = 0; j < length; j++) {
        var i = Math.floor(Math.random() * text.length);
        result += text.substring(i, i + 1);
    }
    return result;
};

function checkExistHtmlTag(value) {
    return (/<(?:.|\n)*?>/.test(value));
}

function closeDialog() {
    $('#dynamic-model-box').remove();
    $('div.modal-backdrop,fade, in').remove();
    // Xuan custom
    //$('body').removeClass('modal-open');
    $('body').removeAttr("style");
    $('body').removeAttr("class");
}

/*
    Currently incomplete, i will to complete late
    name: load dialog
    description: using for display data in the dialog
    author: Nam Hoang
*/

function openDialog(options) {
    var settings = $.extend({
        title: 'title',
        larger: false,
        url: null,
        data: null,
        showLoading: true,
        beforeSubmit: null,
        success: null,
        closeCallback: null,
        error: null
    }, options);

    var html = '<div class="modal fade" id="dynamic-model-box" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">';
    html = html + '<div class="modal-dialog modal-lg" ><div class="modal-content"><div class="modal-header">';
    html = html + '<button type="button" class="close enable-for-officer" aria-hidden="true">&times;</button>';
    html = html + '<h4 class="modal-title" id="myModalLabel">' + options.title + '</h4></div>';
    html = html + '<div class="modal-body">' + options.data + '</div> <div class="modal-footer">';
    html = html + '</div> </div></div>';
    $('body').append(html);
    var modelBox = $('#dynamic-model-box');
    modelBox.find('button.close').on('click', function () {
        if (typeof options.closeCallback != 'undefined' && typeof (options.closeCallback) === 'function') options.closeCallback();
        closeDialog();
    });
    $('#dynamic-model-box').modal({ show: true, backdrop: 'static' });
}


/*
    Xuan Tran Minh : Yes No confirm popup
*/
function openYesNoDialog(options) {
    var settings = $.extend({
        sectionTitle: 'Confirmation',
        title: 'title',
        larger: false,
        url: null,
        data: null,
        showLoading: true,
        beforeSubmit: null,
        success: null,
        closeCallback: null,
        yesCallback: null,
        noCallback: null,
        error: null
    }, options);

    var html = '<div class="modal fade" id="dynamic-model-box" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">';
    html = html + '<div class="modal-dialog modal-sm" ><div class="modal-content"><div class="modal-header"><h4 class="modal-title">' + settings.sectionTitle + '</h4></div>';
    html = html + '<div class="modal-body">' + settings.title + '</div><div class="modal-footer" style="text-align:center"><button type="button" id="btnYes" class="btn btn-primary enable-for-officer">Yes</button>';
    html = html + '<button type="button" id="btnNo" class="btn btn-warning enable-for-officer">No</button></div>';
    html = html + '</div> </div></div>';
    $('body').append(html);

    var modelBox = $('#dynamic-model-box');
    modelBox.find('#btnYes').on('click', function () {
        if (typeof options.yesCallback != 'undefined' && typeof (options.yesCallback) === 'function') options.yesCallback();
        closeDialog();
    });
    modelBox.find('#btnNo').on('click', function () {
        if (typeof options.noCallback != 'undefined' && typeof (options.noCallback) === 'function') options.noCallback();
        closeDialog();
    });

    $('#dynamic-model-box').modal({ show: true, backdrop: 'static' });
}


function openNoticeDialog(options) {
    var settings = $.extend({
        sectionTitle: 'Confirmation',
        title: 'title',
        larger: false,
        url: null,
        data: null,
        showLoading: true,
        beforeSubmit: null,
        success: null,
        closeCallback: null,
        yesCallback: null,
        noCallback: null,
        error: null
    }, options);

    var html = '<div class="modal fade" id="dynamic-model-box" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">';
    html = html + '<div class="modal-dialog modal-sm" ><div class="modal-content"><div class="modal-header">';
    html = html + '<button type="button" class="close enable-for-officer" aria-hidden="true">&times;</button>';
    html = html + '<h4 class="modal-title">' + settings.sectionTitle + '</h4>';
    html = html + '</div>';
    html = html + '<div class="modal-body">' + settings.title + '</div><div class="modal-footer" style="text-align:center">';
    html = html + '</div>';
    html = html + '</div> </div></div>';
    $('body').append(html);
    var modelBox = $('#dynamic-model-box');
    modelBox.find('button.close').on('click', function () {
        if (typeof options.closeCallback != 'undefined' && typeof (options.closeCallback) === 'function') options.closeCallback();
        closeDialog();
    });
    $('#dynamic-model-box').modal({ show: true, backdrop: 'static' });
}

/*
    Xuan Tran Minh : custom size popup
*/
function openSearchStockDialog(options) {
    var settings = $.extend({
        title: 'title',
        larger: false,
        url: null,
        data: null,
        showLoading: true,
        beforeSubmit: null,
        success: null,
        searchCallback: null,
        closeCallback: null,
        error: null
    }, options);

    var html = '<div class="modal fade" id="dynamic-model-box" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">';
    html = html + '<div class="modal-dialog modal-lg"><div class="modal-content"><div class="modal-header">';
    html = html + '<button type="button" class="close enable-for-officer" aria-hidden="true">&times;</button>';
    html = html + '<h4 class="modal-title" id="myModalLabel">' + options.title + '</h4></div>';
    html = html + '<div class="modal-body">' + options.data + '</div> <div class="modal-footer">';
    html = html + '</div> </div></div>';
    $('body').append(html);
    var modelBox = $('#dynamic-model-box');
    modelBox.find('button.close').on('click', function () {
        if (typeof options.closeCallback != 'undefined' && typeof (options.closeCallback) === 'function') options.closeCallback();
        closeDialog();
    });
    modelBox.find('#searchProductbtnSearch').on('click', function () {
        if (typeof options.searchCallback != 'undefined' && typeof (options.searchCallback) === 'function') options.searchCallback();
    });
    $('#dynamic-model-box').modal({ show: true, backdrop: 'static' });
}

function openErrorDialog(options) {
    var settings = $.extend({
        title: 'title',
        larger: false,
        url: null,
        data: null,
        showLoading: true,
        beforeSubmit: null,
        success: null,
        closeCallback: null,
        error: null
    }, options);

    var html = '<div class="modal fade" id="dynamic-model-box" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">';
    html = html + '<div class="modal-dialog modal-sm"><div class="modal-content"><div class="modal-header alert alert-danger">';
    html = html + '<button type="button" class="close enable-for-officer" aria-hidden="true">&times;</button>';
    html = html + '<h4 class="modal-title" id="myModalLabel"><span class="glyphicon glyphicon-warning-sign"></span> ' + options.title + '</h4></div>';
    html = html + '<div class="modal-body">' + options.data + '</div> <div class="modal-footer">';
    html = html + '</div> </div></div>';
    $('body').append(html);
    var modelBox = $('#dynamic-model-box');
    modelBox.find('button.close').on('click', function () {
        closeDialog();
    });
    $('#dynamic-model-box').modal({ show: true, backdrop: 'static' });
}

function errorSystem() {
    openErrorDialog({
        title: "Error",
        data: "Please contact Administrator support."
    });
};

// UPLOAD DOCUMENT ///////////////////////////////////
/*
name: upload file control
describe: use this script to upload file by ajax
*/
var uploadFileControl = function () {
    var init = function () {
        uploadFile();
        deleteFile();
        loadFilesTable();
        clearAllErrorMessage();
    };

    var uploadFile = function () {
        $(document).on('click', '#btnUploadDocument', function (event) {
            var sender = this;
            var dataString;
            var contentType;
            var processData;
            actingButton(sender);
            event.preventDefault();
            var form = $(this).closest("form");
            if (form.attr("enctype") == "multipart/form-data") {
                //this only works in some browsers.
                //purpose? to submit files over ajax. because screw iframes.
                //also, we need to call .get(0) on the jQuery element to turn it into a regular DOM element so that FormData can use it.
                dataString = new FormData(form.get(0));
                contentType = false;
                processData = false;
            }
            var isFileSelected = form.find('input[type="file"]').val();
            if (isFileSelected == '') {
                showErrorMessage(form, getTextMessage(995));
                reloadButton(sender);
                return;
            }
            // Check Exist
            if (isExist(isFileSelected, form)) {
                showErrorMessage(form, "File exist.");
                reloadButton(sender);
                return;
            }

            var id = form.find('#KeyId').val();
            var loginId = $('#iLogin').val();
            var type = form.find('#DocumentCategoryId').val();
            $.ajax({
                type: "POST",
                url: '/Ajax/UploadFile?id=' + id + '&type=' + type + '&loginId=' + loginId,
                data: dataString,
                dataType: "json", //change to your own, else read my note above on enabling the JsonValueProviderFactory in MVC
                contentType: contentType,
                processData: processData,
                success: function (data) {
                    reloadButton(sender);
                    if (data.result) {
                        //show data on gridview
                        //add row to table
                        var tr = document.createElement('tr');
                        //tr.className = "new-file";

                        var checkbox = document.createElement('input');
                        checkbox.type = "checkbox";
                        checkbox.name = "file-check";
                        checkbox.value = data.file.FileGuid;

                        var td0 = document.createElement('td');
                        td0.appendChild(checkbox);
                        tr.appendChild(td0);

                        var hiddenField = document.createElement('input');
                        hiddenField.setAttribute("type", "hidden");
                        hiddenField.value = data.file.FileId;
                        hiddenField.name = "file-id";

                        var href = document.createElement('a');
                        href.href = "/ajax/download/" + data.file.FileId;
                        href.title = data.file.FileName;
                        href.className = "fileNameUploaded";
                        href.appendChild(document.createTextNode(data.file.FileName));

                        var td1 = document.createElement('td');
                        td1.appendChild(hiddenField);
                        td1.appendChild(href);
                        tr.appendChild(td1);

                        var td2 = document.createElement('td');
                        td2.appendChild(document.createTextNode(data.file.ActionDate));
                        tr.appendChild(td2);

                        form.find('.upload-files-table tr:last').after(tr);
                        //load table, clear message if any
                        loadFilesTable();
                        clearErrorMessage(form);
                        //clear input file
                        var inputFile = form.find('input[type="file"]');
                        //inputFile.replaceWith(inputFile.clone());
                        inputFile.replaceWith(inputFile.val('').clone(true));
                    } else {
                        //showErrorMessage(form, data.message);
                        showErrorMessage(form, data.message);
                    }

                },
                error: function () {
                    //do your own thing
                    showErrorMessage(form, getTextMessage(947));
                    reloadButton(sender);
                    //showAlert("error");
                }
            });
        });

        $(document).on('click', '#btnUploadPicture', function (event) {
            var sender = this;
            var dataString;
            var contentType;
            var processData;
            actingButton(sender);
            event.preventDefault();
            var form = $(this).closest("form");
            if (form.attr("enctype") == "multipart/form-data") {
                //this only works in some browsers.
                //purpose? to submit files over ajax. because screw iframes.
                //also, we need to call .get(0) on the jQuery element to turn it into a regular DOM element so that FormData can use it.
                dataString = new FormData(form.get(0));
                contentType = false;
                processData = false;
            }
            var isFileSelected = form.find('input[type="file"]').val();
            if (isFileSelected == '') {
                showErrorMessage(form, getTextMessage(995));
                reloadButton(sender);
                return;
            }
            var id = form.find('#KeyId').val();
            var loginId = $('#iLogin').val();
            var type = form.find('#DocumentCategoryId').val();
            $.ajax({
                type: "POST",
                url: '/Ajax/UploadFile?id=' + id + '&type=' + type + '&loginId=' + loginId,
                data: dataString,
                dataType: "json", //change to your own, else read my note above on enabling the JsonValueProviderFactory in MVC
                contentType: contentType,
                processData: processData,
                success: function (data) {
                    reloadButton(sender);
                    if (data.result) {
                        //Remove No Image
                        $('#picturearea .NoImg').remove();
                        //show data on Picture List
                        //add row to List
                        //<li data-target="#carousel-example-generic" data-slide-to="@i"></li>
                        // Get lastest data-slide-to
                        var lastdatasildeto = form.find('.carousel-indicators li:last').attr('data-slide-to');
                        var increaVal = 1;
                        if (typeof lastdatasildeto !== "undefined") {
                            increaVal = (parseInt(lastdatasildeto) + 1);
                        }
                        var li = "<li data-target='#carousel-example-generic' data-slide-to='0' class='active'></li>";
                        var item = "<div class='item active'>";
                        item += "<img src='" + $('#hidPathImg').val() + data.file.FileGuid + "' alt='" + data.file.FileName + "' class='imgsidle'/>";
                        item += "<div class='carousel-caption'><button class='btn btn-danger btn-delete-picture' data-id='" + data.file.FileId + "' data-guid='" + data.file.FileGuid + "'>Delete</button><span class='marginleft10'>" + data.file.FileName + "</span></div>";
                        item += "</div>";
                        //load data, clear message if any
                        clearErrorMessage(form);
                        form.find('.carousel-inner .item').removeClass('active');
                        form.find('.carousel-indicators li').removeClass('active');
                        form.find('.carousel-inner').append(item);
                        form.find('.carousel-indicators').append(li);
                        if (form.find('.carousel-indicators li').length > 1) {
                            form.find('.carousel-indicators li:last').attr('data-slide-to', increaVal);
                        }
                        showNextBackPicture();
                        //clear input file
                        var inputFile = form.find('input[type="file"]');
                        inputFile.replaceWith(inputFile.val('').clone(true));
                    } else {
                        showErrorMessage(form, data.message);
                    }

                },
                error: function () {
                    showErrorMessage(form, getTextMessage(947));
                    reloadButton(sender);
                }
            });
        });
    };

    function isExist(fileUpload, form) {
        // Fix chrome auto generate C:\fakepath\
        var arr = fileUpload.split('\\');
        var result = arr[arr.length - 1];
        var checkExist = false;
        $(".fileNameUploaded", form).each(function () {
            if (result == $(this).html()) {
                checkExist = true;
                return checkExist;
            }
        });
        return checkExist;
    }

    var deleteFile = function () {
        $(document).on('click', 'a.btn-delete-file', function (event) {
            event.preventDefault();
            var form = $(this).closest("form");
            if (form.find('input[name="file-check"]:checked').length > 0) {
                deleteFilesByIds(form);
                loadFilesTable();
            }
            else {
                showErrorMessage(form, getTextMessage(941));
            }
        });
        // Picture
        $(document).on('click', 'button.btn-delete-picture', function (event) {
            event.preventDefault();
            var form = $(this).closest("form");
            var divCurrent = $(this).closest("div .item");

            var fileId = $(this).attr('data-id');
            var guid = $(this).attr('data-guid');
            var type = $('#DocumentCategoryId', form).val();
            var files = [];
            files.push(fileId + ";" + guid + ";" + type);

            $.post('/ajax/deleteFiles', {
                data: JSON.stringify(files),
            }, function (response) {
                if (response.result) {
                    divCurrent.remove();
                    form.find('.carousel-indicators li:last').remove();
                    if (form.find('.carousel-inner .item').length === 0) {
                        // Add no img
                        var li = "<li data-target='#carousel-example-generic' data-slide-to='0' class='NoImg'></li>";
                        var item = "<div class='item NoImg'>";
                        item += "<img src='" + $('#hidPathImages').val() + "No-Image-Available.gif' alt='No image'/>";
                        item += "</div>";
                        form.find('.carousel-inner').append(item);
                        form.find('.carousel-indicators').append(li);
                    }
                    form.find('.carousel-indicators li').removeClass('active');
                    form.find('.carousel-indicators li:first').addClass('active');
                    form.find('.carousel-inner .item').removeClass('active');
                    form.find('.carousel-inner .item:first').addClass('active');
                    hideNextBackPicture();
                } else {
                    showErrorMessage(form, response.message);
                }
            });
        });
    };

    var loadFilesTable = function () {
        var tables = $('table.upload-files-table');
        if (tables != "undefined") {
            tables.each(function () {
                if ($(this).find('tr').length > 1) {
                    $(this).show();
                    $(this).closest('form').find('a.btn-delete-file').show();
                } else {
                    $(this).hide();
                    $(this).closest('form').find('a.btn-delete-file').hide();
                }
            });
        }
    };

    var hideNextBackPicture = function () {
        if ($('#picturearea .item').length === 1) {
            $('#picturearea .left').addClass('hide');
            $('#picturearea .right').addClass('hide');
        }
    };

    var showNextBackPicture = function () {
        if ($('#picturearea .item').length > 1) {
            $('#picturearea .left').removeClass('hide');
            $('#picturearea .right').removeClass('hide');
        }
    };

    var deleteFilesByIds = function (form) {
        var listFiles = getDeleteFilesIds(form);
        $.post('/ajax/deleteFiles', {
            data: JSON.stringify(listFiles),
        }, function (response) {
            if (response.result) {
                $('input[name="file-check"]:checked').parents('tr').remove();
                loadFilesTable();
                clearErrorMessage(form);
            } else {
                showErrorMessage(form, response.message);
            }
        });
    };

    var getDeleteFilesIds = function (form) {
        var type = $('#DocumentCategoryId', form).val();
        var fileLists = $('.upload-files-table tr input[name="file-check"]:checked', form);
        var files = [];
        fileLists.each(function () {
            var guid = $(this).val();
            var fileId = $(this).parent().next().find('input[name="file-id"]').val();
            files.push(fileId + ";" + guid + ";" + type);

        });
        //var beforFiles = $('#RemoveFiles', form).val();
        //var removeFiles = beforFiles + JSON.stringify(files);
        //$('#RemoveFiles', form).val(removeFiles);
        return files;
    };

    var showErrorMessage = function (form, message) {
        //var errorMessage = form.find('.upload-file-error-message');
        //errorMessage.html(message);
        toastr.error(message, 'Error');
    };

    var clearErrorMessage = function (form) {
        form.find('.upload-file-error-message').html('');
    };

    var clearAllErrorMessage = function () {
        $('.upload-file-error-message').html('');
    };

    return {
        init: init
    };
}(jQuery);
//////////////////

var successNotice = function (id) {
    if (id > 0) {
        openYesNoDialog({
            sectionTitle: "Save Successful!",
            title: "Yes: go to list page.<br>No: stay this page.",
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
        openYesNoDialog({
            sectionTitle: "Save Successful!",
            title: "Yes: go to list page.<br>No: stay this page.",
            data: '',
            yesCallback: function () {
                var controller = $('#controller').val().toLowerCase();
                window.location.href = 'http://' + window.location.host + '/' + controller;
            },
            noCallback: function () {
                $('#btnSearchStock').attr("disabled", "true");
                $('#StockCode').attr("disabled", "true");
                $('.btnAddItem').attr("disabled", "true");
                $('.btnEdit').attr("disabled", "true");
                $('.btnDelete').attr("disabled", "true");
                $('#btnSave').attr("disabled", "true");
                $('.btnAdd').show();
            }
        });
    }
};

var responseHelper = function (response, id) {
    if (response.result === $('#hidSuccess').val()) {
        successNotice(id);
    } else if (response.result == $('#hidDuplicateCode').val()) {
        clearVal();
        openYesNoDialog({
            sectionTitle: "Error: Code is used",
            title: "Yes: go to list page.<br>No: stay this page.",
            data: '',
            yesCallback: function () {
                var controller = $('#controller').val().toLowerCase();
                window.location.href = 'http://' + window.location.host + '/' + controller;
                //window.location = '/login/signout';
                //window.history.back();
            },
            noCallback: function () {
            }
        });
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
};

var SaveEntity = function (data, id) {
    $.ajax({
        url: $('#hidSaveUrl').val(),
        dataType: 'json',
        contentType: 'application/json',
        type: 'POST',
        data: ko.toJSON(data),
        success: function (response) {
            responseHelper(response, id);
        }
    });
};

// STOCK SEARCH ///////////////////////////////////
var searchStockFunction = function () {
    var init = function () {
        searchStock();
    };

    var searchStock = function () {
        $(document).on('click', '#btnSearchStock', function (event) {
            event.preventDefault();
            $.ajax({
                url: '/Ajax/SearchStock',
                type: 'GET',
                datatype: 'json',
                async: false,
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    if (data.length != 0) {
                        openSearchStockDialog({
                            title: "Search Stock",
                            data: data,
                            searchCallback: function () {
                                loadStock();
                            },
                        });
                    }
                }
            });
            loadStock();
            eventSearchStock();
        });
    };

    var loadStock = function () {
        var modelBox = $('#dynamic-model-box');
        var page = $("a.current", modelBox).html();
        var size = $('#searchProductPageSize', modelBox).val();
        var store = 0;
        var type = 0;
        var category = 0;
        var stockCode = $('#searchProductSearchStockCode', modelBox).val();
        var stockName = $('#searchProductSearchStockName', modelBox).val();
        if ($('#searchProductSearchStore', modelBox).val() != "") {
            store = $('#searchProductSearchStore', modelBox).val();
        }
        if ($('#searchProductSearchType', modelBox).val() != 0) {
            type = $('#searchProductSearchType', modelBox).val();
        }
        if ($('#searchProductSearchCategory', modelBox).val() != "") {
            category = $('#searchProductSearchCategory', modelBox).val();
        }

        if (typeof page === 'undefined') {
            page = 1;
        }

        // MODE : PE, RETURN , STOCK IN, STOCK OUT,...
        if ($('#Mode').val() == "PE" && typeof $('#bSupplierID').val() !== 'undefined') {
            if ($('#bSupplierID').val() == "") {
                $('#searchProductDiv', modelBox).empty().append("<div>No data. Close and select <b>Supplier</b> again.</div>");
                eventSearchStockListStock();
            } else {
                var supplier = $('#bSupplierID').val();
                loadStockPe(modelBox, page, size, store, type, category, stockCode, stockName, supplier);
            }
        }
        else if ($('#Mode').val() == "StockIn" && typeof $('#vPOID').val() !== 'undefined') {
            if ($('#vPOID').val() == "") {
                $('#searchProductDiv', modelBox).empty().append("<div>No data. Close and select <b>PO Id</b> again.</div>");
                eventSearchStockListStock();
            } else {
                var pe = $('#vPOID').val();
                loadStockStockIn(modelBox, page, size, store, type, category, stockCode, stockName, pe);
            }
        } else if ($('#Mode').val() == "StockOut" && typeof $('#FromStore').val() !== 'undefined') {
            if ($('#FromStore').val() == "") {
                $('#searchProductDiv', modelBox).empty().append("<div>No data. Close and select <b>Store</b> again.</div>");
                eventSearchStockListStock();
            } else {
                store = $('#FromStore').val();
                loadStockStockOut(modelBox, page, size, store, type, category, stockCode, stockName);
            }
        } else if ($('#Mode').val() == "StockReturn" && typeof $('#vProjectID').val() !== 'undefined') {
            if ($('#vProjectID').val() == "") {
                $('#searchProductDiv', modelBox).empty().append("<div>No data. Close and select <b>Project</b> again.</div>");
                eventSearchStockListStock();
            } else {
                var project = $('#vProjectID').val();
                loadStockStockReturn(modelBox, page, size, project, type, category, stockCode, stockName);
            }
        } else {
            loadStockRequisition(modelBox, page, size, store, type, category, stockCode, stockName);
        }
    };

    var loadStockRequisition = function (modelBox, page, size, store, type, category, stockCode, stockName) {
        $.ajax({
            url: '/Ajax/SearchStockRequisitionFilter',
            type: 'GET',
            async: false,
            data: {
                page: page,
                size: size,
                stockCode: stockCode,
                stockName: stockName,
                store: store,
                type: type,
                category: category,
                enable: '1'
            },
            datatype: 'json',
            contentType: 'application/json; charset=utf-8',
            success: function (data) {
                if (data.length != 0) {
                    $('#searchProductDiv', modelBox).empty().append(data);
                    eventSearchStockListStock();
                }
            }
        });
    }

    var loadStockPe = function (modelBox, page, size, store, type, category, stockCode, stockName, supplier) {
        $.ajax({
            url: '/Ajax/SearchStockPeFilter',
            type: 'GET',
            async: false,
            data: {
                page: page,
                size: size,
                stockCode: stockCode,
                stockName: stockName,
                store: store,
                type: type,
                category: category,
                enable: '1',
                supplier: supplier
            },
            datatype: 'json',
            contentType: 'application/json; charset=utf-8',
            success: function (data) {
                if (data.length != 0) {
                    $('#searchProductDiv', modelBox).empty().append(data);
                    eventSearchStockListStock();
                }
            }
        });
    }

    var loadStockStockIn = function (modelBox, page, size, store, type, category, stockCode, stockName, pe) {
        $.ajax({
            url: '/Ajax/SearchStockStockInFilter',
            type: 'GET',
            async: false,
            data: {
                page: page,
                size: size,
                stockCode: stockCode,
                stockName: stockName,
                store: store,
                type: type,
                category: category,
                enable: '1',
                pe: pe
            },
            datatype: 'json',
            contentType: 'application/json; charset=utf-8',
            success: function (data) {
                if (data.length != 0) {
                    $('#searchProductDiv', modelBox).empty().append(data);
                    eventSearchStockListStock();
                }
            }
        });
    }

    var loadStockStockOut = function (modelBox, page, size, store, type, category, stockCode, stockName) {
        $.ajax({
            url: '/Ajax/SearchStockStockOutFilter',
            type: 'GET',
            async: false,
            data: {
                page: page,
                size: size,
                stockCode: stockCode,
                stockName: stockName,
                store: store,
                type: type,
                category: category
            },
            datatype: 'json',
            contentType: 'application/json; charset=utf-8',
            success: function (data) {
                if (data.length != 0) {
                    $('#searchProductDiv', modelBox).empty().append(data);
                    eventSearchStockListStock();
                }
            }
        });
    }

    var loadStockStockReturn = function (modelBox, page, size, project, type, category, stockCode, stockName) {
        $.ajax({
            url: '/Ajax/SearchStockStockReturnFilter',
            type: 'GET',
            async: false,
            data: {
                page: page,
                size: size,
                stockCode: stockCode,
                stockName: stockName,
                project: project,
                type: type,
                category: category
            },
            datatype: 'json',
            contentType: 'application/json; charset=utf-8',
            success: function (data) {
                if (data.length != 0) {
                    $('#searchProductDiv', modelBox).empty().append(data);
                    eventSearchStockListStock();
                }
            }
        });
    }

    var eventSearchStock = function () {
        var modelBox = $('#dynamic-model-box');
        $('#searchProductPageSize', modelBox).on('change', function (e) {
            $("a.current", modelBox).removeClass("current");
            $(".pagination a:first", modelBox).addClass("current");
            loadStock();
        });

        $("#searchProductSearchStockCode", modelBox).autocomplete({
            source: "/Stock/ListCode?term" + $("#searchProductSearchStockCode", modelBox).val()
        });

        $("#searchProductSearchStockName", modelBox).autocomplete({
            source: "/Stock/ListName?term" + $("#searchProductSearchStockName", modelBox).val()
        });
    };

    var eventSearchStockListStock = function () {
        var modelBox = $('#dynamic-model-box');

        $(document).on('click', '.btnSearchProductSelectProduct', function () {
            var id = $(this).closest('tr').find('.StockIdSearchForm').val();
            $('#StockId').val($(this).closest('tr').find('.StockIdSearchForm').val());
            $('#StockCode').val($(this).closest('tr').find('.ProductCodeSearchForm').text());
            $('#lblStockName').text($(this).closest('tr').find('.ProductNameSearchForm').text());
            $('#lblStockType').text($(this).closest('tr').find('.ProductTypeSearchForm').text());
            $('#lblStockUnit').text($(this).closest('tr').find('.ProductUnitSearchForm').text());
            $('#lblPartNo').text($(this).closest('tr').find('.ProductPartNoSearchForm').text());
            $('#lblRalNo').text($(this).closest('tr').find('.ProductRalNoSearchForm').text());
            $('#lblColor').text($(this).closest('tr').find('.ProductColorSearchForm').text());
            $('#lblStockQty').text($(this).closest('tr').find('.' + $('#StoreId').val() + '').text());
            // Requisition
            $('#fQuantity').removeAttr('disabled');
            $('#fTobePurchased').removeAttr('disabled');
            // PE
            if ($('#Mode').val() == "PE" && typeof $('#bSupplierID').val() !== 'undefined') {
                $('#lblStockCategory').text($(this).closest('tr').find('.ProductCategorySearchForm').text());
                //tmx.vivablast.peact.loadPrice($('#pe-create-form'));
                tmx.vivablast.peact.loadMrf($('#pe-create-form'));
            }
            // StockIn
            else if ($('#Mode').val() == "StockIn" && typeof $('#vPOID').val() !== 'undefined') {
                var form = $('#stock-in-create-form');
                tmx.vivablast.stockinact.loadStockInQuantity(form);
            }

            // Stock Out
            if ($('#Mode').val() == "StockOut") {
                $('#lblStockQty').text($(this).closest('tr').find('.Quantity').text());
            }
            
            // Stock Return
            if ($('#Mode').val() == "StockReturn") {
                $('#lblStockQty').text($(this).closest('tr').find('.Quantity').text());
            }

            loadPictureStock(id);

            closeDialog();
        });

        $('.pagination a', modelBox).off("click").on("click", function () {
            $("a.current", modelBox).removeClass("current");
            $(this).addClass("current");
            loadStock();
        });

        if ($('#Mode').val() == "StockOut") {
            $('#searchProductSearchStore').val($('#FromStore').val());
            $('#searchProductSearchStore').attr("disabled","disable");
        }

        if ($('#Mode').val() == "StockReturn") {
            $('#searchProductSearchStore').addClass("hidden");
        }
    };

    return {
        init: init
    };
}(jQuery);
//////////////////

(function ($) {
    $.fn.currencyFormat = function () {
        this.each(function (i) {
            $(this).change(function (e) {
                if (isNaN(parseFloat(this.value))) return;
                this.value = parseFloat(this.value).toFixed(2);
            });
        });
        return this; //for chaining
    }
})(jQuery);

//format money
Number.prototype.formatMoney = function (places, symbol, thousand, decimal) {
    places = !isNaN(places = Math.abs(places)) ? places : 2;
    symbol = symbol !== undefined ? symbol : "";
    thousand = thousand || ".";
    decimal = decimal || ",";
    var number = this,
	    negative = number < 0 ? "-" : "",
	    i = parseInt(number = Math.abs(+number || 0).toFixed(places), 10) + "",
	    j = (j = i.length) > 3 ? j % 3 : 0;
    return symbol + negative + (j ? i.substr(0, j) + thousand : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thousand) + (places ? decimal + Math.abs(number - i).toFixed(places).slice(2) : "");
};

function loadStockName(form, value, to) {
    if ($(value, form).val() != "" && $(value, form).val().length > 5) {
        $.ajax({
            url: "/Ajax/GetStockCodeName",
            type: "POST",
            asysn: false,
            data: {
                code: $(value, form).val(),
                name: ''
            },
            success: function (stock) {
                $(to, form).val(stock.Stock_Name);
            }
        });
    } else {
        $(to, form).val('');
    }
}

function loadStockCode(form, value, to) {
    if ($(value, form).val() != "" && $(value, form).val().length > 5) {
        $.ajax({
            url: "/Ajax/GetStockCodeName",
            type: "POST",
            asysn: false,
            data: {
                code: '',
                name: $(value, form).val(),
            },
            success: function (stock) {
                $(to, form).val(stock.Stock_Code);
            }
        });
    } else {
        $(to, form).val('');
    }
}

function loadPictureStock(id) {
    $.ajax({
        url: "/Ajax/LoadPictureStock",
        type: "POST",
        data: {
            id: id,
            type: 1
        },
        success: function (data) {
            $('.gallery-stock').html(data);
        },
        error: function () {
            console.log("Error load picture");
        }
    });
}
function page() {
    var id = $(".pagination a.current").html();
    if (typeof id === 'undefined') {
        id = 1;
    }
    return id;
}

function size() {
    var id = $("#pageSize").val();
    id = id === "" ? 10 : id;
    return id;
}