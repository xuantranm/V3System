(function ($) {
    UtilityClass = function () { };

    UtilityClass.prototype = {
        init: UtilityClass,

        isMobile: {
            Android: function () {
                return navigator.userAgent.match(/Android/i);
            },
            BlackBerry: function () {
                return navigator.userAgent.match(/BlackBerry/i);
            },
            iOS: function () {
                return navigator.userAgent.match(/iPhone|iPad|iPod/i);
            },
            iPhone: function () {
                return navigator.userAgent.match(/iPhone/i);
            },
            Opera: function () {
                return navigator.userAgent.match(/Opera Mini/i);
            },
            Windows: function () {
                return navigator.userAgent.match(/IEMobile/i);
            },
            anyPhone: function () {
                return navigator.userAgent.match(/BlackBerry|iPhone|iPod|Opera Mini|IEMobile/i);
            },
            any: function () {
                //return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
                return navigator.userAgent.match(/Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile/i);
            }
        },


        htmlEncode: function (value) {
            //create a in-memory div, set it's inner text(which jQuery automatically encodes)
            //then grab the encoded contents back out.  The div never exists on the page.
            return $('<div/>').text(value).html();
        },

        htmlDecode: function (value) {
            return $('<div/>').html(value).text();
        },

        formToObject: function ($form, prefix) {
            var form = {};
            $form.find(':input[name]:enabled').each(function () {
                var self = $(this);
                var name = self.attr('name');

                if (typeof prefix !== 'undefined') {
                    name = name.replace(prefix + '.', '');
                }
                if (!form[name]) {
                    var role = self.data('role');
                    if (typeof role !== 'undefined' && role === 'dropdownlist' && $.trim(self.val()) === '') {
                        self.val('0');
                    }

                    if (self.is('input:checkbox')) {
                        form[name] = self.filter(':checked').length > 0 ? true : false;
                    } else {
                        form[name] = self.val();
                    }
                }
            });

            //find kendoUI
            $form.find('*').each(function () {
                var $this = $(this),
                    data = $this.data();

                if (typeof data !== 'undefined' && typeof data.handler !== 'undefined' && typeof data.handler.text === 'function' && typeof data.text !== 'undefined') {
                    form[data.text] = data.handler.text();
                }

            });


            return form;
        },

        closePopup: function (popupClass) {
            if (typeof popupClass === 'undefined') {
                popupClass = 'popup-box';
            }
            Helpers.clearAllKendoUIControl($('.' + popupClass));
            $('.' + popupClass).remove();
            while ($('#overlay').length > 0) {
                $('#overlay').remove();
            }
        },

        clearAllKendoUIControl: function ($context) {
            if (typeof $context === 'undefined') {
                $context = $(body);
            }
            // clean kendoUI controls
            $context.find('*').each(function () {
                var $this = $(this),
                    data = $this.data();
                if (typeof data.handler !== 'undefined' && typeof data.handler !== 'undefined') {
                    data.handler.destroy();
                }
            });
            $("input[type='checkbox']", $context).removeAttr("readonly");
            $("input[type='text']", $context).removeAttr("readonly");
            $("textarea", $context).removeAttr("readonly");
        },
        readOnlyAllKendoUIControl: function ($context) {
            if (typeof $context === 'undefined') {
                $context = $(body);
            }
            // clean kendoUI controls
            $context.find('*').each(function () {
                var $this = $(this),
                    data = $this.data();
                if (typeof data.handler !== 'undefined' && typeof data.handler !== 'undefined' && typeof data.handler.readonly === 'function') {
                    data.handler.readonly();
                }
            });

            $("input[type='checkbox']", $context).attr("readonly", true);
            console.log($("input[type='checkbox']", $context));
            $("input[type='text']", $context).attr("readonly", "true");
            $("textarea", $context).attr("readonly", "true");
            $(".search-button", $context).attr("disabled", "disabled");
        },
        getPropertyNames: function (object) {
            var propertyNames = [];
            for (var name in object) {
                if (object.hasOwnProperty(name)) {
                    propertyNames.push(name);
                }
            }
            return propertyNames;
        },

        randomString: function (length) {

            var text = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz",
                result = "";
            for (var j = 0; j < length; j++) {
                var i = Math.floor(Math.random() * text.length);
                result += text.substring(i, i + 1);
            }
            return result;
        },

        randomNumber: function (length) {
            var text = "123456789",
                result = "";
            for (var j = 0; j < length; j++) {
                var i = Math.floor(Math.random() * text.length);
                result += text.substring(i, i + 1);
            }
            return result;
        },

        isNull: function (element) {
            return (typeof element === "undefined" || element === null);
        },

        isNullOrEmpty: function (element) {
            return (Helpers.isNull(element) || element === '');
        },

        isIphone: function () {
            return Modernizr.mq('only screen and (max-width: 480px)'); // true
        },

        isIpadPortrait: function () {
            return Modernizr.mq('only screen and (max-width: 768px) and (min-width: 480px)'); // true
        },

        isWindowsTouchable: function () {
            return (kendo.support.browser.msie && Modernizr.touch);
        },

        isKendoUIDefaultObjectValue: function (element) {
            return element === '[object Object]';
        },

        scaleKendoGrid: function ($grids) {
            if (Helpers.isNull($grids) === false && $grids.length > 0) {
                $grids.each(function () {
                    var $this = $(this),
                        $kGrid = $('.k-grid-content', this),
                        tableHeight = $('table', $kGrid).outerHeight(true),
                        contentHeight = $kGrid.outerHeight(true);

                    if (tableHeight < contentHeight) {
                        if (tableHeight < 20) {
                            tableHeight = 20;
                            $kGrid.removeAttr("style").css("max-height", "200px").css('height', tableHeight + "px");
                        }
                        $kGrid.removeAttr("style").css("height", "auto").css("max-height", "auto");
                    }
                });

                Helpers.customizeScrollbars($grids);
            }
        },

        selectorWithUID: function (selector, uid) {
            var uidCssClass = 'body';
            if (Helpers.isNullOrEmpty(selector)) {
                return [];
            }

            if (!Helpers.isNullOrEmpty(uid)) {
                uidCssClass = '.' + uid;
            }

            return $(selector, uidCssClass);
        },

        ///TODO: will refactor this function
        resolveUrl: function (url) {
            return $('#resolve-url').val() + url;
        },


        //get url from controller, action
        urlBuilder: function (module, controller, action, params) {
            var SLASH = '/';
            var QUESTION_MASK = '?';
            var rootUrl = Helpers.rootUrl;
            var url;
            if (rootUrl === '/') {
                url = 'm' + SLASH + module + SLASH + controller + SLASH + action + QUESTION_MASK + params;
            } else {
                url = rootUrl + SLASH + 'm' + SLASH + module + SLASH + controller + SLASH + action + QUESTION_MASK + params;
            }

            return url;
        },


        clear_form_elements: function ($ele) {
            $ele.find(':input').each(function () {
                switch (this.type) {
                    case 'password':
                    case 'select-multiple':
                    case 'select-one':
                    case 'text':
                    case 'textarea':
                    case 'hidden':
                        $(this).val('');
                        break;
                    case 'checkbox':
                    case 'radio':
                        this.checked = false;
                        break;
                }
            });
        },

        executeFunctionByName: function (functionName, context, argsForIE8) {

            if (typeof functionName == 'undefined' || functionName == null || functionName.length < 1)
                return true;

            var args = Array.prototype.slice.call(arguments).splice(2);
            var namespaces = functionName.split(".");
            if (args.length === 0) {
                if (Helpers.isNullOrEmpty(argsForIE8) === false) {
                    args.push(argsForIE8);
                }
            }
            var func = namespaces.pop();
            if (typeof context === 'undefined') {
                context = window;
            }
            console.log(functionName);
            for (var i = 0; i < namespaces.length; i++) {
                context = context[namespaces[i]];
            }
            if (typeof context !== 'undefined') {

                return context[func].apply(this, args);
            }
        },

        isValidDate: function (dateValue) {
            var fromFormat = 'dd/MM/yyyy';
            return (kendo.parseDate(dateValue, fromFormat) != null);
        },

        convertDate: function (dateValue) {
            var fromFormat = 'dd/MM/yyyy',
                toFormat = 'ddd, MMM dd yyyy';

            if (Helpers.isValidDate(dateValue)) {
                return kendo.toString(kendo.parseDate(dateValue, fromFormat), toFormat);
            }
            return dateValue;
        },

        convertDateFormats: function (dateValue, fromFormat, toFormat) {
            if (Helpers.isValidDate(dateValue)) {
                return kendo.toString(kendo.parseDate(dateValue, fromFormat), toFormat);
            }
            return dateValue;
        },

        convertToISODate: function (dateValue) {
            var fromFormat = 'dd/MM/yyyy';
            return kendo.parseDate(dateValue, fromFormat);
        },

        //use this function for set the focus on the first input element (textbox, dropdownlist, ...) on loading the page without having to know the id of the element
        firstFocus: function ($target, forPopup) {
            if (Helpers.isIphone()) {
                return;
            }
            if (typeof $target === 'undefined') {
                $target = $(document);
            }

            var $input = $("input:visible:enabled:not([readonly]),textarea:visible:enabled:not([readonly]),select:visible:enabled:not([readonly])", $target).first();

            if (forPopup === true) {
                $input = $("input:visible:enabled:not([readonly]),textarea:visible:enabled:not([readonly]),select:visible:enabled:not([readonly],button:visible:enabled:not([readonly])", $target).first();
            }
            if ($input.length > 0) {
                $input.focus(); //.select().click();
            } else {
                var $button = $('button', $target),
                 $close = $(".close", $target);
                if ($(":focus", $target).length === 0) { //only focus if no controls are focused
                    if ($button.length > 0) $button.focus();
                    else $close.focus();
                }
            }
        },

        hp_height: function (obj) {
            var hp_inner = obj.height();
            obj.height(hp_inner);
        },

        DatePicker: {
            startDateChange: function (e) {
                var endDatePickerIdSelector = '#' + $(e.sender.element).attr('endDatePicker');
                var endPicker = $(endDatePickerIdSelector).data("kendoDatePicker"),
                    startPicker = e.sender,
                    startDate = startPicker.value();
                if (!startDate) {
                    var number = Date.parse($(startPicker.element).val());
                    if (!isNaN(number)) {
                        startDate = new Date(number);
                        startPicker._old = startPicker._value = startDate;
                    }
                }
                if (startDate) {
                    //startDate = new Date(startDate);
                    //startDate.setDate(startDate.getDate() + 1);
                    if (endPicker.value() && endPicker.value() < startDate) {
                        endPicker.value(kendo.toString(startDate, "ddd, MMM dd yyyy"));
                        if (!endPicker._value) {
                            endPicker._value = startDate;
                        }
                    }
                    endPicker.min(startDate);
                    if (startDate > startPicker.max()) {
                        startPicker.max(startDate);
                    }
                }
                //startPicker.value($(e.sender.element).val());
                //endPicker.value($(endDatePickerIdSelector).val());
            },
            endDateChange: function (e) {
                var startDatePickerIdSelector = '#' + $(e.sender.element).attr('startDatePicker');
                var startPicker = $(startDatePickerIdSelector).data("kendoDatePicker"),
                    endPicker = e.sender,
                    endDate = endPicker.value();
                if (!endDate) {
                    var number = Date.parse($(endPicker.element).val());
                    if (!isNaN(number)) {
                        endDate = new Date(number);
                        endPicker._old = endPicker._value = endDate;
                    }
                }
                if (endDate) {
                    //endDate = new Date(endDate);
                    //endDate.setDate(endDate.getDate() - 1);
                    if (Helpers.isNull(startPicker) !== true) {
                        if (startPicker.value() && startPicker.value() > endDate) {
                            startPicker.value(kendo.toString(endDate, "ddd, MMM dd yyyy"));
                            if (!startPicker._value) {
                                startPicker._value = endDate;
                            }
                        }
                        startPicker.max(endDate);
                    }
                }
            },
            calendarOpen: function (e) {
                if (Helpers.isNull(e.sender.value()) === true) {
                    e.sender.value(new Date());
                    e.sender.value(null);
                }

                if (kendo.support.browser.msie && kendo.support.browser.version == 9) {
                    var oft = this.element.offset().top,
                        ofl = this.element.offset().left;
                    setTimeout(function () {
                        $('.k-animation-container').css({
                            'top': oft + 'px',
                            'left': ofl + 'px'
                        });
                    }, 100);
                }
            }
        },
        Tooltip: {
            alertCounter: function (args, count) {
                var alertContact = 0,
                alertAsset = 0,
                alertGroup = 0;
                var $alertTable = $('#' + args.sender.content.context.id),
                    count = args.sender.dataSource._data.length,
              $alertNumberWrapper = $alertTable.parents('.alert-table').siblings('.alert-numbers'),
              span = $('span.number', $alertNumberWrapper),
              divangel = $('div.alert-numbers-angle', $alertNumberWrapper);
                var idx = '';
                $alertTable.find('.k-grid-header table thead th').each(function () {
                    var headCol = $(this).text();
                    if (headCol === 'FormattedName') {
                        idx = $(this).index();
                    }
                });

                $alertTable.find('.k-grid-content table tr').each(function () {
                    var tooltip = $(this).find('td:eq(' + idx + ')').text();
                    $(this).attr('title', tooltip);
                });
                span.html(count);
                for (var i = 0; i < count; i++) {

                    switch (args.sender.dataSource._data[i].ContactAlertType) {
                        case 0:
                            alertContact++;
                            break;
                        case 1:
                            alertAsset++;
                            break;
                        case 2:
                            alertGroup++;
                            break;
                        default:
                    }
                }
                var str = 'There are ' + alertContact + ' alerts for the contact, ' + alertAsset + ' alerts for the asset and ' + alertGroup + ' alerts for the contact group';
                span.attr('title', str);
                divangel.attr('title', str);
            }
        },
      UserDefined: {
            UpdateUserDefineField: function (uid, module, formId, mvcController, action, message, id) {

                var validatable = formId.kendoValidator().kendoValidator(Helpers.validateOptions).data("kendoValidator");
                var isValid = validatable.validate();
                var dataSerialize = formId.serialize();
                if (isValid) {
                    Helpers.ajaxHelper.postJson({
                        url: Helpers.resolveUrl('m/' + module + '/' + mvcController + '/' + action + '/' + id),
                        data: dataSerialize,
                        success: function (data) {
                            if (typeof data == "string") {
                                $('.k-invalid-msg', uid).text('');
                                Civica.RegionManager.reloadCurrentWnd();
                                message.html(data);

                            } else {
                                if (data.length > 0) {
                                    $('.k-invalid-msg', uid).text('');
                                    for (var i = 0; i < data.length; i++) {
                                        var array = data[i]["ErrorMessage"].split("|");
                                        $("[id ^=" + array[0] + "]", uid).removeAttr('style').text(array[1]);

                                    }
                                }
                            }

                        },
                        showMask: true,
                        pressOkFunction: function () {
                            message.html('');
                            Civica.RegionManager.reloadCurrentWnd();
                        }
                    });
                }
                return isValid;
            },
            isEnableUserDefined: function (mvcController, action) {
                var enable = false;
                Helpers.ajaxHelper.postJson({
                    controller: mvcController,
                    action: action,
                    async: false,
                    success: function (result) {
                        enable = result;
                    }
                });
                return enable;
            },

        },
        compareTwoDate: function (date1, date2) {
            if (Helpers.isNull(date1) || Helpers.isNull(date2)) {
                return true;
            }
            if (date1 > date2) {

                return true;
            }

            return false;
        },
        //getCurrentUid: function (childUID) {
        //    var result;
        //    if (Helpers.isNullOrEmpty(childUID)) {
        //        result = tmx.RegionManager.CurrentRegionView.uid;
        //    } else {
        //        var wnd = tmx.RegionManager.get(childUID);
        //        if (Helpers.isNull(wnd) === false && Helpers.isNull(wnd.parent) === false) {
        //            result = wnd.parent.uid;
        //        } else {
        //            result = tmx.RegionManager.CurrentRegionView.uid;
        //        }
        //    }
        //    return "." + result;
        //},

        createMessagePopup: function (message, title) {
            return '<div class="popup-box-head accent-colour-background clearfix">' +
                      '<div class="box-title normal-text left">' + title + '</div>' +
                      '</div>' +
                      '<div class="content-message" style = "text-align: center;padding: 25px 0">' + message + '</div>' +
                      '<div class="YNButton clearfix" id="buttons-message">' +
                          '<button id="btnOk" type="button" title="OK" class="active-background active-text">OK</button>' +
                      '</div>';
        },

        validationImage: {
            createMessageUploadPopupContent: function (message, title) {
                if (title === undefined) {
                    title = 'Upload image';
                }
                return '<div class="popup-box-head accent-colour-background clearfix">' +
                        '<div class="box-title normal-text left">' + title + '</div>' +
                        '</div>' +
                        '<div class="content-message" style = "text-align: center;padding: 25px 0">' + message + '</div>' +
                        '<div class="YNButton clearfix" id="buttons-message">' +
                            '<button id="btnOk" type="button" title="OK" class="active-background active-text">OK</button>' +
                        '</div>';
            },
            triggerErrorPopup: function () {
                $("#buttons-message #btnOk").click(function () {
                    $('.popup-box-task').remove();
                    $('#overlay').remove();
                });
            },
            validateImage: function (e) {
                var ext = e.files[0].extension.toLowerCase();
                if (ext != '.jpg' && ext != ".png" && ext != '.jpeg' && ext != '.gif') {
                    $('<a/>').popupBoxExtension({
                        isAjax: false,
                        data: Helpers.validationImage.createMessageUploadPopupContent("Only .jpg, .jpeg, or .png files can be uploaded."),
                        cssClass: 'popup-box-task',
                        callback: function () {
                            Helpers.validationImage.triggerErrorPopup();
                        }
                    });
                    e.preventDefault();
                }
            },

        },

        validateOptions: {
            rules: {
                requiredNumber: function (input) {

                    if (input.attr('requiredNumber') != undefined) {
                        var pattern = /^\d+$/;
                        if ((pattern.test(input.val()) && input.val().length > 0) || input.val().length == 0) {
                            return true;
                        }
                        return false;
                    }
                    return true;
                },
                requiredDecimalNumber: function (input) {

                    if (input.attr('requiredDecimalNumber') != undefined) {
                        var pattern = /^(\d+\.?\d*|\.\d+)$/;
                        if ((pattern.test(input.val()) && input.val().length > 0) || input.val().length == 0) {
                            return true;
                        }
                        return false;
                    }
                    return true;
                }
            },

            messages: {
                requiredNumber: "Only numeric characters are permitted",
                requiredDecimalNumber: "Only numeric characters are permitted"
            }
        },

        Counter: {

            Count: function (controlId, id, mvcController, action, name, multi) {

                if (id == 0) {
                    controlId.text(0);
                    controlId.attr('title', "There are 0 " + name);
                    return;
                }

                this.CountWithJson(controlId, {
                    id: id
                }, mvcController, action, name, multi);
            },

            CountWithJson: function (controlId, jsonData, mvcController, action, name, multi) {
                if (controlId !== undefined) {

                    Helpers.ajaxHelper.postJson({
                        controller: mvcController,
                        action: action,
                        data: jsonData,
                        cache: false,
                        async: false,
                        success: function (data) {
                            if (typeof (multi) === 'undefined') {
                                multi = false;
                            }

                            if (multi) {
                                if (data == 0) {
                                    controlId.text(data);
                                } else {
                                    controlId.text('*');
                                }
                            } else {
                                controlId.text(data);
                                //if (data !== 0) {
                                //    controlId.text(data);
                                //}
                            }
                            controlId.attr('title', "There are " + data + " " + name);
                        }
                    });
                }
            }
        },
        reloadContactPage: function (contactId) {
            var contactUrl = "m/Contact/ContactSummary/ContactPage/" + contactId;
            Helpers.ajaxHelper.getHtml({
                url: contactUrl,
                cache: false,
                async: false,
                success: function (result) {
                    Civica.contactId = contactId;
                    $('.contactpane-' + contactId).empty().append(result);
                    Civica.ContactPage.init();
                },
                showMask: true
            });
        },
        Invoke: function (funcFullName, sender, args) {
            if (typeof funcFullName !== "string") return null;

            var func, funcName, segmentsName = funcFullName.split('.');
            var context = window;

            if (segmentsName.length > 1) {
                funcName = segmentsName.pop();
                for (var i = 0; i < segmentsName.length; i++) {
                    context = context[segmentsName[i]];
                    if (context === undefined) {
                        return null;
                    }
                }
                func = context[funcName];
            } else {
                func = context[funcFullName];
            }

            if (typeof func === 'function') {
                return func.call(context, sender, args);
            }
            return null;
        },
        /** Add new overlay*/
        addNewOverlay: function () {
            var overlay = $('<div id="overlay"></div>');
            if ($('#overlay:visible').length === 0) {
                overlay.appendTo('body').show();
            }
        },
        Pane: {
            Save: function (panElems, timestamp, referenceId, controller, action) {
                Helpers.ajaxHelper.postJson({
                    controller: controller,
                    action: action,
                    data: {
                        panes: panElems,
                        TimestampString: timestamp,
                        PreferenceId: referenceId
                    },
                    traditional: true,
                    success: function (msg) {
                        //debugger;
                        $('.message').html(msg);
                        switch (controller) {
                            case "HomePane":
                                Civica.RegionManager.reloadHomePage();
                                break;
                            case "ContactPane":
                                if (Civica.ContactSummary !== undefined) {
                                    var length = $('.panel-summary-content').find('#ContactSummaryModel_ContactId').length;
                                    var $content = $('.panel-summary-content').find('#ContactSummaryModel_ContactId');
                                    for (var i = 0; i < length; i++) {
                                        Civica.contactId = $content[i].value;
                                        Helpers.reloadContactPage(Civica.contactId);
                                    }
                                }
                                break;
                            case "AssetPane":
                                if (Civica.AssetSummary !== undefined) {
                                    length = $('.panel-summary-content').find('#AssetSummaryModel_AssetId').length;
                                    $content = $('.panel-summary-content').find('#AssetSummaryModel_AssetId');
                                    for (i = 0; i < length; i++) {
                                        Civica.assetId = $content[i].value;
                                        Helpers.reloadAssetPage(Civica.assetId);
                                    }
                                }
                                break;
                            default:
                                clearInterval(Civica.shortcutInterval);
                                Civica.ShortcutManager.loadContent();
                                break;
                        }
                        Civica.RegionManager.reloadCurrentWnd();
                    },
                    pressOkFunction: function () {
                        if (controller === "HomePane") {
                            Civica.RegionManager.reloadHomePage();
                        } else if (controller === "HomeTile") {
                            Civica.ShortcutManager.loadContent();
                        }
                        Civica.RegionManager.reloadCurrentWnd();
                        $('.message').html("");
                    }

                });
            }
        },

        Grid: {
            onColumnReorder: function (args, module, mvcController, action, isExpand) {
                var newIndex = args.newIndex,
                    oldIndex = args.oldIndex,
                    columns = [];
                var controller = args.sender.table.context.id;

                if (oldIndex > newIndex) {

                    // store all first array if it have any items
                    for (var j = 0; j < newIndex; j++) {
                        if (!args.sender.columns[j].hidden) {
                            columns.push(args.sender.columns[j].field);
                        }
                    }

                    // store remain items
                    for (var i = newIndex; i < args.sender.columns.length; i++) {
                        if (!args.sender.columns[i].hidden) {
                            if (i == newIndex) {
                                columns.push(args.sender.columns[oldIndex].field);
                            }
                            if (i < oldIndex || i > oldIndex) {
                                columns.push(args.sender.columns[i].field);
                            }
                        }
                    }
                } else {
                    // store all first array if it have any items
                    for (var l = 0; l < oldIndex; l++) {
                        if (!args.sender.columns[l].hidden && l != oldIndex) {
                            columns.push(args.sender.columns[l].field);
                        }
                    }

                    // store all remain items
                    for (var k = oldIndex + 1; k < args.sender.columns.length; k++) {
                        if (!args.sender.columns[k].hidden) {
                            if (k <= newIndex) {
                                columns.push(args.sender.columns[k].field);
                            }
                            if (k == newIndex + 1) {
                                columns.push(args.sender.columns[oldIndex].field);
                            }
                            if (k > newIndex) {
                                columns.push(args.sender.columns[k].field);
                            }
                        }
                    }

                    // store the last item if drag the first item to last item
                    if (newIndex === args.sender.columns.length - 1) {
                        columns.push(args.sender.columns[oldIndex].field);
                    }

                }

                if (typeof (isExpand) === 'undefined') isExpand = true;
                $.ajax({
                    type: "POST",
                    url: Helpers.resolveUrl('m/' + module + '/' + mvcController + '/' + action + '/?rand=' + Helpers.randomString(16)),
                    data: {
                        columns: columns,
                        isExpanded: isExpand
                    },
                    cache: false,
                    async: false,
                    traditional: true
                }).done(function (msg) { });

            },
            onDataBound: function (args, module, mvcController, action, isExpand) {
                var grid = args.sender;


                $(grid.element).customizeUI();
                var colSort = "",
                    typeSort = "";
                if (typeof args.sender.dataSource.sort() !== 'undefined' && typeof args.sender.dataSource.sort()[0] !== 'undefined') {
                    colSort = args.sender.dataSource.sort()[0]['field'];
                    typeSort = args.sender.dataSource.sort()[0]['dir'];
                    var sort = $(args.sender.dataSource.sort());
                    colSort = sort.map(function () {
                        return this.field;
                    }).get().join();
                    typeSort = sort.map(function () {
                        return this.dir;
                    }).get().join();
                    if (typeof (isExpand) === 'undefined') {
                        isExpand = true;
                    }
                    $.ajax({
                        type: "POST",
                        url: Helpers.resolveUrl('m/' + module + '/' + mvcController + '/' + action),
                        data: {
                            columnSort: colSort,
                            typeSort: typeSort,
                            isExpanded: isExpand
                        },
                        cache: false,
                        async: false,
                        traditional: true
                    }).done(function (msg) {
                        //Helpers.scaleKendoGrid($('.k-grid:visible'));
                    });
                }
            },
            onColumnShow: function (args, module, mvcController, action, isExpand) {
                var controller = args.sender.table.context.id,
                    columns = [];
                for (i in args.sender.columns) {
                    if (!args.sender.columns[i].hidden) {
                        columns.push(args.sender.columns[i].field);
                    }
                }
                if (typeof (isExpand) === 'undefined') isExpand = true;
                $.ajax({
                    type: "POST",
                    url: Helpers.resolveUrl('m/' + module + '/' + mvcController + '/' + action + '/?rand=' + Helpers.randomString(16)),
                    data: {
                        columns: columns,
                        isExpanded: isExpand
                    },
                    cache: false,
                    async: false,
                    traditional: true
                }).done(function (msg) { });
            },
            onColumnHide: function (args, module, mvcController, action, isExpand) {
                var controller = args.sender.table.context.id,
                    columns = [];
                for (i in args.sender.columns) {
                    if (args.sender.columns[i].hidden) {
                        columns.push(args.sender.columns[i].field);
                    }
                }
                if (typeof (isExpand) === 'undefined') isExpand = true;
                $.ajax({
                    type: "POST",
                    url: Helpers.resolveUrl('m/' + module + '/' + mvcController + '/' + action + '/?rand=' + Helpers.randomString(16)),
                    data: {
                        columns: columns,
                        isExpanded: isExpand
                    },
                    cache: false,
                    async: false,
                    traditional: true
                }).done(function (msg) { });
            },
            onError: function (e) {
                Helpers.ajaxHelper.checkError(e.xhr.responseText, e.xhr, {});
            }
        },

        OrderStatus: {
            AwaitingVariationAuthorisation: 4,
            Issued: 5,
            WorkInProgress: 6,
            OnHold: 7,
            PartiallyComplete: 8,
            Complete: 9,
            AwaitingPostInspection: 19,
            Varied: 20
        },

        FinancialStatus: {
            NotInvoiced: 11,
            PartiallyInvoiced: 12,
            FullyInvoiced: 13
        },

        StandardSearch: {
            CONTACT: 'divContacts',
            ASSET: 'divAssets',
            $overlay: '',
            init: function () {
                var me = this;
                me.$overlay = $('<div id="overlay"></div>'),
                this.container().find('a[title="Close"]').click(function (e) {
                    e.preventDefault();
                    me.close();
                });
                $("#divStandardSearchResult").click(function (e) { // click on standard search not close(close proccess in civica.core.js document.click)
                    e.stopPropagation();
                });
                me.contactDetailsTrigger = me.contactDetailsTrigger || $('<button type="button" data-url=' + Helpers.urlBuilder("Contact", "ContactDetails", "Edit", "id=0") + 'class="region-view" data-is-subrootview="true" title="Contact Details">Contact Details</button>');
                me.contactDetailsTrigger.unbind('click').click(function (e) {
                    var contactdetailsWnd = new Civica.RegionView(null, {
                        controlClass: 'contact-detail-view',
                        callback: 'Civica.ContactDetailManagement.init',
                        scaleHeight: 'Civica.ContactDetailManagement.scaleHeight',
                        save: 'Civica.ContactDetailManagement.save',
                        modelId: 0,
                        isSubRootView: true,
                        url: Helpers.urlBuilder("Contact", "ContactDetails", "Edit", "id=0"),
                        title: 'Contact Details'
                    });
                });

                this.container().find('#btnAddNewContact').click(function (e) {
                    me.close();
                    me.contactDetailsTrigger.click();
                });
                me.assetDetailsTrigger = me.assetDetailsTrigger || $('<button type="button" data-url=' + Helpers.urlBuilder("Asset", "AssetDetails", "Index", "id=0") + 'class="region-view" data-is-subrootview="true" title="Asset Details">Asset Details</button>');
                me.assetDetailsTrigger.unbind('click').click(function (e) {
                    var assetDetailsWnd = new Civica.RegionView(null, {
                        controlClass: 'asset-details',
                        callback: 'Civica.assets.AssetManager.init',
                        scaleHeight: 'Civica.AssetDetails.scaleHeight',
                        save: 'Civica.AssetDetails.save',
                        modelId: 0,
                        isSubRootView: true,
                        url: Helpers.urlBuilder("Asset", "AssetDetails", "Index", "id=0"),
                        title: 'Asset Details'
                    });
                });

                this.container().find('#btnAddNewAsset').click(function (e) {
                    me.close();
                    me.assetDetailsTrigger.click();
                });
                $('#standardSearchPattern').keyup(function (e) {
                    me.attempSearch(this);
                    e.preventDefault();
                });
                me.NumberCharactersSearch = $('#NumberCharactersSearch').val();
            },
            attempSearch: function (searchInput) {
                clearTimeout(this.timeoutId);
                if ($(searchInput).val().length >= this.NumberCharactersSearch) {
                    this.timeoutId = setTimeout(this.search, 500);
                }
            },
            search: function () {
                var me = Helpers.StandardSearch;
                me.searchForGrid(me.CONTACT);
                me.searchForGrid(me.ASSET);
                if (!me.visible) {
                    me.show();
                }
            },
            searchForGrid: function (index) {
                var grid = this.getGrid(index);
                if (grid) {
                    grid.dataSource.data([]);
                    grid.dataSource.query({
                        page: 1,
                        pageSize: grid.dataSource.pageSize(),
                        sort: grid.dataSource.sort()
                    });
                    grid.searching = true;
                }
            },
            getGrid: function (index) {
                var container = Helpers.StandardSearch.container();
                var grid = null;
                if (typeof (index) == 'string') {
                    grid = container.find('#' + index + ' div.k-grid[data-role="grid"]').data('kendoGrid');
                } else {
                    grid = $(container.find('div.k-grid[data-role="grid"]')[index]).data('kendoGrid');
                }
                return grid;
            },
            container: function () {
                var divStandardSearchResult = $('#divStandardSearchResult');
                return divStandardSearchResult;
            },
            show: function () {
                var me = Helpers.StandardSearch;
                Civica.AdvanceSearch.hide();
                if ($('#overlay:visible').length === 0) {
                    $('header').css('z-index', "1001");
                    me.$overlay.appendTo('body').show().click(me.close);
                }
                me.container().horizontalCenter().show();
                me.visible = true;
            },
            close: function () {
                var me = Helpers.StandardSearch;
                me.$overlay.remove();
                $('header').removeAttr("style");
                me.container().hide();
                me.visible = false;
            },
            searchPattern: function () {
                return {
                    searchPattern: $('#standardSearchPattern').val()
                };
            },
            dataBound: function (e, index, dblclick) {
                var me = Helpers.StandardSearch,
                    grid = me.getGrid(index),
                    onDblClick = function (e) {
                        e.preventDefault();
                        var data = grid.dataItem(grid.select());
                        if (typeof data !== 'undefined') {
                            me.close();
                            if (dblclick) {
                                dblclick(data);
                            }
                        }
                    };
                $(grid.element).find('table tr').off("doubletap", onDblClick).on("doubletap", onDblClick);
                if (grid.searching) {
                    var emptyMessage = null;
                    if (typeof (index) == 'string') {
                        emptyMessage = me.container().find('#' + index + ' div.empty-grid-message');
                    } else {
                        emptyMessage = $(me.container().find('div.empty-grid-message')[index]);
                    }
                    if (grid.dataSource.data().length > 0) {
                        emptyMessage.hide();
                        $(grid.element).show();
                    } else {
                        $(grid.element).hide();
                        emptyMessage.show();
                    }
                    grid.searching = false;
                }
                $(grid.element).find('div.k-grid-content').css('height', '90px');
            },
            contactRequestEnd: function (e) {
                var pattern = /<script>(.*)<\/script>/;
                if (pattern.test(e.response)) {
                    eval(pattern.exec(e.response)[1]);
                }
                if (e.response && typeof (e.response) == 'string' && e.response.indexOf('loginForm') > -1) {
                    window.location.href = 'login/index';
                }
            },
            contactDataBound: function (e) {
                var me = Helpers.StandardSearch;

                var dblclick = function (data) {
                    var tmp = new Civica.RegionView(null, {
                        controlClass: 'contactsummary',
                        callback: 'Civica.ContactSummary.init',
                        scaleHeight: 'Civica.ContactSummary.scaleHeight',
                        modelId: data.Id,
                        url: Helpers.urlBuilder("Contact", "ContactSummary", "Index", "contactId=" + data.Id),
                        // formOnly: false,
                        title: "Contact Summary",
                        entityId: data.Id,
                        entityType: 'Contact',
                        relatedEntities: 'Contact'
                    });
                };
                me.dataBound(e, me.CONTACT, dblclick);
            },
            assetDataBound: function (e) {
                var me = Helpers.StandardSearch;
                var dblclick = function (data) {
                    var tmp = new Civica.RegionView(null, {
                        controlClass: 'assetsummary',
                        callback: 'Civica.AssetSummary.init',
                        scaleHeight: 'Civica.AssetSummary.scaleHeight',
                        modelId: data.AssetId,
                        url: Helpers.urlBuilder('Asset', 'AssetSummary', 'Index', 'assetId=' + data.AssetId),
                        // formOnly: false,
                        title: "Asset Summary",
                        entityId: data.AssetId,
                        entityType: 'Asset',
                        relatedEntities: 'Asset'
                    });
                };
                me.dataBound(e, me.ASSET, dblclick);
            }
        },

        QuickMenu: {
            init: function () {
                var quickMenu = $('div.quick-menu-list'),
                    collapseAll = function ($exclusiveControl) {
                        //quickMenu.find('ul.level1,ul.level2').hide();
                        quickMenu.find('ul.level1,ul.level2').each(function () {
                            var $this = $(this),
                                $siblingATag = $this.siblings('a');
                            if( $exclusiveControl !== undefined &&  $siblingATag.html() === $exclusiveControl.html()){
                                return;
                            }
                            $this.hide();
                            if ($this.find(' > li:visible').length > 0) {
                                 $siblingATag.addClass('collapse-node').removeClass('expand-node');
                            } else {
                                 $siblingATag.removeClass('collapse-node').addClass('expand-node');
                            }
                        });

                        quickMenu.find('div.quick-menu-wrap > ul > li > a').not(":only-child").addClass('collapse-node').removeClass('expand-node');
                    };

                quickMenu.find('div.quick-menu-wrap > ul > li > a').click(function (e) {
                    var $this = $(this);
                    collapseAll($this);
                    if($this.hasClass('collapse-node')){
                        $this.removeClass('collapse-node').addClass('expand-node');
                    } else {
                        $this.removeClass('expand-node').addClass('collapse-node');
                    }
                    quickMenu.find('ul.level1,ul.level2').siblings('a').removeClass('expand-node').addClass('collapse-node');
                });
                collapseAll();
                var changeTextFunc = function () {
                    quickMenu.find('ul.level1,ul.level2').show();
                    quickMenu.find('ul.level1,ul.level2').siblings('a').addClass('expand-node');
                    var text = $(this).val();
                    var listItems = $('div.quick-menu-wrap ul.list-background li');
                    if (text.length) {
                        listItems.hide().each(function (index, li) {
                            var $li = $(li);
                            if ($li.has('a:containsCaseInsensitive("' + text + '")').length) {
                                $li.show();
                                $(li).parents('ul.level1 > li:first').show();
                                $(li).parents('ul.list-background > li:first').show();

                            }
                        });
                    } else {
                        quickMenu.find('ul.bgcolor-lightgrey li a,ul.level1 li a').show();
                        collapseAll();
                        listItems.show();
                        quickMenu.find('ul.bgcolor-lightgrey li a,ul.level1 li a').removeClass('expand-node');
                    }

                    $('div.quick-menu-list').show();
                    $('div.quick-menu-list ul.level1:visible, div.quick-menu-list ul.level2:visible').each(function () {
                        var hiddenLi = $(this).children('li:visible').length;
                        if (hiddenLi == 0) {
                            $(this).siblings("a").removeClass('expand-node collapse-node');
                        }
                    });
                };
                $('#quickMenuFilterBox')
                    .click(function (e) {
                        e.stopPropagation();
                    })
                    .keyup(function (e) {
                        changeTextFunc.call(this);
                    })
                    .change(function (e) {
                        changeTextFunc.call(this);
                        //alert('x');
                    });
            }
        },

        Dialog: {
            confirm: function (dialogOptions) {
                var o = $.extend({
                    content: ''
                }, dialogOptions),
                    html = '<div class="popup-box-standard-width"><div id="showMessagePop" class="popup-box-head accent-colour-background clearfix">' +
                        '<div class="box-title normal-text left">' +
                        'Confirm</div>' +
                        '</div>' +
                        '<div class="popup-box-content">' + o.content + '</div>' +
                        '<div class="YNButton clearfix" id="buttons-message">' +
                        '<button id="btnYes" type="button" title="Yes" class="active-background active-text">' +
                        'Yes</button>' +
                        '<button id="btnNo" type="button" title="No" class="active-background active-text">' +
                        'No</button>' +
                        '</div></div>';
                this.dialogTrigger = $(html);
                var that = this;
                this.dialogTrigger.popupBoxExtension({
                    isAjax: false,
                    data: this.dialogTrigger,
                    callback: function (options) {
                        var popup = this;
                        that.close = function (fn) {
                            popup.pobox.remove();
                            popup.overlay.detach();
                            if (fn && typeof (fn) == "function") {
                                fn();
                            }
                        };
                        this.pobox.find('#btnNo').click(function (e) {
                            that.close(options.no);
                        });
                        this.pobox.find('#btnYes').click(function (e) {
                            that.close(options.yes);
                        }).focus();
                    },
                    callbackOptions: {
                        yes: o.yes,
                        no: o.no
                    },
                    enterKeyDown: function (e) {
                        this.pobox.find('#btnYes').click();
                    },
                    escapeKeyDown: function (e) {
                        if (o.no) {
                            o.no();
                        }
                    }
                });
                return this;
            },
            notification: function (dialogOptions) {
                var o = $.extend({
                    content: '',
                    title: 'Notifications',
                    isPopUpForPopUp: false,
                    callbackPopup: function () { }
                }, dialogOptions),
                    html = '<div id="showMessagePop" class="popup-box-head accent-colour-background clearfix">' +
                        '<div class="box-title normal-text left">' + o.title +
                        '</div>' +
                        '</div>' +
                        '<div class="popup-box-content">' + o.content + '</div>' +
                        '<div class="YNButton clearfix" id="buttons-message">' +
                        '<button id="btnOK" type="button" title="OK" class="active-background active-text">' +
                        'OK</button>' +
                        '</div>';
                this.dialogTrigger = $(html);
                var that = this;
                this.dialogTrigger.popupBoxExtension({
                    isAjax: false,
                    data: this.dialogTrigger,
                    callback: function (options) {
                        var popup = this;
                        that.close = function (fn) {
                            popup.pobox.remove();
                            if (o.isPopUpForPopUp === false) {
                                popup.overlay.detach();
                            }
                            if (fn && typeof (fn) == "function") {
                                fn();
                            }
                            o.callbackPopup();

                        };
                        this.pobox.find('#btnOK').click(function (e) {
                            e.preventDefault();
                            e.stopPropagation();
                            $(document).off('keyup');
                            that.close(options.ok);
                            Civica.RegionManager.bindKeyUp();
                            return false;
                        }).focus();
                    },
                    callbackOptions: {
                        ok: o.ok,
                    },
                    enterKeyDown: function (e) {
                        this.pobox.find('#btnOK').click();
                    },
                    escapeKeyDown: function (e) {
                        if (o.ok) {
                            o.ok();
                        }
                    }
                });
                return this;
            }
        },

        //extend from an object
        extend: function (protobj, skipBaseConstructor) {
            protobj = protobj || {};
            var subClass = null;
            var baseConstructor = this;
            if (typeof (baseConstructor) != "function") {
                baseConstructor = this.init;
            }

            if (protobj.init) {
                subClass = function () {
                    if (!skipBaseConstructor) {
                        baseConstructor.apply(this, arguments);
                    }
                    protobj.init.apply(this, arguments);
                };
            } else {
                subClass = function () {
                    if (!skipBaseConstructor) {
                        baseConstructor.apply(this, arguments);
                    }
                };
                protobj.init = baseConstructor;
            }
            subClass.prototype = subClass.prototype || {};
            $.extend(true, subClass.prototype, this.prototype, protobj);
            subClass.extend = this.extend;
            return subClass;
        },

        textExpandable: function (contextElement) {
            var container = $;
            if (contextElement) {
                container = $(contextElement);
            }
            var textareas = container.find('textarea[expandable]');
            $.each(textareas, function (index, textarea) {
                $(textarea).removeAttr("cols").removeAttr("rows").css('resize', 'none');
                if ($(textarea).attr("redacted") === undefined) {
                    $(textarea).css("width", "100%");
                }

                $(textarea).expand();

                $(textarea).blur(function (e) {
                    $(textarea).collapse();
                });
            });
        },

        textExpandableFocus: function (contextElement) {
            //var container = $;
            //if (contextElement) {
            //    container = $(contextElement);
            //}
            //var textBoxes = container.find('input[expandable]');
            //$.each(textBoxes, function (index, textBox) {
            //    $(textBox).attr('title', $(textBox).val());
            //});
            //if ($(contextElement).isExpandable()) {
            //    textBoxes.push($(contextElement)[0]);
            //}
            //return textBoxes
            //    .css('text-overflow', 'ellipsis')
            //    .focus(function (e) {
            //        e.preventDefault();
            //        $(this).expand();
            //    });
        },
        customizeUI: function (contextElement) {
            // Firstly, call customizeCheckBoxes on it then set any grids to also be rendered with a scrollbar
            Helpers.customizeCheckBoxes(contextElement);
            //Helpers.customizeScrollbars(contextElement);
        },
        customizeCheckBoxes: function (contextElement) {
            var container = $;
            if (contextElement) {
                container = $(contextElement);
            }
            var checkBoxes = container.find('input[type="checkbox"]');
            if ($(contextElement).is(':checkbox')) {
                checkBoxes.push($(contextElement)[0]);
            }
            return checkBoxes.imageCheckBox();
        },
        customizeScrollbars: function (contextElement) {
            /*
            var container = $;
            if (contextElement) {
                container = $(contextElement);
            }
            $(container).find(".k-grid-content").each(function() {
                var $grid = $(this).closest(".k-grid");
                var contentHeight = $grid.parent().height();
                var headerHeight = $grid.find(".k-grid-header").outerHeight(true);
                var pagerHeight = $grid.find(".k-grid-pager").outerHeight(true);
                var height = contentHeight - headerHeight - pagerHeight;                
                $(this).slimScroll({ railVisible: true, height: height });
            });
            */

            //var $container = $('body');
            //if (contextElement !== undefined) {
            //    $container = $(contextElement);
            //}
            //if(typeof $.fn.mCustomScrollbar === 'function' && kendo.support.browser.webkit != true && kendo.support.touch == false && $container.hasClass('mCustomScrollbar') == false){
            //    $container.mCustomScrollbar({
            //        autoDraggerLength: false,
            //        autoHideScrollbar: true,
            //        theme: 'dark-thick',
            //        scrollButtons:{
            //            enable: false
            //        },

            //        advanced:{
            //            updateOnBrowserResize:true, /*update scrollbars on browser resize (for layouts based on percentages): boolean*/
            //            updateOnContentResize:true, /*auto-update scrollbars on content resize (for dynamic content): boolean*/
            //            autoExpandHorizontalScroll:false, /*auto-expand width for horizontal scrolling: boolean*/
            //            autoScrollOnFocus:false, /*auto-scroll on focused elements: boolean*/
            //            normalizeMouseWheelDelta:false /*normalize mouse-wheel delta (-1/1)*/
            //        },
            //    });
            //}

        },
        GenericScaleHeight: function(uid, idOfTypeContent){
            var uidCssClass = '.' + uid;
            var $element = $(idOfTypeContent, uidCssClass);
            Helpers.computeScaleHeight($element, uidCssClass);            
        },

        ContactScaleHeight: function (uid) {
            Helpers.GenericScaleHeight(uid, '#cx-contact');
            // Helpers.AutoRefresh.ContactAlertRefresh();
        },
        AssetScaleHeight: function (uid) {
            Helpers.GenericScaleHeight(uid, '#cx-asset');
            // Helpers.AutoRefresh.AssetAlertRefresh();
        },
        RepairScaleHeight: function (uid) {
            Helpers.GenericScaleHeight(uid, '#cx-repair');
            // Helpers.AutoRefresh.RepairRequestAlert();
        },
        ContractorScaleHeight: function (uidCssClass) {
            Helpers.GenericScaleHeight(uid, '#cx-contractor');
        },

        ContractScaleHeight: function (uidCssClass) {
            Helpers.GenericScaleHeight(uid, '#cx-contract');
        },

        computeScaleHeight: function ($cxElement, uidCssClass) {
            if ($cxElement) {
                $('section').scaleHeight({
                    callback: function () {
                        $('section').scaleHeight({
                            wrap: 'panel-wordspace',
                            useSpace: ['process-tiles', 'action-button'],
                            freeSpace: ['panel-wrap'],
                            adjustSpace: 0,
                            callback: function () {
                                var marginP = parseInt($('.panel').css('margin-right')),
                                    pH = parseInt($('.panel-wrap').height() / 2) - 2 * marginP;
                                $('.panel', uidCssClass).height(pH);
                            }
                        });
                    }
                });
            }
        },

        tooglePadLockTile: function (status, idProcessTile, context) {
            if (context === null || context === undefined) {
                context = '.' + Civica.RegionManager.getRootCurrentUID();
            }
            // status: 0=active , 1=lock
            if (status == null) {
                status = 0;
            }
            if (context != null && idProcessTile != null) {
                var processTile = $('#' + idProcessTile, context);
                if (processTile.length > 0) {
                    if (status === 1) {
                        var spanNoLock = processTile.find('.shortcuts-tile-nolock');
                        if (spanNoLock.length > 0 && processTile.data('events') && processTile.data('events').click && processTile.data('events').click.length>0) {
                            var clickFunc = processTile.data('events').click[0].handler;
                            processTile.unbind('click').data('click', clickFunc);
                            spanNoLock.removeClass('shortcuts-tile-nolock');
                            spanNoLock.addClass('shortcuts-tile-lock');
                        }
                    } else if (status === 0) {
                        var spanLock = processTile.find('.shortcuts-tile-lock');
                        if (spanLock.length > 0) {
                            processTile.bind('click', processTile.data('click'));
                            spanLock.removeClass('shortcuts-tile-lock');
                            spanLock.addClass('shortcuts-tile-nolock');
                        }
                    }
                }
            }
        },
        disableProcessTile: function (idProcessTile, value, context) {
            if (idProcessTile === "" || idProcessTile === null) {
                return;
            }
            if (context === null || context === undefined) {
                context = '.' + Civica.RegionManager.getRootCurrentUID();
            }            
            var processTile = $('#' + idProcessTile, context);
            if (processTile.length > 0) {
                if (value === true) {
                    if (processTile.data('events') && processTile.data('events').click && processTile.data('events').click.length > 0) {
                        var clickFunc = processTile.data('events').click[0].handler;
                        processTile.unbind('click').data('click', clickFunc);
                    }
                } else {
                    processTile.bind('click', processTile.data('click'));
                }
            }
        },
        disableProcessTile: function (idProcessTile, value, context) {
            if (idProcessTile === "" || idProcessTile === null) {
                return;
            }
            if (context === null || context === undefined) {
                context = '.' + Civica.RegionManager.getRootCurrentUID();
            }            
            var processTile = $('#' + idProcessTile, context);
            if (processTile.length > 0) {
                if (value === true) {
                    if (processTile.data('events') && processTile.data('events').click && processTile.data('events').click.length > 0) {
                        var clickFunc = processTile.data('events').click[0].handler;
                        processTile.unbind('click').data('click', clickFunc);
                    }
                } else {
                    processTile.bind('click', processTile.data('click'));
                }
            }
        },
        getLockStatus: function (idProcessTile, context) {
            var processTile = $('#' + idProcessTile, context);
            if (processTile.length > 0) {
                var spanLock = processTile.find('.shortcuts-tile-lock');
                if (spanLock.length > 0) {
                    return true;
                } else {
                    return false;
                }
            }
        },

        
        replaceAll: function (stringSource, stringToFind, stringToReplace) {
            var temp = stringSource;
            var index = temp.indexOf(stringToFind);
            while (index != -1) {
                temp = temp.replace(stringToFind, stringToReplace);
                index = temp.indexOf(stringToFind);
            }
            return temp;
        },


        ConfigViewScaleHeight: function (uidCssClass, idOfTypeContent) {
            if ($(idOfTypeContent).length > 0) {
                $('section').scaleHeight({
                    callback: function () {
                        $('section').scaleHeight({
                            wrap: 'panel-wordspace',
                            useSpace: ['process-tiles', 'action-button'],
                            freeSpace: ['panel-wrap'],
                            adjustSpace: 0,
                            callback: function () {
                                var marginP = parseInt($('.panel').css('margin-right')),
                                    pH = parseInt($('.panel-wrap').height() / 2) - 2 * marginP;
                                $('.panel', uidCssClass).height(pH);
                            }
                        });
                    }
                });
            }
        },

        SORScaleHeight: function (uidCssClass) {
            Helpers.ConfigViewScaleHeight(uidCssClass, '#cx-SORs');
        },

        StatementScaleHeight: function (uidCssClass) {
            Helpers.ConfigViewScaleHeight(uidCssClass, '#cx-statement');
        },
        cutLongTitle: function (uid) {
            if (($(".message", '.' + uid).length > 0 && $(".message", '.' + uid).html().trim().length > 0) || ($(".record-not-saved-message", '.' + uid).length > 0 && $(".record-not-saved-message", '.' + uid).html().trim().length > 0)) {
                $(".title-bar-without-button", '.' + uid).css("maxWidth", "57%");
            } else {
                $(".title-bar-without-button", '.' + uid).css("maxWidth", "100%");
            }

        }

    };



    Helpers = new UtilityClass();

    //Core functions
    Helpers.AjaxCore = Helpers.extend({
        JSON: 'json',
        HTML: 'html',
        POST: 'POST',
        GET: 'GET',
        SLASH: '/',
        AND: '&',
        QUESTION_MARK: '?',

        //called when an ajax request is completed
        ajaxComplete: function (uid) {
            if (this.mask) {
                $.unblockUI();
                this.mask = null;
            }

        },

        getRootUrl: function () {
            var rootUrl = Helpers.rootUrl;
            if (/\/.+/.test(rootUrl)) {
                rootUrl = rootUrl + this.SLASH;
            }
            return rootUrl;
        },

        //get url from controller, action
        buildUrl: function (controller, action) {
            // Xuan edited
            //var rootUrl = this.getRootUrl();
            var rootUrl = '';
            var url = rootUrl + controller + this.SLASH + action;
            return url.replace("//", "/");
        },

        checkError: function (response, jqXhr, options) {
            var result = null;
            if (typeof (response) == "string" && jqXhr.getResponseHeader("Content-Type") !== null && jqXhr.getResponseHeader("Content-Type") !== undefined && jqXhr.getResponseHeader("Content-Type").indexOf('application/json') >= 0) {
                result = eval('(' + response + ')');
            }

            if (result) {

                if (result.ErrorMessage !== '') {
                    var myArray = this.parseErrorMessage(result.ErrorMessage);
                    var errorMessage = "";
                    if (myArray.length >= 2) errorMessage = myArray[1];
                    if (jqXhr.status == 500) {
                        if (result.ErrorCode === 1000) { // error code return by server is 1000, that mean somewhere have obsolete data
                            // show data out update message box
                            this.showDataOutUpdateDialog(errorMessage, options);
                        } else if (result.ErrorCode === 1001) { // obsolete data refresh exception
                            // a.Hien will insert code here for processing this case
                            // ...
                            this.showDataOutUpdateDialog(errorMessage, options);
                        } else if (result.ErrorCode === 1002) { //DataAccess Error Or Generic ADO Error
                            this.showMessage(errorMessage, "An error occurred");
                        } else if (result.ErrorCode === -1) { //make sure request already pass from server side
                            this.showErrorMessage(myArray, result.StackTrace);

                        } else if (result.ErrorCode === 2001) {
                            this.showMessage(errorMessage, "Permission Denied");
                        } else if (result.ErrorCode === 1003) { //Validation error: 1003
                            var uidCssClass = '.' + Civica.RegionManager.getRootCurrentUID();
                            var template = kendo.template($("#template").html());

                            // Check current screen is popup or not
                            if ($(".popup").length !== 0) {
                                uidCssClass = $(".popup");
                            } else {
                                // Show error message on title
                                $(".panel-header-title-bar > .message", uidCssClass).html("");

                                // Get description For Title Bar
                                var description = $(".panel-header-title-bar :first-child  :first-child", uidCssClass);
                                var htmlDescription = description.html();
                                //cut title
                                Helpers.cutLongTitle(Civica.RegionManager.CurrentRegionView.uid);
                                description.attr("title", "");
                                description.trunk8('update', htmlDescription);
                                if (htmlDescription == "") {
                                    description.html("");
                                }
                            }

                            var handleErrorDefault = options.handleErrorDefault;
                            if (Helpers.isNull(handleErrorDefault) || (handleErrorDefault === true)) {
                                //fixed #20072, Change to Save if validation failed
                                var btnSave = $(".header-save-btn", uidCssClass);
                                if (btnSave.text() === 'Saving') {
                                    btnSave.text('Save');
                                }

                                var popmessage = "";
                                var headerTitle = "Validation Errors";

                                // Update validation error for invalid field
                                $("span[name='ValidationErrorMessage']", uidCssClass).remove();
                                $("span.k-invalid-msg", uidCssClass).hide();

                                for (var i = 0; i < result.ValidationResultModel.DefaultValidationResult.length; i++) {
                                    var modelState = result.ValidationResultModel.DefaultValidationResult[i];
                                    for (var j = 0; j < modelState.MemberNames.length; j++) {
                                        var memberName = modelState.MemberNames[j];
                                        //if message display in popup mode or not inline mode will not process inline
                                        //Enum value: INLINE = 1, POPUP = 2, OTHERS = 3//pass from server
                                        var popup = 2;
                                        var others = 3;
                                        var isPopupMessage = modelState.HandlerType == popup;
                                        if (isPopupMessage || modelState.HandlerType == others) {
                                            if (isPopupMessage) {
                                                popmessage = popmessage + modelState.ErrorMessage + "\n";
                                                headerTitle = result.ErrorMessage;
                                            }
                                            continue;
                                        }


                                        var inputMemberName = "input[name='" + memberName + "']";
                                        if (typeof $(inputMemberName, uidCssClass).data('role') === 'undefined') {
                                            $(inputMemberName, uidCssClass).addClass('k-invalid').parent()
                                                .append(template({
                                                    content: modelState.ErrorMessage
                                                }));

                                        } else {
                                            $(inputMemberName, uidCssClass).siblings('.k-formatted-value').addClass('k-invalid');
                                            if ($(inputMemberName, uidCssClass).data('role') !== 'datepicker') {
                                                $(inputMemberName, uidCssClass).addClass('k-invalid').parent().addClass('k-invalid');
                                            }
                                            $(inputMemberName, uidCssClass).addClass('k-invalid').parent().parent()
                                                .append(template({
                                                    content: modelState.ErrorMessage
                                                }));
                                        }


                                        $("textarea[name='" + memberName + "']", uidCssClass).siblings('input').addClass('k-invalid');
                                        $("textarea[name='" + memberName + "']", uidCssClass).addClass('k-invalid').parent()
                                            .append(template({
                                                content: modelState.ErrorMessage
                                            }));

                                    }
                                }
                            }
                            if (popmessage.length > 0)
                                this.showMessage(popmessage,headerTitle);
                            // Send data to callback to handle this error
                            var callback = options.callback;
                            if (callback) {
                                callback(result.ValidationResultModel);
                            }
                            this.markProcesTilesWhenValidateFailed();
                        } else if (result.ErrorCode === 1004) { // permission errors
                            this.showMessage("Sorry, You don't have permission", "An error occurred");

                        } else if (result.ErrorCode == undefined) {
                            this.showMessage("Sorry, services are unavailable.  Please try again later.", "An error occurred");
                        }
                    } else { // server unavailable of or network connection lost

                        this.showMessage("Sorry, services are unavailable.  Please try again later.", "An error occurred");
                    }
                }
                return false;
            }
            $("#loader").remove();
            this.showMessage("Sorry, services are unavailable.  Please try again later.", "An error occurred");
            return true;
        },
        markProcesTilesWhenValidateFailed: function () {
            if (Helpers.isNull(Civica.RegionManager.CurrentRegionView))
                return;
            var uidClass = "." + Civica.RegionManager.CurrentRegionView.uid;
            var processTiles = $(".process-tile", uidClass);
            var rootForm = Civica.RegionManager.CurrentRegionView.getForm();
            var inputs = null;
            if (rootForm.length > 0) {
                inputs = $(rootForm).find(".k-invalid").length;
                if (inputs > 0) {
                    $(processTiles[0]).addClass("validation-failed");
                }

            }

            var childCount = Civica.RegionManager.CurrentRegionView.children.length;
            for (var i = 0; i < childCount; i++) {
                var form = Civica.RegionManager.CurrentRegionView.children[i].getForm();
                if (form.length > 0) {
                    inputs = $(form).find(".k-invalid").length;
                    var errorMsgs = $(form).find(".k-invalid-msg").length;

                    if (inputs > 0 || errorMsgs > 0) {
                        $(Civica.RegionManager.CurrentRegionView.children[i].$linkToOpen).addClass("validation-failed");
                    }
                }
            }
        },
        showMessage: function (message, title, fcallback, isOutOfDate) {
            var closeCssClass = isOutOfDate === true ? 'out-of-date-close' : 'close';
            var content = '<div id="showMessagePop" class="popup-box-head accent-colour-background clearfix">' +
                '<div class="box-title normal-text left">' + title + '</div>' +
                '<div class="button-funcs right">' +
                '<a id="pop-close" href="#" title="Close" class="' + closeCssClass + '">Close</a>' +
                '</div>' +
                '</div>' +
               '<div class="popup-box-content">' + message + '</div>' +
                '<div class = "YNButton clearfix">' + '<button id="btnOk" type="button" title="Ok"' + 'class="active-background active-text">' + 'Ok</button>' + '</div>';
            if (isOutOfDate === true) {
                $('.popup-box:visible').hide();
            }
            $('</a>').popupBoxExtension({
                isAjax: false,
                data: content,
                cssClass: 'popup-message-box',
                enterKeyDown: function (e) {
                    if (typeof Civica !== 'undefined' && typeof Civica.RegionManager !== 'undefined') {
                        Civica.RegionManager.closePopup(popup);
                    }
                },
                callback: function (opts) {
                    var popup = this;
                    this.pobox.find('a.close').click(function (e) {
                        if (typeof Civica !== 'undefined' && typeof Civica.RegionManager !== 'undefined') {
                            Civica.RegionManager.closePopup(popup);
                        }
                    });

                    this.pobox.find('a.out-of-date-close').click(function (e) {
                        if (typeof Civica !== 'undefined' && typeof Civica.RegionManager !== 'undefined') {
                            Civica.RegionManager.closePopup(popup);
                        }

                        if (typeof fcallback === 'function') {
                            fcallback();
                        }
                    });

                    this.pobox.find('#btnOk').on('click', function () {
                        if (typeof Civica !== 'undefined' && typeof Civica.RegionManager !== 'undefined') {
                            Civica.RegionManager.closePopup(popup);
                            $('.popup-box').show();
                        }

                        if (typeof fcallback === 'function') {
                            fcallback();
                        }
                    });
                },
                callbackOptions: {}
            });
        },

        showDataOutUpdateDialog: function (errorMessage, options) {
            var mainContent = 'Your changes have not been applied as the record has been updated by another user. Please review their changes, and re-apply your changes if applicable.';
            this.showMessage(mainContent, 'Confirm', options.pressOkFunction, true);
        },
        showErrorMessage: function (myArray, errorDetails) {
            var errorMessage = myArray[0];
            if (errorMessage) {
                kendo.logToConsole(errorDetails);

                var template = Civica.RegionManager.ErrorContent;
                var inlineTemplate = kendo.template(template);
                var staticMessage = 'Sorry, a problem occurred while attempting to  complete the action you requested. You can try again, but if the problem persists please Email Support.';
                var sendingMessage = "";
                if (myArray.length > 0) {
                    sendingMessage = myArray[0];
                }
                var inlineData = {
                    os: navigator.userAgent, //$.client.os,
                    screenResolution: window.screen.availWidth + " x " + window.screen.availHeight,
                    browser: kendo.support.browser + ' ' + kendo.support.browser.version,
                    errorDetails: sendingMessage
                };
                var errorContent = inlineTemplate(inlineData);
                this.errorTrigger = $(errorContent);
                this.errorTrigger.popupBoxExtension({
                    isAjax: false,
                    data: this.errorTrigger,
                    callback: function (options) {
                        var popup = this;
                        this.pobox.find('a.close').click(function (e) {
                            e.preventDefault();
                            popup.pobox.remove();
                            popup.overlay.detach();
                            $("#loader").remove();
                            e.stopPropagation();
                        });
                    },
                    callbackOptions: {}
                });
            }
        },
        parseErrorMessage: function (errorMessage) {
            var myArray = new Array();
            myArray[0] = "";
            return (errorMessage == null || errorMessage == undefined ? myArray : errorMessage.split("@@@"));
        },
        //send ajax request
        ajax: function (options) {
            var url = options.url,
                async = (typeof options.async === 'undefined') ? true : options.async,
                traditional = options.traditional == undefined ? false : options.traditional;
            if (!url) {
                url = this.buildUrl(options.controller, options.action);
            }
            var rootUrl = this.getRootUrl();
            if (options.showMask) {
                this.mask = {
                    css: {
                        backgroundColor: 'transparent',
                        border: 'none',
                        zIndex: 10002
                    },
                    //message: '<img width="54" height="55" src="' + rootUrl + 'Images/img/ajax-loader.gif" />'
                    message: '<div class="alert alert-info bold" role="alert">LOADING...</div>'
                };
                $.blockUI(this.mask);
            }

            return $.ajax({
                url: url,
                data: options.data,
                dataType: options.dataType,
                type: options.type,
                cache: options.cache,
                async: async,
                traditional: traditional,
                context: this,
                success: function (result, textStatus, jqXHR) {
                    var isSuccessful = true;
                    if (result) {
                        //isSuccessful = this.checkError(result, jqXHR, options);
                        if (result.redirect) {
                            window.location = result.redirect;
                            isSuccessful = false;
                        }
                    }
                    var ct = jqXHR.getResponseHeader("content-type") || "";
                    var hiddenDivId = "";
                    if (ct.indexOf('html') > -1 && options.dataType !== 'json') {
                        hiddenDivId = "hiddenDiv" + new Date().getTime();
                        result = result + "<div id='" + hiddenDivId + "' style='display:none'></div>";// auto add wrapper to result to process security issue

                    }
                   
                    if (isSuccessful) {
                        try {
                            options.success.call(this, result);
                            var $htmlResult = $("#" + hiddenDivId).parent();
                           
                            var isSavable = $('#isSaveAble', $htmlResult);
                            if (typeof isSavable != "undefined" && isSavable != null && isSavable.val() == "False") {
                                Helpers.readOnlyAllKendoUIControl($htmlResult);
                                console.log("Set ReadOnly Control");
                            }
                            $("#" + hiddenDivId).remove();
                        } catch (error) {
                            this.showErrorMessage(error, error);
                            console.log("Ajax Error:" + error);
                        }
                    }

                    this.ajaxComplete(options.viewUid);

                    if (options.type == 'POST') {
                        var saveEl = $(".header-save-btn:visible");
                        if (saveEl.text() == 'Saving') {
                            saveEl.text('Saved');
                        }
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {

                    //source code added because when save failed will not perform dirty checking
                    var regionview = Civica.RegionManager.get(options.viewUid);//viewUid only available when save 
                    if (!Helpers.isNull(regionview))
                        regionview.originalModel = regionview.originalModel + " ";//trick to make form stay dirty when save failed

                    if (options != undefined && options.type == "POST") {
                        var currentParentUid = (typeof Civica.RegionManager.CurrentRegionView === 'undefined' || Civica.RegionManager.CurrentRegionView == null) ? undefined : Civica.RegionManager.CurrentRegionView.uid;
                        if (typeof currentParentUid != 'undefined') {
                            if ($('.popup-box-vary-task').length > 0) {
                                // especial case : vary task in order details
                                $('.message', '.popup-box-vary-task').empty();
                                $('.message', '.popup-box-vary-task').html('Exception occurred while saving data');
                            } else {
                                var currentParentUidCssClass = '.' + currentParentUid;
                                if ($('#error-message', currentParentUidCssClass).length > 0) $('#error-message', currentParentUidCssClass).empty();
                                if ($('.message-validation', currentParentUidCssClass).length > 0) $('.message-validation', currentParentUidCssClass).empty();
                                if ($('.message', currentParentUidCssClass).length > 0) {
                                    $('.message', currentParentUidCssClass).empty();
                                    $('.message', currentParentUidCssClass).html('Exception occurred while saving data');
                                }
                            }
                        }
                    }

                    this.checkError(jqXHR.responseText, jqXHR, options);
                    this.ajaxComplete();
                }

            });

            //return false;
        },

        //send ajax request with data in JSON format and GET verb
        getJson: function (options) {
            var defaultOptions = {
                dataType: this.JSON,
                type: this.GET
            };
            var ajaxOptions = $.extend({}, defaultOptions, options);
            this.ajax(ajaxOptions);
        },

        //send ajax request with data in JSON format and POST verb
        postJson: function (options) {
            var defaultOptions = {
                dataType: this.JSON,
                type: this.POST
            };
            var ajaxOptions = $.extend({}, defaultOptions, options);
            return this.ajax(ajaxOptions);
        },

        //send ajax request with data in HTML format and GET verb
        getHtml: function (options) {
            var defaultOptions = {
                dataType: this.HTML,
                type: this.GET
            };
            var ajaxOptions = $.extend({}, defaultOptions, options);
            return this.ajax(ajaxOptions);
        },

        //send ajax request with data in HTML format and POST verb
        postHtml: function (options) {
            var defaultOptions = {
                dataType: this.HTML,
                type: this.POST
            };
            var ajaxOptions = $.extend({}, defaultOptions, options);
            return this.ajax(ajaxOptions);
        },

        //navigate to a url built from controller, action
        redirectToAction: function (options) {
            var url = this.buildUrl(options.controller, options.action);
            if (options.params) {
                if (options.params.length > 1) options.params.unshift(this.QUESTION_MARK);
                url = url + this.SLASH + options.params.join(this.AND);
            }
            window.location = url;
        }
    });
    Helpers.ajaxHelper = new Helpers.AjaxCore();
    $.fn.extend({
        placeholder: function () {
            var $input = $(this);
            if (typeof document.createElement("input").placeholder == 'undefined') {
                $input.val($input.attr('placeholder'));
                $input.focus(function () {
                    if ($input.val() == $input.attr('placeholder')) {
                        $input.val('');
                    }
                }).blur(function () {
                    if ($input.val() == '') {
                        $input.val($input.attr('placeholder'));
                    }
                });
            }
        },
        isExpandable: function () {
            var element = this[0];
            if (Helpers.isNull(element) === false && element.tagName.toLowerCase() == 'textarea' && $(element).attr('expandable') !== undefined) {
                return true;
            }
            return false;
        },
        collapse: function () {
            var textarea = this[0];
            var textbox = textarea.textbox;
            var value = $(textarea).val();
            textbox.val(value.replace("\r\n", "\n").split("\n")[0]).show();
            textbox.attr("title", value);

            $(textarea).hide();
        },
        expand: function () {
            var element = this[0];
            if ($(this).isExpandable()) {
                var value = $(element).val();
                var isRedacted = $(element).attr("redacted") !== undefined;
                var id = $(element).attr("id");
                var textbox = element.textbox;

                if (textbox) {
                    textbox.updatePosition();
                    textbox.show();
                    $(this).hide(); //incase text area disable focus not work

                    //textbox.focus();
                } else {
                    textbox = element.textbox = $('<input data-isExpandable="true" type="text" id="' + id + '"/>');
                    $(element).attr("id", id + "_textarea").attr('data-isExpandable');
                    var zIndex = 10002;
                    textbox.css('text-overflow', 'ellipsis')
                        //.width($(element).width())
                        //.css('position', 'absolute')
                    .css('float', 'left') //make sure redacted icon on the right
                        .css('z-index', zIndex)
                        .val(value.replace("\r\n", "\n").split("\n")[0])
                        .attr("title", value)
                        .focus(function (e) {
                            e.preventDefault();

                            $(this).hide();
                            $(element).show();
                            $(element).focus();
                        });

                    if (!isRedacted) {
                        //    textbox.css('position', 'absolute');
                        textbox.css("width", "100%");
                    }
                    if ($(element).attr("disabled") !== undefined) textbox.attr("disabled", true);
                    textbox.updatePosition = function () {
                        //$(this).css('top', $(element).position().top)
                        //    .css('left', $(element).position().left);
                    };
                    textbox.updatePosition();
                    textbox.show();

                    $(element).removeAttr("disabled"); //make sure it'll be serialized

                    $(element).parent().prepend(textbox);
                    $(this).hide();
                }
            }

            return this;
        },
        textExpandable: function () {
            Helpers.textExpandable(this);
            return this;
        },
        textExpandableFocus: function () {
            Helpers.textExpandableFocus(this);
            return this;
        },
        serializeJson: function () {
            var o = {};
            var a = this.serializeArray();
            $.each(a, function () {
                if (o[this.name] !== undefined) {
                    if (!o[this.name].push) {
                        o[this.name] = [o[this.name]];
                    }
                    o[this.name].push(this.value || '');
                } else {
                    o[this.name] = this.value || '';
                }
            });
            return o;
        },
        //focus on the first text input element in the context element calling this function
        firstFocus: function () {
            var $input = $(this).find('input[type="text"]:first'),
                $button = $('button', this),
                $close = $(".close", $(this));

            if ($input.length > 0) {
                $input.focus();
                $input.select();
            } else {
                if ($button.length > 0) $button.focus().select();
                else $close.focus().select();
            }
            return this;
        },

        center: function () {
            this.css("position", "absolute")
                .css('margin-left', '0px')
                .css('margin-top', '0px')
                .css("top", Math.max(0, (($(window).height() - this.outerHeight()) / 2) + $(window).scrollTop()) + "px")
                .css("left", Math.max(0, (($(window).width() - this.outerWidth()) / 2) + $(window).scrollLeft()) + "px");
            return this;
        },
        horizontalCenter: function () {
            this.css("position", "fixed")
                .css('margin-left', '0px')
                .css("left", Math.max(0, (($(window).width() - this.outerWidth()) / 2) + $(window).scrollLeft()) + "px");
            return this;
        },
        isValidEndDate: function (startDatePickerAttr) {
            var input = $(this);
            if (!startDatePickerAttr) {
                startDatePickerAttr = 'startDatePicker';
            }
            var kendoDatePickerAttr = 'kendoDatePicker';
            if (typeof input.attr(startDatePickerAttr) !== 'undefined') {
                var startPicker = $('#' + input.attr(startDatePickerAttr)).data(kendoDatePickerAttr);
                var endPicker = input.data(kendoDatePickerAttr);
                var endDate = endPicker.value();
                var startDate = startPicker.value();
                var number = null;
                var isValidDate = kendo.parseDate(startDate) !== null && kendo.parseDate(endDate) !== null;
                if (!startDate) {
                    number = Date.parse($(startPicker.element).val());
                    if (!isNaN(number)) {
                        startDate = new Date(number);
                        startPicker._old = startPicker._value = startDate;
                    }
                }
                if (!endDate) {
                    number = Date.parse($(endPicker.element).val());
                    if (!isNaN(number)) {
                        endDate = new Date(number);
                        endPicker._old = endPicker._value = endDate;
                    }
                }
                if (isValidDate && startDate && endDate) {
                    return startDate <= endDate;
                }
                return true;
            }
            return true;
        },
        overlay: function (image, checked) {
            var element = this[0],
                top = $(this).position().top,
                left = $(this).position().left;
            element.overlays = element.overlays || [];
            image
                //.css('position', top == 0 && left == 0 ? 'static' : 'absolute')
                .css('z-index', $(this).css('z-index') + 1)
                //.css('top', top)
                //.css('left', left) 
                .css('display', 'none')
                .appendTo($(this).parent());
            element.overlays.push(image);
            if (checked) {
                image.checked = checked;
            } else {
                image.checked = null;
            }
            return this;
        },
        handleOverlayClick: function () {
            var element = this[0],
                $element = $(element);
            if (!$element.parent().hasClass("redacted") && typeof $element.attr('disabled') == 'undefined') {
                $element.unbind('keyup').bind('keyup', function (e) {
                    if (e.keyCode == 32) { //SPACE
                        $element.siblings('.img-checkbox:visible').click();
                        $(element).click();
                    }
                });
            }

            $.each(element.overlays, function (i, image) {
                if (typeof $element.attr('disabled') == 'undefined' && typeof $element.attr('readonly') == 'undefined') {

                    if (!image.parent().hasClass("redacted")) { //if redacted not allow click

                        image.unbind('click').click(function (e) {
                            if (typeof $element.attr('disabled') !== 'undefined' || typeof $element.attr('readonly') !== 'undefined') {
                                return this;
                            }
                            var events = $._data(element, 'events'),
                                clickHandlers = events ? $._data(element, 'events').click : null;
                            if (clickHandlers && clickHandlers.length > 0) {
                                $element.attr('checked', image.checked);
                            }
                            $(element).click();
                            if ((image.checked && !$(element).attr('checked')) || (!image.checked && $element.attr('checked'))) {
                                $element.attr('checked', image.checked);
                            }
                            if (image.checked) {
                                var display = element.overlays[1].css('display');
                                element.overlays[0].css('display', display);
                                element.overlays[1].hide();
                            } else {
                                var display = element.overlays[0].css('display');
                                element.overlays[0].hide();
                                element.overlays[1].css('display', display);
                            }
                        });
                    } else { //process for Redacted check box
                        $element.bind("valueChanged", function (e) { //this event use only for Redacted Updatable checkbox
                            if ($element.attr("redacted") === undefined) return;
                            if ($element.is(":checked")) {
                                element.overlays[0].css('display', 'block');
                                element.overlays[1].hide();
                            } else {
                                element.overlays[0].hide();
                                element.overlays[1].css('display', 'block');
                            }
                            $element.change();
                        });
                    }
                } else {
                    element.overlays[0].unbind('click');
                    element.overlays[1].unbind('click');
                }
            });
            return this;
        },
        imageCheckBox: function () {
            var uncheckAll = function () {

            };
            this.each(function (index, element) {
                if ($(element).is(':checkbox')) {
                    if (!element.customized) {
                        var rootUrl = Helpers.ajaxHelper.getRootUrl(),
                            imagePath = rootUrl + 'Content/Images/',
                            checkedImage = $('<span id="tick_on">&nbsp;</span>').addClass('img-checkbox').addClass('tick_on'),
                            uncheckedImage = $('<span id="tick_off">&nbsp;</span>').addClass('img-checkbox').addClass('tick_off');
                        $(element).overlay(checkedImage).overlay(uncheckedImage, true).addClass('opacity0');
                        element.customized = true;
                    }
                    if ($(element).is(':checked')) {
                        element.overlays[0].show();
                        element.overlays[1].hide();
                    } else {
                        element.overlays[0].hide();
                        element.overlays[1].show();
                    }
                    $(element).handleOverlayClick();
                }
            });
            return this;
        },
        customizeUI: function () {
            return Helpers.customizeUI(this);
        },
        customizeScrollBars: function () {
            return Helpers.customizeScrollBars(this);
        },
        customizeCheckBoxes: function () {
            return Helpers.customizeCheckBoxes(this);
        },
        popupBoxExtension: function (opts) {
            var def = {
                baseUrl: '',
                overlay: 'overlay',
                close: '.close',
                help: '.helplink',
                cssClass: 'popup-box',
                loading: Helpers.resolveUrl('Images/img/ajax-loader.gif'),
                closeCallback: function () { },
                closedCallback: function () { },
                isAjax: true,
                isAnimated: true,
                isDeferred: false,
                data: null,
                isDisableCloseButton: false,
                isCheckDitry: false,
                workAround: true,
                // Xuan edited
                //top: '50%',
                //left: '50%',
                editable: false,
                type: 'GET',
                element: null,
                checkingDirtyMessage: 'Closing this will discard all data – do you wish to continue?',
            },
                originalModel = {},
                confirmPopup = null,
                o = $.extend(def, opts),
                _this = this,
                overlay = $('<div id="' + o.overlay + '"></div>'),
                loading = $('<img src="' + o.loading + '" id="loader" style="display:none"></div>'),
                outterpo = o.cssClass,
                innerpo = 'popup-box-inner',
                outterWrap = this.outterWrap = this.outterWrap || $('<div class="' + outterpo + ' popup"></div>'),
                inner_wrap = this.inner_wrap = this.inner_wrap || $('<div class="' + innerpo + '"></div>'),
                url = o.baseUrl;

            this.init = function () {
                if (typeof Civica !== 'undefined' && typeof Civica.RegionManager !== 'undefined') {
                    Civica.RegionManager.unbindKeyUp();
                }
                o.element = outterWrap;
                originalModel = {};
                if (Helpers.isIphone()) {
                    o.left = '0';
                }
                if (o.isDeferred === false) {
                    _this.open(url);
                } else {
                    _this.deferredOpen(url);
                }
                if (typeof Civica !== 'undefined') {
                    Civica.currentPopup = _this;
                }
                return _this;
            };

            this.isEditable = function () {
                return $('.button-funcs:visible:contains("Save")', inner_wrap).length > 0 || o.editable;
            },

            this.invokeSave = function () {
                var $buttonFunc = $('.button-funcs:visible', inner_wrap),
                    $saveBtn = $('a:contains("Save")', $buttonFunc);

                // For case pop up contain two button Save , Save and Add
                if ($saveBtn.length > 1) {
                    $saveBtn.each(function () {
                        var invokeSave = $(this).hasClass('saveandaddgroup');
                        if (!invokeSave) {
                            $(this).click();
                        }
                    });
                } else if ($saveBtn.length === 1) {// For case normal
                    $('a:contains("Save")', $buttonFunc).click();
                } else { //click confirm for saving
                    $('button:contains("Confirm"):visible', inner_wrap).click();
                }
                //$('.button-funcs:visible:contains("Save")', inner_wrap).click();
            },

            this.event = function () {

            };

            this.checkIsDirty = function () {

                if (typeof o.checkedIsDirty === 'function') {
                    return o.checkedIsDirty();
                }
                var $form = $('form:first', inner_wrap),
                    dirtyModel = $.trim($form.serialize());
                //work around for kendoDropdownlist bug
                if (o.workAround === true) {
                    // return !(originalModel.replaceAll("=0&", "=&") === dirtyModel.replaceAll("=0&", "=&"));
                    return !(Helpers.replaceAll(originalModel, "=0&", "=&") === Helpers.replaceAll(dirtyModel, "=0&", "=&"));
                }
                return !(originalModel === dirtyModel);
            },

            this.updateOriginalModel = function () {
                var $form = $('form:first', inner_wrap);
                originalModel = $.trim($form.serialize());

            },

            this.open = function (url) {
                var _heightpo, _widthpo, mrt, mrl,
                    attrs = this.getAttributes();

                $.each(attrs, function (i, data) {
                    if (i == 'href' || i == 'data-rel') {
                        if (data != '') {
                            o.baseUrl = data;
                        }
                    }
                });

                loading.appendTo('body');
                if ($('#overlay:visible').length === 0) {
                    overlay.appendTo('body');
                } else {
                    overlay = $('#overlay:visible');
                }
                outterWrap.append(inner_wrap).appendTo('body');

                var pobox = this.pobox = outterWrap,
                    poinbox = this.poinbox = inner_wrap;
                this.overlay = overlay;

                if (o.isAjax === true) {
                    Helpers.ajaxHelper.ajax({
                        type: o.type,
                        url: url,
                        data: o.data,
                        cache: false,
                        success: function (result) {
                            poinbox.empty().append(result);
                            loading.detach();
                            // Xuan
                            //$('.navbar-inverse').css("pointer-events", "none");
                            _heightpo = pobox.height(), _widthpo = pobox.width(), mrt = parseInt(_heightpo / 2), mrl = parseInt(_widthpo / 2);
                            if (Helpers.isIphone()) {
                                mrl = 0;
                                mrt = 0;
                            }
                            pobox.css({
                                top: o.top,
                                left: o.left
                                //'margin-left': -mrl + 'px',
                                //'margin-top': -mrt + 'px'
                            });

                            var scanDataGrid = setInterval(function () {
                                if (pobox.find('table').length > 0) {
                                    var widthReal = pobox.width();
                                    if (widthReal > 0) {
                                        if (widthReal > 1000) {
                                            //pobox.width(1000);
                                            pobox.css({
                                                //'margin-left': '-500px'
                                            }).show();
                                        } else {
                                            pobox.width(widthReal);
                                            mrl = parseInt(widthReal / 2);
                                            if (Helpers.isIphone()) {
                                                mrl = 0;
                                                mrt = 0;
                                            }
                                            pobox.css({
                                                //'margin-left': -mrl + 'px'
                                            }).show();
                                        }
                                        clearInterval(scanDataGrid);
                                        Helpers.firstFocus(poinbox, true);
                                    }
                                } else {
                                    mrl = parseInt(_widthpo / 2);
                                    if (Helpers.isIphone()) {
                                        mrl = 0;
                                    }
                                    pobox.css({
                                        //'margin-left': -mrl + 'px'
                                    }).show();
                                    clearInterval(scanDataGrid);
                                    Helpers.firstFocus(poinbox, true);
                                }
                            }, 200);


                            if (typeof o.callback === 'function') {
                                if (o.callbackOptions) {
                                    o.callback.apply({
                                        pobox: pobox,
                                        overlay: overlay
                                    }, [o.callbackOptions]);
                                } else {
                                    o.callback();
                                }
                            }
                            _this.updateOriginalModel();
                            _this.close();
                        }
                    });
                } else {
                    setTimeout(function () {
                        loading.detach();
                    }, 1000);
                    poinbox.empty().append(o.data);
                    _heightpo = pobox.height(), _widthpo = pobox.width(), mrt = parseInt(_heightpo / 2), mrl = parseInt(_widthpo / 2);
                    if (Helpers.isIphone()) {
                        mrl = 0;
                    }
                    pobox.css({
                        top: o.top,
                        left: o.left,
                        //'margin-left': -mrl + 'px',
                        'margin-top': -mrt + 'px'
                    }).show();
                    if (typeof o.callback === 'function') {
                        if (o.callbackOptions) {
                            o.callback.apply({
                                pobox: pobox,
                                overlay: overlay
                            }, [o.callbackOptions]);
                        } else {
                            o.callback();
                        }
                    }
                    _this.close();
                    _this.updateOriginalModel();
                    Helpers.firstFocus(poinbox);
                }
                overlay.show();
            };

            this.deferredOpen = function (url) {
                var _heightpo, _widthpo, mrt, mrl,
                    attrs = this.getAttributes();

                $.each(attrs, function (i, data) {
                    if (i == 'href' || i == 'data-rel') {
                        if (data != '') {
                            o.baseUrl = data;
                        }
                    }
                });
                if ($('#overlay:visible').length === 0) {
                    overlay.appendTo('body');
                } else {
                    overlay = $('#overlay:visible');
                }
                outterWrap.append(inner_wrap).appendTo('body');
                var pobox = this.pobox = outterWrap,
                    poinbox = this.poinbox = inner_wrap;
                this.overlay = overlay;

                if (o.isAjax === true) {
                    Helpers.ajaxHelper.ajax({
                        type: "GET",
                        url: url,
                        cache: false,
                        success: function (result) {
                            if (typeof result === 'undefined' || result === null || result === '' || result.nodeName === '#document') {
                                //Do nothing
                                loading.detach();
                                return;
                            } else {
                                overlay.appendTo('body').show();
                                $(outterWrap).html(inner_wrap).appendTo('body');
                                pobox = $('.' + outterpo), poinbox = $('.' + innerpo);
                                setTimeout(function () {
                                    loading.detach();
                                }, 1000);
                                poinbox.empty().append(result);
                                _heightpo = pobox.height(), _widthpo = pobox.width(), mrt = parseInt(_heightpo / 2), mrl = parseInt(_widthpo / 2);
                                if (Helpers.isIphone()) {
                                    mrl = 0;
                                    mrt = 0;
                                }
                                pobox.css({
                                    top: o.top,
                                    left: o.left,
                                    //'margin-left': -mrl + 'px',
                                    'margin-top': -mrt + 'px'
                                }).show();
                                if (typeof o.callback === 'function') {
                                    if (o.callbackOptions) {
                                        o.callback.apply({
                                            pobox: pobox,
                                            overlay: overlay
                                        }, [o.callbackOptions]);
                                    } else {
                                        o.callback();
                                    }
                                }
                                Helpers.firstFocus(poinbox, true);
                                _this.updateOriginalModel();
                                _this.close();
                            }
                        }
                    });
                } else {
                    $(outterWrap).html(inner_wrap).appendTo('body');
                    pobox = $('.' + outterpo), poinbox = $('.' + innerpo);
                    setTimeout(function () {
                        loading.detach();
                    }, 1000);
                    poinbox.empty().append(o.data);
                    _heightpo = pobox.height(), _widthpo = pobox.width(), mrt = parseInt(_heightpo / 2), mrl = parseInt(_widthpo / 2);
                    if (Helpers.isIphone()) {
                        mrl = 0;
                        mrt = 0;
                    }
                    pobox.css({
                        top: o.top,
                        left: o.left,
                        //'margin-left': -mrl + 'px',
                        'margin-top': -mrt + 'px'
                    }).show();
                    if (typeof o.callback === 'function') {
                        if (o.callbackOptions) {
                            o.callback.apply({
                                pobox: pobox,
                                overlay: overlay
                            }, [o.callbackOptions]);
                        } else {
                            o.callback();
                        }
                    }
                    Helpers.firstFocus(poinbox, true);
                    _this.updateOriginalModel();
                    _this.close();
                }
            };

            this.hide = function () {
                outterWrap.hide();
            };
            this.show = function () {
                outterWrap.show();
            };
            this.close = function () {
                var close = this.pobox.find(o.close),
                     that = this,
                     confirmTemplate = '<div id="" class="popup-box-head accent-colour-background clearfix">' + '<div id="dirtyPopupContent" class="box-title normal-text left"> Confirm</div>' + '<div class="button-funcs right">' + '<a id="pop-close" class="close" title="Close" href="#">Close</a>' + '</div>' + '</div>' + '<div class="popup-box-content">' + o.checkingDirtyMessage + '</div>' + '<div class="YNButton clearfix" id="dirtyPopupButton">' + '<button id="btnYes" class="active-background active-text btn" title="Yes" type="button">Yes</button>' + '<button id="btnNo" class="active-background active-text btn" title="NO" type="button">No</button>' + '</div>';
                if (o.isDisableCloseButton === false) {
                    close.on('click', function (e) {
                        var $this = $(this);
                        e.preventDefault();
                        o.closeCallback();
                        if (_this.isEditable() === false || _this.checkIsDirty() === false) {
                            if (typeof Civica !== 'undefined' && typeof Civica.RegionManager !== 'undefined') {
                                Civica.RegionManager.bindKeyUp();
                            }
                            that.pobox.remove();
                            that.overlay.detach();
                            while ($('#overlay').length > 0) {
                                $('#overlay').remove();
                            }
                            o.closedCallback();

                        } else {
                            that.hide();
                            var confirmPopup = $('</a>').popupBoxExtension({
                                isAjax: false,
                                data: confirmTemplate,
                                cssClass: 'dirty-popup-box',
                                isDisableCloseButton: true,

                                callback: function () {
                                    var popup = this;

                                    $('#dirtyPopupButton #btnYes').focus().unbind('click').click(function () {
                                        confirmPopup.pobox.remove();
                                        that.show();

                                        that.pobox.remove();
                                        that.overlay.detach();
                                        while ($('#overlay').length > 0) {
                                            $('#overlay').remove();
                                        }
                                        o.closedCallback();

                                        // if(o.isWizard === true){

                                        // } else {
                                        //     that.invokeSave();
                                        // }
                                    }).focus();

                                    $('.dirty-popup-box .close:visible').off('click').on('click', function () {
                                        confirmPopup.pobox.remove();
                                        that.show();
                                    });

                                    $('#dirtyPopupButton #btnNo').off('click').on('click', function () {
                                        confirmPopup.pobox.remove();
                                        that.show();
                                    });
                                    $('#dirtyPopupButton #btnYes').focus();
                                },
                                callbackOptions: {}
                            });
                        }
                    });
                }
                this.pobox.keyup(function (e) {

                    if (e.keyCode == 27) {

                        if (o.escapeKeyDown && typeof (o.escapeKeyDown) == "function") {
                            o.escapeKeyDown.apply(that, [e]);
                        }
                        if (close.length) {
                            close.click();
                        } else {
                            that.pobox.remove();
                            that.overlay.detach();
                        }
                        e.stopPropagation(); //stop bubling event, missing this dirty popup will keep showing.
                        if (typeof Civica !== 'undefined' && typeof Civica.RegionManager !== 'undefined') {
                            Civica.RegionManager.bindKeyUp();
                        }
                        e.preventDefault();
                    } else if (e.keyCode == 13) {
                        if (o.enterKeyDown && typeof (o.enterKeyDown) == "function") {
                            o.enterKeyDown.apply(that, [e]);
                        }

                        e.preventDefault();
                    } else if (e.keyCode == 112) {
                        e.preventDefault();
                        var help = $(this).find(o.help);
                        if (typeof help !== 'undefined') help[0].click();
                    }
                });
            };
            if (this.init) {
                this.init();
            }

            return this;
        }
    });

    $.extend($.expr[":"], {
        containsCaseInsensitive: $.expr.createPseudo(function (arg) {
            return function (elem) {
                return $(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
            };
        })
    });

    LongTextHelper = {
        wrapTrunk8: function (strClass) {
            var defaultClass = ".trunk8";
            if (strClass == undefined) {
                strClass = defaultClass;
            } else {
                if (strClass.indexOf(defaultClass) == -1) strClass += "," + defaultClass;
            }
            $(strClass).each(function () {
                if ($(this).attr("wrapped") != "true") {
                    $(this).trunk8();
                    $(this).attr("wrapped", "true");
                }
            });
        }
    };
    $.fn.watch = function (property, callback) {
        return $(this).each(function () {
            var self = this;
            var isStyle = property == "style";
            var old_property_val = this[property];
            if (isStyle) {
                old_property_val = this[property].cssText;
            }

            var timer;

            function watch() {
                if ($(self).data(property + '-watch-abort') == true) {
                    timer = clearInterval(timer);
                    $(self).data(property + '-watch-abort', null);
                    return;
                }
                if (isStyle) {
                    if (self[property].cssText != old_property_val) {
                        old_property_val = self[property].cssText;
                        callback.call(self);
                    }
                } else if (self[property] != old_property_val) {
                    old_property_val = self[property];
                    callback.call(self);
                }
            }
            timer = setInterval(watch, 10);
        });
    };

    $.fn.unwatch = function (property) {
        return $(this).each(function () {
            $(this).data(property + '-watch-abort', true);
        });
    };


})(jQuery);

// Add maths extension to deal with floating point maths
var _getCorrectionFactor = (function () {
    function _shift(x) {
        var parts = x.toString().split('.');
        return (parts.length < 2) ? 1 : Math.pow(10, parts[1].length);
    }
    return function () {
        return Array.prototype.reduce.call(arguments, function (prev, next) { return prev === undefined || next === undefined ? undefined : Math.max(prev, _shift(next)); }, -Infinity);
    };
})();

Math.Add = function () {
    var f = _getCorrectionFactor.apply(null, arguments); if (f === undefined) return undefined;
    function cb(x, y, i, o) { return x + Math.round(f * y); }
    return Array.prototype.reduce.call(arguments, cb, 0) / f;
};

Math.Subtract = function (l, r) { var f = _getCorrectionFactor(l, r); return (Math.round(l * f) - Math.round(r * f)) / f; };

Math.Multiply = function () {
    var f = _getCorrectionFactor.apply(null, arguments);
    function cb(x, y, i, o) { return Math.round(x * f) * Math.round(y * f) / Math.round(f * f); }
    return Array.prototype.reduce.call(arguments, cb, 1);
};

Math.Divide = function (l, r) { var f = _getCorrectionFactor(l, r); return Math.round(l * f) / Math.round(r * f); };

Math.Round = function (value, numberOfPlaces) {
    var newValue = value * Math.pow(10, numberOfPlaces);
    newValue = Math.round(newValue);
    return parseFloat((newValue / Math.pow(10, numberOfPlaces)).toFixed(numberOfPlaces));
}