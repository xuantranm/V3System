;
(function ($, tmx, undefined) {
    "use strict";
    var Class = kendo.Class,
        DoNothing = function() {};

    tmx.RegionView = Class.extend({
        isDataRefreshMonitored: false,
        dataModelRefresh: '',
        dataRefreshFields: '',
        masterid: 0,
        isDirty: false,
        isContainDirtyView: false,
        isNeedCheckDirty: false,
        isDocked: false,
        $wndHandler: null,
        $linkToOpen: {},
        CurrentWizard: null,
        isClose: false,
        currentClosedLozengeName: '',
        isYesConfirm: false,
        isSaveConfirm: false,

        options: {
            formOnly: true,
            actionToOpen: 'click',
            isUsingOnEventBinding: false,
            limit: 7,
            modelId: 0,
            controlClass: '',
            parentUID: null,
            forceReload: false,
            maximumOfLozengeTile: 15,
            checkDataOutOfDate: $.noob,
            changeSubViewCallback: $.noob,
            processTileCount: $.noob,
            doNotUseDefaultCheckIsDirty: false,
            jsonurl: "",
            entityId: 0,
            entityType: '',
            relatedEntities: '',
            isDummyObject: false,
            isRentRegion: false,
            isConfigurationScreen: false,
            RefreshData: null,
            validationOptions: null,
            controlClassSubViewWillOpenWhenInit: null,
            onClosing: null
        },
        url: "",
        jsonurl: "",
        controlClass: '',
        $container: null,
        $lozenge: null,
        uid: null,
        $lozengeBar: null,
        $lozengeHandler: null,
        isHomeScreen: false,
        processTilesActiveCssClass: 'process-tile-active',
        processTilesInActiveCssClass: 'accent-colour-background',
        itemId: 0,
        checkIsDirtyUrl: '',
        label: '',
        isTab: false,
        siblingRegionViews: [],
        parent: null,
        prepareToOpenSubViews: [],
        children: [],
        isSubView: false,
        isSubRootView: false,
        $processTiles: null,
        elementSelector: '',
        $elementContainInformation: [],
        currentChild: null,
        originalModel: null,
        $form: null,
        $gridForms: null,
        $forms: null,
        actionAfterCheckIsDirty: $.noob,
        isOnCheckIsDirty: false,
        //form auto refresh
        entityId: 0,
        entityType: "",
        isObsolete: false,
        isSaving: false,
        isNeedRefreshCounter: true,
        relatedEntities: "",
        justMadeChange: false,
        forceReloadForNextOpen: false,
        /**
         * Get current wizard of regionview
         * @public
         */
        getCurrentWizard: function () {
            return this.CurrentWizard; //object will be injected when wizard load
        },
        /**
         * set dirty status for a counter
         * @private
         */
        markCounterAsDirty: function () {
            var that = this;
            that.isNeedRefreshCounter = true;
        },

        /**
         * set up-to-date status for a counter
         * @private
         */
        markCounterAsUpToDate: function() {
            var that = this;
            that.isNeedRefreshCounter = false;
        },

        /**
         * set Obsolete status for a form
         * @private
         */
        markAsObsolete: function() {
            var that = this;
            that.isObsolete = true;
        },

        /**
         * set up-to-date status for a form
         * @private
         */
        markAsUpToDate: function() {
            var that = this;
            that.isObsolete = false;
        },


        /**
         * set just-changed status for a form
         * @private
         */
        markAsJustMadeChange: function() {
            var that = this;
            that.justMadeChange = true;
        },

        /**
         * set change-long-time-agoe status for a form
         * @private
         */
        markAsChangeLongTimeAgo: function() {
            var that = this;
            that.justMadeChange = false;
        },

        /**
         * check whether an entity contains any related entities
         * @private
         * @param {string} strEntities - The entity name.
         */
        containsRelatedEntities: function(strEntities) {
            var that = this;
            if (strEntities == "*") return true;
            if (that.relatedEntities == "") return false;
            var entities = strEntities.split(',');
            var arrRelatedEntities = that.relatedEntities.split(',');
            var found = false;
            for (var i = 0; i <= entities.length - 1; i++) {
                for (var j = 0; j <= arrRelatedEntities.length - 1; j++) {
                    if (arrRelatedEntities[j] == entities[i]) {
                        found = true;
                        break;
                    }
                }
            }
            return found;
        },


        /**
         * init a regionview
         * @constructor
         * @param {jquery object} $element - When you click on the $element, the region view will be opened.
         * @param {Array} opts - The options of the regionview.
         */
        init: function($element, opts) {
            var that = this;
            that.options = $.extend({}, that.options, opts);
            that.prepareToOpenSubViews = [];
            that.children = [];
            that.$lozenge = null;
            that.originalModel = null;
            if (that.options.isDummyObject === true) {
                return false;
            }

            if (Helpers.isNull($element) === true) {
                return that.open(opts);
            }
            
            that.$linkToOpen = $element;
            that.elementSelector = $element.selector;
            that.$lozengeBar = $('footer .footer-wrapper');
            that.isHomeScreen = that.$linkToOpen.hasClass('homepage-tile-home');
            that.actionAfterCheckIsDirty = null;

            that.onActionToOpen();
            if (Helpers.isNull(that.options.parentUID) === false && (Helpers.isNull($element) === true || $element.length > 0)) {
                //that.$container = $('.' + that.options.parentUID);
                that.parent = Civica.RegionManager.get(that.options.parentUID);
                if (that.options.isRentRegion) //in case parent creat first so the options cannot be extend, help when lozenges open from Quick menu
                    that.parent.options.isRentRegion = that.options.isRentRegion;
                  that.parent.prepareToOpenSubViews.push(that);
            }
            return that;
        },

        /**
         * open a regionview
         * @api
         * @param {Array} opts - The options of the regionview.
         */
        open: function(opts) {
            var that = this;
            that.options = $.extend({}, that.options, opts);
            that.$linkToOpen = null;
            that.elementSelector = null;
            that.$lozengeBar = $('footer .footer-wrapper');
            that.isHomeScreen = false;
            //Init new Windows
            that.url = that.options.url;
            that.jsonurl = that.options.jsonurl.replace('[url]', that.url);
            that.dataRefreshFields = that.options.dataRefreshFields;
            that.isSubView = that.options.isSubView;
            that.isSubRootView = that.options.isSubRootView;
            that.isMandatoryView = false;

            //auto refresh
            that.entityId = that.options.entityId;
            that.entityType = that.options.entityType;
            that.relatedEntities = that.options.relatedEntities;


            if (typeof that.isSubRootView === 'undefined') {
                that.isSubRootView = false;
            }
            if (typeof that.isSubView === 'undefined') {
                that.isSubView = false;
            }
            that.uid = Helpers.randomString(8);

            //preInit
            if (that.preInit() === true) {
                if (that.isSubView == true) {
                    that.createSubView();
                } else {
                    that.create(undefined, opts);
                }
            }

            return that;
        },

        /**
         * create a regionview
         * @api
         * @param {bool} forceLoad - checking whether the regionview will be reload.
         * IF (the region view was created AND forceLoad is FALSE)
         *      show the region view
         * ELSE
         *      create the region view
         */
        create: function(forceLoad) {
            var that = this,
                numberOfRegionView = Civica.RegionManager.RegionViews.length;

            if (that.preChange() === false) {
                return false;
            }
            that.$container = $('.panels-inner');
            if (that.isHomeScreen === true) {
                Civica.RegionManager.showHomePage();
                return true;
            }
            that.controlClass = that.options.controlClass;

            if (Civica.RegionManager.isExistsByControlClassAndModelId(that.options.controlClass, that.options.modelId) !== true || that.invokeCheckDataOutOfDate() === true) {

                //create

                //work around for ipad
                if (numberOfRegionView > 3 && Helpers.isIpadPortrait() && Modernizr.touch) {
                    $('footer').css('overflow-y', 'auto');
                    $('.footer-wrapper').css({
                        'float': 'left',
                        'width': '1100px'
                    });
                }

                if (numberOfRegionView < that.options.limit) {
                    //hide all pages
                    $('.page', that.$container).hide();
                    that.uid = Helpers.randomString(8);
                    that.$container.append($('<div></div>').addClass(that.controlClass).addClass(that.uid).addClass('page').addClass(that.options.controlClass + '-' + that.options.modelId));
                    that.loadContent();
                    that.createLozenge();
                    that.children = [];
                    Civica.RegionManager.RegionViews.push(that);
                    Civica.RegionManager.CurrentRegionView = that;
                } else {
                    that.openLimitMessagePopup();
                    return false;
                }
            } else { //only show
                //that = Civica.RegionManager.getLastView();

                that = Civica.RegionManager.getByControlClassAndModelId(that.options.controlClass, that.options.modelId);

                that.show();
                Civica.RegionManager.CurrentRegionView = that;
                if (forceLoad === true) { //work around for NO button of dirty checking form
                    that.loadContent();
                } else {
                    for (var i = 0; i < that.prepareToOpenSubViews.length; i++) {
                        that.prepareToOpenSubViews[i].invokeProcessTileCounter();
                    }
                }
            }
            return true;
        },

        /**
         * checking whether the regionview is save-able
         * @private
         */
        saveable: function() {
            var that = this;
            var uidParent = Civica.RegionManager.CurrentRegionView.uid;
            var isSaveable = $('#isSaveAble', '.' + that.uid).val();

            if (isSaveable == 'False') {
                that.isSaveAble = false;
                $(".header-save-btn", "." + uidParent).hide();
            } else {
                that.isSaveAble = true;
                $(".header-save-btn", "." + uidParent).show();
            }
        },

        /**
         * create a sub regionview
         * @api
         * IF (the sub region view was created)
         *      show the sub region view
         * ELSE
         *      create the sub region view
         */
        createSubView: function() {
            var that = this,
                $wnd;
            if (that.preChange() === false) {
                return;
            }
            if (typeof that.options.parentUID !== 'undefined') {
                that.$container = $('.sub-region-view', '.' + that.options.parentUID);
                that.parent = Civica.RegionManager.get(that.options.parentUID);
            }

            that.controlClass = that.options.controlClass;
            $wnd = $('.' + that.controlClass, that.$container);

            if (($wnd.length === 0 && that.isSubRootView !== true) || that.invokeCheckDataOutOfDate() === true) {
                //create new window (＾▽＾)
                that.uid = Helpers.randomString(8);
                var $div = $('<div></div>').addClass(that.controlClass).addClass(that.uid).addClass('sub-page').addClass('active');
                that.$container.append($div);
                that.parent.children.push(that);

                that.loadContent(true); //load Synchronous to make sure content loaded before hide div: 11728
                $div.hide();
                that.showSubView();
            } else { //only show
                // Work around for NOT button of dirty checking popup
                if (that.parent.forceReloadForNextOpen === true) {
                    that.parent.loadContent();
                    that.parent.forceReloadForNextOpen = false;
                } else {
                    if (that.options.forceReload === true || that.forceReloadForNextOpen) {
                        that.loadContent();
                        that.forceReloadForNextOpen = false;
                    }
                }
                if (that.isSubRootView === true) {
                    that.uid = that.options.parentUID;
                }
                that.showSubView();
            }
            return;
        },

        /**
         * dock a regionview
         * @api
         */
        dock: function() {
            var that = this;
            that.isDocked = true;
            //that.hide();
            that.SwapLozenge(that, true);
            Civica.RegionManager.showLastView();
        },

        /**
         * undock a regionview
         * @api
         */
        unDock: function() {
            var that = this;
            that.isDocked = false;
            //that.show();
            that.SwapLozenge(that);
            Civica.RegionManager.showLastView();
        },

        /**
         * create a Lozenge
         * @api
         */
        createLozenge: function() {
            var that = this,
                label = that.options.title,
                tooltip = that.options.tooltip,
                uidCssClass = '.' + that.uid,
                html;

            if (Helpers.isNull(label) && !Helpers.isNull(that.$linkToOpen)) {
                label = that.$linkToOpen.attr('title');
                if (Helpers.isNullOrEmpty(label) === true) {
                    label = that.$linkToOpen.text();
                }
            }

            if (Helpers.isNull(tooltip) && !Helpers.isNull(that.$linkToOpen)) {
                that.options.tooltip = tooltip = that.$linkToOpen.data('tooltip');
                if (Helpers.isNullOrEmpty(tooltip) === true) {
                    tooltip = that.$linkToOpen.text();
                }
            }
            label = $.trim(label);
            tooltip = $.trim(tooltip);
            if (label.length > that.options.maximumOfLozengeTile) {
                label = label.slice(0, that.options.maximumOfLozengeTile) + '...';
            }
            html = '<div title="' + tooltip + '" class="labelPV active"><span class="handler">' + label + '</span><a class="close" href="#">x</a></div>';

            that.$lozenge = $(html);
            $('.labelPV', that.$lozengeBar).removeClass('active');
            that.$lozengeBar.append(that.$lozenge);
            that.$lozenge.unbind('click').click(function() {
                if (that.$lozenge.hasClass('active')) {
                    //that.hide();
                    that.dock();
                } else {
                    //that.show();
                    that.unDock();
                }
            });

            var $xButton = $('.close', that.$lozenge);
            $xButton.unbind('click').bind('click', function(e) {
                e.preventDefault();
                e.stopPropagation(); //stop bubling event, missing this dirty popup will keep showing.
                //Civica.RegionManager.CurrentRegionView = that;
                Civica.RegionManager.CurrentRegionView = that;
                Civica.RegionManager.IsInLogoutMode = false;
                that.close();
            });
        },


        /**
         * set a tooltips for a lozenge
         * @api
         */
        setToolTipForLozenge: function() {
            var that = this,
                tooltip,
                uidCssClass = '.' + Civica.RegionManager.CurrentRegionView.uid,
                $activeTile = $('.process-tile-active:visible .process-tile-inner, .process-tile-active:visible .process-tile-mid span:eq(1)', uidCssClass),
                $lozenge = Helpers.isNull(that.$lozenge) === false ? that.$lozenge : that.parent.$lozenge;

            tooltip = Helpers.isNull(that.$lozenge) === false ? $.trim($('.panel-header-title-bar', that.$wndHandler).text().replace(/(\r\n|\n|\r)/gm, "")) : $.trim($('.panel-header-title-bar', that.parent.$wndHandler).text().replace(/(\r\n|\n|\r)/gm, ""));

            if ($activeTile.length > 0) {
                tooltip = tooltip.replace(' For ', ' for ').replace(" for ", " - " + $.trim($activeTile.text()) + " for ");
            }
            tooltip = tooltip.replace("Record saved successfully", "");
            $lozenge.attr('title', tooltip);
            
            
            // Now setup our Kendo UI tooltip for it
            // Kendo UI tootip display wrong content
            //var re = new RegExp("^.*( for\\s+)(.*)$", "i");
            //$($lozenge).kendoTooltip({
            //    content: tooltip.replace(re, "$2"),
            //    postition: "top"
            //});
        },

        /**
         * init saving event for the region view
         * @private
         */
        beginSaveEvent: function() {
            this.isSaving = true;
        },

        /**
         * end saving event for the region view
         * @private
         */
        endSaveEvent: function() {
            this.isSaving = false;
        },

        /**
         * loading content for the region view
         * @api
         * @param {bool} isSynchronous - checking whether the regionview will be using Synchronous loading.
         */
        loadContent: function(isSynchronous) {
            var that = this;
            that.isSaving = false;
            if (that.options.forceReload === true) {
                that.$wndHandler = $('.' + that.controlClass);
            } else {
                that.$wndHandler = $('.' + that.uid, that.$container);
            }

            var uri = that.url;
            if (typeof that.options.getItemId === 'function') {
                that.itemId = that.options.getItemId();
                uri += that.itemId + '/';
            } else {
                that.itemId = '';
            }

            Helpers.ajaxHelper.getHtml({
                url: uri,
                cache: false,
                async: !isSynchronous,
                success: function(result) {
                    var tooltip;
                    that.$wndHandler.kendoEmpty().html(result);
                    that.$processTiles = $('.process-tile', that.$wndHandler);
                    try {
                        /** we don't make sure the code is invoked is stable
                        *   so we put try-catch at here! */
                        that.prepareToOpenSubViews = [];
                        that.invokeCallback();
                        that.saveable();
                        that.bindingHeaderButtons();
                        that.initSaveEvent();
                        that.scaleHeight();
                        Helpers.customizeScrollbars($('.panel-wrap-scroll', that.$wndHandler));

                    } catch (e) {
                        console.log("load content failed");
                        console.log(e);
                    }
                    
                    that.getForm();
                    if (Helpers.isNull(that.$form) === false && that.$form.length > 0) {
                        that.originalModel = that.$form.serialize();
                    }
                    
                    try {
                    for (var i = 0; i < that.prepareToOpenSubViews.length; i++) {
                        that.prepareToOpenSubViews[i].invokeProcessTileCounter();
                    }
                    } catch (e) {
                        console.log("The exception has occurred during loading content");
                        console.log(e);
                    }
                    

                    that.invokeProcessTileCounter();
                    if (!that.options.formOnly) {
                        that.markAsJustMadeChange();
                    }
                    that.setToolTipForLozenge();

                    that.openMandatorySubViews();
                    that.openFirstSubView();
                    $('#dirtyPopupButton #btnYes').focus();
                    
                    /** init tab-mover*/
                    $('.process-tiles', that.$wndHandler).tabsmover();

                    $('.action-button', that.$wndHandler).tabsmover();

                    if (Helpers.isNull(that.options.controlClassSubViewWillOpenWhenInit) === false) {
                        that.openSubViewWhenInit(that.options.controlClassSubViewWillOpenWhenInit);
                    }
                },
                showMask: true
            });
        },

        /**
         * hide the region view
         * @api
         */
        hide: function() {
            var that = this;
            if (that.$wndHandler !== null) {
                that.$wndHandler.hide();
            } else {
                $('.page', that.$container).hide();
            }
            if (typeof that.$lozengeBar !== 'undefined') {
                that.$lozenge.removeClass('active');
            }
            Civica.RegionManager.CurrentRegionView = null;
            Civica.RegionManager.showHomePage();
        },

        /**
         * The DI event that using on before switch screen
         * @private
         * Obsolete function
         */
        preChange: function() {
            var that = this;
            if (typeof that.options.preChange === 'function') {
                return that.options.preChange();
            } else if (typeof that.options.preChange !== "undefined" && that.options.preChange !== '') {
                return Helpers.executeFunctionByName(that.options.preChange, window); //javascript magic string is here: (^_^;)
            }
            return true;
        },


        /**
         * Obsolete
         * @private
         * Obsolete function
         */
        invokeGetData: function(data) {
            var that = this;

            if (typeof that.options.dataModelRefresh === 'function') {
                that.options.dataModelRefresh(data);
            } else if (typeof that.options.dataModelRefresh !== "undefined" && that.options.dataModelRefresh !== '') {
                Helpers.executeFunctionByName(that.options.dataModelRefresh, window, data); //javascript magic string is here: (^_^;)
            }
        },


        /**
         * Invoke the init or onLoad function when the regionview open
         * @private
         */
        invokeCallback: function() {
            var that = this;

            if (typeof that.options.callback === 'function') {
                that.options.callback(that.uid);
            } else if (typeof that.options.callback !== "undefined" && that.options.callback !== '') {
                Helpers.executeFunctionByName(that.options.callback, window, that.uid); //javascript magic string is here: (^_^;)
            }
        },

        /**
         * Invoke the init or onLoad function when the regionview open
         * @private
         */
        invokeProcessTileCounter: function() {
            var that = this;
            if (typeof that.options.processTileCounter === 'function') {
                that.options.processTileCounter(that.uid);
            } else if (typeof that.options.processTileCounter !== "undefined" && that.options.processTileCounter !== '') {
                Helpers.executeFunctionByName(that.options.processTileCounter, window, that.uid); //javascript magic string is here: (^_^;)
            }
            that.markCounterAsUpToDate();
        },

        /**
         * Invoke the change sub view function when changing the sub region view
         * @private
         */
        invokeChangeSubViewCallback: function() {
            var that = this;
            if (typeof that.options.changeSubViewCallback === 'function') {
                that.options.changeSubViewCallback(that.uid);
            } else if (typeof that.options.changeSubViewCallback !== "undefined" && that.options.changeSubViewCallback !== '') {
                Helpers.executeFunctionByName(that.options.changeSubViewCallback, window, that.uid); //javascript magic string is here: (^_^;)
            }
        },

        /**
         * Hide a sub region view
         * @api
         * Obsolete function
         */
        hideSubView: function() {
            var that = this;
            that.$wndHandler.hide().removeClass('active');
        },

        /**
         * show a sub region view
         * @api
         */
        showSubView: function() {
            var checkBeforeShowSubView = this.options.checkBeforeShowSubView,
                that = this;
            $('.message').empty();

            if (that.isSubRootView === true) {
                that.actionAfterCheckIsDirty = function() {
                    if (Helpers.isNull(that.$linkToOpen) === false) {
                        that.$linkToOpen.removeClass(that.processTilesInActiveCssClass).addClass(that.processTilesActiveCssClass);
                        that.$linkToOpen.siblings().removeClass(that.processTilesActiveCssClass).addClass(that.processTilesInActiveCssClass);
                    }
                    $('.sub-page', that.$container).hide().removeClass('active');
                    $('.sub-root-view', that.$container).show().addClass('active').addClass(that.uid);
                    Helpers.firstFocus($('.sub-root-view', that.$container));
                };
                if ((Helpers.isNull(that.parent.currentChild) === false && that.parent.currentChild.isSaveAble === false) ||
                    (Helpers.isNull(that.parent.currentChild) === true && that.parent.isSaveAble === false)) {
                    that.actionAfterCheckIsDirty();
                } else {
                    Civica.RegionManager.changeSubView(that.parent, that.parent.currentChild, null, that.actionAfterCheckIsDirty);
                }
            } else {
                that.actionAfterCheckIsDirty = function() {
                    if (Helpers.isNull(that.$linkToOpen) === false) {
                        that.$linkToOpen.removeClass(that.processTilesInActiveCssClass).addClass(that.processTilesActiveCssClass);
                        that.$linkToOpen.siblings().removeClass(that.processTilesActiveCssClass).addClass(that.processTilesInActiveCssClass);
                    }
                    $('.sub-page', that.$container).hide().removeClass('active');
                    that.$wndHandler.show().addClass('active');
                    Helpers.firstFocus(that.$wndHandler);
                };
                if ((Helpers.isNull(that.parent.currentChild) === false && that.parent.currentChild.isSaveAble === false) ||
                    (Helpers.isNull(that.parent.currentChild) === true && that.parent.isSaveAble === false)) {
                    that.actionAfterCheckIsDirty();
                } else {
                    Civica.RegionManager.changeSubView(that.parent, that.parent.currentChild, that, that.actionAfterCheckIsDirty);
                }
            }
            //that.invokeProcessTileCounter();
            Civica.RegionManager.CurrentRegionView = that.parent;
            that.setToolTipForLozenge();
            that.initSaveEvent();
            that.parent.scaleHeight();
            that.scaleHeight();
            that.saveable();
            //remove message
            $('.message', that.$wndHandler).empty();
            return true;
        },

        /**
         * show a sub region view
         * @api
         */
        show: function() {
            var that = this,
                subView;
            $('.page', that.$container).hide();
            that.$wndHandler.show();
            that.isDocked = false;
            Civica.RegionManager.CurrentRegionView = that;
            if (typeof that.$lozengeBar !== 'undefined' && that.$lozenge !== null) {
                $('.labelPV', that.$lozengeBar).removeClass('active');
                that.$lozenge.addClass('active');
            }
            Helpers.firstFocus(that.$wndHandler);
            //remove message
            $('.message', that.$wndHandler).empty();

            if (Helpers.isNull(that.children) === false && that.children.length > 0 && Helpers.isNull(that.currentChild) === false) {
                //children
                subView = that.currentChild;
                //that.currentChild.invokeProcessTileCounter();
                that.currentChild.initSaveEvent();
                if (that.checkDataOutOfDate() === true) {
                    that.currentChild.loadContent();
                }
                that.scaleHeight();
                that.currentChild.scaleHeight();
            } else {
                /// that.invokeProcessTileCounter();
                that.initSaveEvent();
                subView = that;
                if (that.checkDataOutOfDate() === true) {
                    that.loadContent();
                }
                that.scaleHeight();
            }

            if (subView.isObsolete) {
                subView.openFormAutoRefreshPopup();
            }
        },

        /**
         * show a sub region view
         * @api
         */
        showLastView: function() {
            var lastview = Civica.RegionManager.getLastView();
            if (lastview == null)
                Civica.RegionManager.showHomePage();
            else
                lastview.show();
        },


        /**
         * binding events for header button - like save - dock
         * @private
         */
        bindingHeaderButtons: function() {
            var that = this,
                $headerCloseButton = $('.header-close-btn', that.$wndHandler),
                $headerDockButton = $('.header-dock-btn', that.$wndHandler);

            $headerCloseButton.unbind('click').bind('click', function(e) {
                e.preventDefault();
                Civica.RegionManager.IsInLogoutMode = false;
                that.close();
                Civica.RegionManager.showLastView();
            });

            $headerDockButton.unbind('click').bind('click', function(e) {
                e.preventDefault();
                //Civica.RegionManager.showHomePage();
                that.dock();

            });
        },

        /**
         * setup something before invoke init events
         * @private
         */
        preInit: function() {
            var that = this;
            if (typeof that.options.preInit === 'function') {
                return that.options.preInit(that.uid);
            } else if (typeof that.options.preInit !== "undefined" && that.options.preInit !== '') {
                return Helpers.executeFunctionByName(that.options.preInit, window, that.uid); //javascript magic string is here: (^_^;)
            }
            return true;
        },

        /**
         * setup something before invoking the init events
         * @private
         */
        initSaveEvent: function() {
            var that = this;
            $('.header-save-btn:visible').unbind('click').click(function(e) {
                e.preventDefault();
                if ($(this).hasClass('disabled')) {
                    return;
                }

                //$(this).addClass('disabled'); Fix save Button didn't disabled after saved (Allocations - Manage Offer)
                if (that.options.isRentRegion) {
                    Civica.RegionManager.CurrentRegionView.saveAllTabs();
                } else {
                    that.invokeSave(e);
                }

                //$(this).removeClass('disabled'); Fix save Button didn't disabled after saved (Allocations - Manage Offer)
                e.stopPropagation();
            });
        },
       
        /**
         * validate the region view
         * @api
         * @param {string} formelement - The jquery selector for the form of the sub/region view.
         * @param {Array} options - The options param.
         * FOREACH subRegionView IN regionViews
         *     IF(subRegionView.isValid() == TRUE)
         *          RETURN FALSE;
         * RETURN TRUE;
         */
        validateForm: function(formelement, options) {
            var that = this;
            var current = Civica.RegionManager.CurrentRegionView;
            var rootUid = "." + current.uid;
            var children = current.children;
            var validator = null;
            var formobject = typeof formelement == "string" ? $(formelement, rootUid) : formelement;
            if (formelement == undefined) {
                formobject = $("form", "." + that.uid);
			}
			var tempOptions = null;
            if (options !== undefined) // specific custome rules will use custome rules      
			    tempOptions = options;
            else { //other wise use config options rules
			    tempOptions = eval(that.options.validationOptions);
			}
            
            if (that.isSaveAble === false) {
                
                return true;
            }

            validator = $(formobject).kendoValidator().data("kendoValidator");
            if (typeof validator == "undefined")
                return true;
            var optionValidator;
            
            if (tempOptions != null)
                optionValidator = $(formobject).kendoValidator(tempOptions).data("kendoValidator");
            var optionResult = true;
            var result = true;
            if (optionValidator != undefined && optionValidator != null) {
                optionResult = optionValidator.validate();
            } else {
                result = validator.validate();
            }
            //var uidClass = "." + that.uid;
            //$("span[name='ValidationErrorMessage']", uidClass).remove();
            
             

            if (!(optionResult && result)) {
				
                //that.addHighlightBar(uidClass);

                var btnSave = $(".header-save-btn", rootUid);
                if (btnSave.text() === 'Saving') {
                    btnSave.text('Save');
                }

                return false;
            } else {
                that.removeHighlightBar();
            }

            return true;
        },


        /**
         * highlight the header bar
         * @api
         * @param {string} uid - The unique id of  the region view.
         */
        addHighlightBar: function(uid) {
			
            var processtiles = $(".process-tile", uid),
                subRegionViews = $(".sub-region-view"),
                that = this;
            processtiles.each(function(index) {
                // for the opened tabs
                var inputs = $(subRegionViews[index]).find("span.field-validation-error").length;
                if (inputs > 0) {
                    $(".process-tile", uid).addClass("validation-failed");
                }
            });
        },

        /**
         * highlight the header bar
         * @api
         * @param {string} uid - The unique id of  the region view.
         */
        removeHighlightBar: function() {
            $(".validation-failed").removeClass("validation-failed");
        },

        /**
         * Save data of all tabs include tabs contain Grids
         * @api
         */
        saveAllTabs: function(isDirtyCheckingSave) {
            var that = this;
            $(".header-save-btn", "." + Civica.RegionManager.CurrentRegionView.uid).text('Saving');
            var isValid = Civica.RegionManager.CurrentRegionView.validateForm();
			
            for (var i = 0, n = Civica.RegionManager.CurrentRegionView.children.length; i < n; i++) {
                var validResult = true;

                if ((Civica.RegionManager.CurrentRegionView.children[i].$form && Civica.RegionManager.CurrentRegionView.children[i].$form.length > 0)) {
                    validResult = Civica.RegionManager.CurrentRegionView.children[i].validateForm();
                } else {
                    validResult = Civica.RegionManager.CurrentRegionView.children[i].validateForm(Civica.RegionManager.CurrentRegionView.children[i].$wndHandler);
                }
                isValid = validResult && isValid;
				
            }
            if (isValid) {
                Civica.RegionManager.CurrentRegionView.resetDirtyChecking(true);
                var saveResult = true;
                saveResult = Civica.RegionManager.CurrentRegionView.invokeSave(isDirtyCheckingSave);
                if (saveResult == false) {
                    return false;
                } else {
                    if (typeof saveResult == "object") {
                        $.when(saveResult.done(function() {
                            //console.log("save done");
                            for (var j = 0, n = Civica.RegionManager.CurrentRegionView.children.length; j < n; j++) {
                                isValid = Civica.RegionManager.CurrentRegionView.children[j].invokeSave(isDirtyCheckingSave) && isValid;
                                //console.log(that.options.save);
                                if (isValid == false) {
                                    //console.log("saveAllTabs failed");
                    return false;
                }
                                    
                            }
                        }));
                    } else {
                for (var j = 0, n = Civica.RegionManager.CurrentRegionView.children.length; j < n; j++) {                
                    isValid = Civica.RegionManager.CurrentRegionView.children[j].invokeSave(isDirtyCheckingSave) && isValid;
                    if (isValid == false)
                        return false;
                }
                    }
                }

            } else {
                Helpers.ajaxHelper.markProcesTilesWhenValidateFailed();
            }
            return isValid;
        },
        invokeDataRefresh: function() {
            var that = this;
            var refreshFunc = that.options.RefreshData;
            if (typeof refreshFunc === 'function') {
                refreshFunc(that.entityId);
            } else if (typeof refreshFunc !== "undefined" && refreshFunc !== '') {
                Helpers.executeFunctionByName(refreshFunc, window, that.entityId); //javascript magic string is here: (^_^;)
            }
        },
        /**
         * Invoke save function for the region view
         * @api
         * @param {bool} e - Check whether is on check is dirty.
         */
        invokeSave: function(e) {
            var that = this,
                saveFunc = that.options.save,
                success = true;

            if (e == true) { //check is dirty function invoke saving function 
                that.isOnCheckIsDirty = true;
            } else {
                that.isOnCheckIsDirty = false;
            }
            //Work around for Repair Task
            if ($('.specific-save', that.$wndHandler).length > 0) {
                if (typeof e === 'undefined' || $(e.target).hasClass('header-save-btn') === false) {
                    $('.specific-save', that.$wndHandler).click();
                    return true;
                }
            }

            if (that.options.isRentRegion) {
                saveFunc = that.options.save;
            } else {
                if (Helpers.isNull(that.children) === false && that.children.length > 0 && Helpers.isNull(that.currentChild) === false) {
                    //is select subview
                    saveFunc = that.currentChild.options.save;
                }
                if (that.isSubRootView === true) {
                    saveFunc = Civica.RegionManager.CurrentRegionView.options.save;
                }
            }

            var uidParent = Civica.RegionManager.CurrentRegionView.uid;

            $('.record-not-saved-message:visible').empty(); //use for MS4
            $('span.message-validation:visible').empty(); // use for MS1,2,3,4+
            if (typeof saveFunc === 'function') {
                success = saveFunc(that.uid, {
                    isDirtyChecking: e
                });
            } else if (typeof saveFunc !== "undefined" && saveFunc !== '') {
                success = Helpers.executeFunctionByName(saveFunc, window, that.uid, {
                    isDirtyChecking: e
                }); //javascript magic string is here: (^_^;)
            }
           
            if (success === true) {
                that.onSavedSuccessfully();
                // remove this to avoid text button is still "Saved" while validation failed from server
                //$(".header-save-btn", "." + uidParent).text('Saved');
            }
            that.isSaving = true;
            return success;
        },

        /**
         * Invoke save function for the region view
         * @api
         * @param {bool} e - Check whether is on check is dirty.
         */
        onSavedSuccessfully: function() {
            var that = this;
            that.invokeProcessTileCounter();
            that.originalModel = that.getForm().serialize();
            that.markAsUpToDate();
            that.markAsJustMadeChange();

            if (that.isSubRootView) {
                if (that.parent) {
                    that.parent.markAsUpToDate();
                    that.parent.markAsJustMadeChange();
                }
            }
        },

        /**
         * Invoke save function for the region view
         * @api
         * @param {bool} e - Check whether is on check is dirty.
         */
        invokeCheckIsDirty: function() {
            var that = this,
                result = false;
            if (typeof that.options.checkIsDirty === 'function') {
                /* Helpers.executeFunctionByName(that.options.onClosing, window, that.uid);
                that.forceClose();*/
                if (that.options.checkIsDirty(that.uid) === false) {
                    that.actionAfterCheckIsDirty();
                    return false;
                } else {
                    if (that.options.doNotUseDefaultCheckIsDirty === true) {
                        return true; //that.checkIsDirty();
                    } else {
                        return that.checkIsDirty();
                    }
                }
            } else if (typeof that.options.checkIsDirty !== "undefined" && that.options.checkIsDirty !== '') {
                //javascript magic string is here: (^_^;)
                if (Helpers.executeFunctionByName(that.options.checkIsDirty, window, that.uid) === false) {
                    that.actionAfterCheckIsDirty();
                    return false;
                } else {
                    if (that.options.doNotUseDefaultCheckIsDirty === true) {
                        return true; //that.checkIsDirty();
                    } else {
                        return that.checkIsDirty();
                    }
                }
            } else {
                return that.checkIsDirty();
            }
        },

        /**
         * Invoke close function for the region view
         * @api
         */
        invokeCloseCallback: function() {
            var that = this;
            if (typeof that.options.closeCallback === 'function') {
                return that.options.closeCallback(that.uid);
            } else if (typeof that.options.closeCallback !== "undefined" && that.options.closeCallback !== '') {
                return Helpers.executeFunctionByName(that.options.closeCallback, window, that.uid); //javascript magic string is here: (^_^;)
            }
            return true;
        },

        /**
         * Invoke close function for the region view
         * @api
         */
        invokeCheckDataOutOfDate: function() {
            var that = this;
            if (typeof that.options.checkDataOutOfDate === 'function') {
                return that.options.checkDataOutOfDate(that.uid);
            } else if (typeof that.options.checkDataOutOfDate !== "undefined" && that.options.checkDataOutOfDate !== '') {
                return Helpers.executeFunctionByName(that.options.checkDataOutOfDate, window, that.uid); //javascript magic string is here: (^_^;)
            }
            return false;
        },

        /**
         * Invoke close function for the region view
         * @api
         */
        forceClose: function() {
            var that = this,
                parent;

            if (Helpers.isNull(that.options.parentUID) === false) {
                parent = Civica.RegionManager.get(that.options.parentUID);
                if (Helpers.isNull(parent) === false) {
                    parent.forceClose();
                }
            } else {
                that.dispose();
                that.invokeCloseCallback();
            }
        },

        /**
         * Obsolete property
         * @api
         */
        disposeTasks: ['empty'],

        /**
         * Obsolete property
         * @api
         */
        DisposeActions: {},

        /**
         * dispose the region view object
         * @private
         */
        dispose: function() {
            var that = this;

            that.empty();
            that.currentChild = null;
            var nextWnd = Civica.RegionManager.getLastView();
            if (Civica.RegionManager.CurrentRegionView !== null) {
                if (Civica.RegionManager.CurrentRegionView.uid === that.uid) {
                    if (Helpers.isNull(nextWnd) === true) {
                        Civica.RegionManager.$HomeRegionView.show();
                        //Civica.RegionManager.CurrentRegionView.currentChild = null;
                        Civica.RegionManager.CurrentRegionView = null;
                        Civica.HomePage.scaleHeight();
                    } else {
                        nextWnd.show();
                    }
                }
            }
            /*$.each(that.disposeTasks, function (idx, task) {
             var action = that.DisposeActions[task];
             if (action) {
             action(that.$element);
             }
             });*/
        },

        /**
         * swap lozenge - just a private function
         * @private
         * @param {object} lozenge - The jquery selector for the form of the sub/region view.
         * @param {bool} isPutStarts - whether reset the index of region views array.
         */
        SwapLozenge: function(lozenge, isPutStarts) {
            var index = $.inArray(lozenge, Civica.RegionManager.RegionViews);
            Civica.RegionManager.RegionViews.splice(index, 1);
            if (isPutStarts) {
                Civica.RegionManager.RegionViews.splice(0, 0, lozenge);
            } else {
                Civica.RegionManager.RegionViews.push(lozenge);
            }
        },

        /**
         * clean the region view object
         * @private
         */
        empty: function() {
            var that = this;

            // clean kendoUI controls
            that.$wndHandler.find('*').each(function() {
                var $this = $(this),
                    data = $this.data();
                if (typeof data !== 'undefined' && typeof data.handler !== 'undefined')
                    data.handler.destroy();
            });

            //clear window
            that.$wndHandler.remove();

            //clear lozenge
            if (Helpers.isNull(that.$lozenge) === false) {
                that.$lozenge.remove();
            }

            var index = $.inArray(that, Civica.RegionManager.RegionViews);
            Civica.RegionManager.RegionViews.splice(index, 1);
        },


        /**
         * invoke DI scaleHeight function
         * @private
         */
        scaleHeight: function() {
            var that = this;
            //scale height to fix screen: ⊙︿⊙
/*            if(Helpers.isMobile.iPhone() !== null) { // For Iphone4s
                return;
            }*/
            if (typeof that.options.scaleHeight === 'function') {
                //if (Modernizr.touch && Helpers.isMobile.iPhone() === null) {
                //    Civica.HomePage.scaleHeightForIpad();
                //}
                that.options.scaleHeight(that.uid);
            } else if (typeof that.options.scaleHeight !== "undefined" && that.options.scaleHeight !== '') {
                //if(Modernizr.touch && Helpers.isMobile.iPhone() === null) {
                //    Civica.HomePage.scaleHeightForIpad();
                //}
                Helpers.executeFunctionByName(that.options.scaleHeight, window, that.uid); //javascript magic string is here: (^_^;)
            }
        },

        /**
         * init event
         * @private
         */
        onInit: function() {
            var that = this,

                uid;
          
            //Init new Windows
            if (that.isHomeScreen === false) {
                that.url = that.$linkToOpen.data('url');
                if (typeof that.url === 'undefined' || that.url === null || that.$linkToOpen.is('a')) {
                    that.url = that.$linkToOpen.attr('href');
                }
                //json url
                that.jsonurl = that.$linkToOpen.data('jsonurl');
                if (!(typeof that.jsonurl === 'undefined' || that.jsonurl === null)) {
                    if (that.jsonurl.indexOf('[url]') != -1)
                        that.jsonurl = that.jsonurl.replace('[url]', that.url);
                }

                //form auto refresh
                that.entityId = that.$linkToOpen.data('entity-id');
                that.entityType = that.$linkToOpen.data('entity-type');
                that.relatedEntities = that.$linkToOpen.data('related-entities');

                that.checkIsDirtyUrl = that.$linkToOpen.data('dirty');
                that.isSubView = that.$linkToOpen.data('is-subview');
                that.isSubRootView = that.$linkToOpen.data('is-subrootview');
                if (typeof that.isSubRootView === 'undefined') {
                    that.isSubRootView = false;
                }
                if (typeof that.isSubView === 'undefined') {
                    that.isSubView = false;
                }

                if (Helpers.isNull(that.options.modelId) === false && Helpers.isNullOrEmpty(that.$linkToOpen.data('id')) === false) {
                    that.options.modelId = that.$linkToOpen.data('id');
                }


                $('.quick-menu-list').hide();

            }
            //preInit
            if (that.preInit() === true) {
                if (that.isSubView == true) {
                    that.createSubView();
                } else {
                    that.create();
                }
            }
        },

        /**
         * init event
         * @private
         */
        onActionToOpen: function() {
            var that = this,
                $tmp;

            if (that.$linkToOpen.hasClass('region-view') || that.options.isUsingOnEventBinding === true) {
                if (that.options.isUsingOnEventBinding == true) {
                    var action = function(e) {
                        that.$linkToOpen = $(this);
                        e.preventDefault();
                        if (!that.$linkToOpen.hasClass('region-view')) {
                            $tmp = $('.region-view', that.$linkToOpen);
                            that.$linkToOpen.addClass('region-view');
                            that.$linkToOpen.attr('title', $tmp.attr('title'));
                            if ($tmp.length > 0) {
                                $.each($tmp.data(), function(i, e) {
                                    that.$linkToOpen.attr('data-' + i, e);
                                });
                            }
                        }
                        that.onInit();
                        Civica.AdvanceSearch.hide(e);
                        Helpers.StandardSearch.close();
                        return false;
                    };
                    $(that.elementSelector).off(that.options.actionToOpen, "**");
                    $('body').unbind(that.options.actionToOpen, that.elementSelector).off(that.options.actionToOpen, that.elementSelector, action);
                    //$('body').on(that.options.actionToOpen, that.elementSelector, action);
                    $(that.elementSelector).on(that.options.actionToOpen, action);
                } else {
                    that.$linkToOpen.unbind(that.options.actionToOpen).bind(that.options.actionToOpen, function(e) {
                        e.preventDefault();
                        that.onInit(e);
                        Civica.AdvanceSearch.hide(e);
                        Helpers.StandardSearch.close();
                        return false;
                    });
                }
            }
        },

        /**
         * Open the first sub view of the region view
         * @api
         */
        
        openMandatorySubViews: function() {
            var that = this;
            var i = 0;
            var hasManadatoryView = false;
            var subRootViewIndex = -1;
            //At this stage, the first first view is already opened.
            if (!Helpers.isNull(that.prepareToOpenSubViews) && that.prepareToOpenSubViews.length > 1) {
                //let's start from the second tile
                for (; i < that.prepareToOpenSubViews.length; i++) {

                    if (that.prepareToOpenSubViews[i].$linkToOpen.length > 0 && (that.prepareToOpenSubViews[i].$linkToOpen.isSubRootView === true || that.prepareToOpenSubViews[i].$linkToOpen.data('is-subrootview') == true || that.prepareToOpenSubViews[i].$linkToOpen.data("is-mandatory-tile") === true)) {

                        if (that.prepareToOpenSubViews[i].$linkToOpen.isSubRootView == true || that.prepareToOpenSubViews[i].$linkToOpen.data('is-subrootview') === true) {
                            subRootViewIndex = i;
                        } else {
                            //It is not root-view -- it is manadatory view
                            hasManadatoryView = true;
                            $(that.prepareToOpenSubViews[i].elementSelector).click();
                        }
                    
                    }
                }

                //need to reopen root view 
                if (hasManadatoryView && subRootViewIndex > -1) {
                    $(that.prepareToOpenSubViews[subRootViewIndex].elementSelector).click();
                }

            }
        },
        
        openFirstSubView: function() {
            var that = this;
            var i = 0;
            if (Helpers.isNull(that.prepareToOpenSubViews) === false && that.prepareToOpenSubViews.length > 0) {
                for (; i < that.prepareToOpenSubViews.length; i++) {
                    if (that.prepareToOpenSubViews[i].$linkToOpen.length > 0 && (that.prepareToOpenSubViews[i].$linkToOpen.isSubRootView === true || that.prepareToOpenSubViews[i].$linkToOpen.data('is-subrootview') == true)) {
                        //$(that.prepareToOpenSubViews[i].elementSelector).click();
                        return;
                    }
                }
                for (i = 0; i < that.prepareToOpenSubViews.length; i++) {
                    if (that.prepareToOpenSubViews[i].$linkToOpen.length > 0) {
                        $(that.prepareToOpenSubViews[i].elementSelector).click();
                        return;
                    }
                }
            }
        },

        /**
         * Open the first sub view of the region view
         * @api
         */
        updateOriginalModel: function(isUpdateRoot, isResetObserver) {
            var that = this,
                $form;

            if (isUpdateRoot === true) {
                $form = that.getForm();
                that.originalModel = $form.serialize();
            } else {
                if (Helpers.isNull(that.children) === false && that.children.length > 0 && Helpers.isNull(that.currentChild) === false) {
                    $form = that.currentChild.getForm();
                    that.currentChild.originalModel = $form.serialize();
                } else {
                    $form = that.getForm();
                    that.originalModel = $form.serialize();
                }
            }

            /**Only apply new save behavior for RentModule*/
            var methodName = isResetObserver ? 'reset' : 'init';
            //if (that.options.isRentRegion) {
                var isChanged = false;
                if ($form.length) {
                    isChanged = $form.formObserver(methodName, isChanged);
                }
                
                if (isChanged === false) {
                    var grids = that.$container.find('.k-grid');
                    if (grids.length > 1) {
                        grids.each(function() {
                            $(this).formObserver(methodName, isChanged);
                        });
                    } else if (grids.length > 0) {
                        grids.formObserver(methodName, isChanged);
                    }
                }
            //}
        },

        /**
         * get the unique id of the current region view
         * @api
         */
        getCurrentUID: function() {
            var that = this;
            if (Helpers.isNull(that.children) === false && that.children.length > 0 && Helpers.isNull(that.currentChild) === false && Helpers.isNull(that.currentChild.uid) === false) {
                return that.currentChild.uid;
            } else {
                return that.uid;
            }
        },

        /**
         * Obsolete property
         * @api
         */
        element: null,

        /**
         * Unbind all kendo controls in region view
         * @private
         */
        unbind: function() {
            var that = this;
            if (that.vm) {
                kendo.unbind(that.element);
            }
        },


        /**
         * check whether a regionview is dirty
         * @api
         * @param {bool} isResetDirty - check whether forcing to reset form original model
         */
        checkIsDirty: function(isResetDirty) {
            var that = this,
                dirtyModel, result = false;
            that.getForm();
            if (Helpers.isNull(that.$form) === false) {
                if (that.$form.length > 0) {
                    dirtyModel = that.$form.serialize();
                    if (that.currentChild == null) {
                        result = !(that.originalModel === dirtyModel);
                    } else {
                        result = !(that.currentChild.originalModel === dirtyModel);
                    }

                } else {
                    //TODO:validate for grid form
                    that.getGridForms();
                    if (Helpers.isNull(that.$gridForms) === false && that.$gridForms.length > 0) {
                        for (var i = 0, length = that.$gridForms.length; i < length; i++) {
                            var isDirty = false,
                                kendoGrid = $(that.$gridForms[i]).data('kendoGrid');
                            if (Helpers.isNull(kendoGrid) === false) {
                                isDirty = kendoGrid.isDirty();
                                if (isDirty === true) {
                                    result = true;
                                    break;
                                }
                            }
                        }
                    }
                }
                //code for Rent
                that.isDirty = result;
                var lastViewIsDirty = Civica.RegionManager.CurrentRegionView.isContainDirtyView;
                Civica.RegionManager.CurrentRegionView.isContainDirtyView = that.isDirty || lastViewIsDirty;
            }

            //code for Rent
            if (that.options.isRentRegion == true) {
                if (!Civica.RegionManager.CurrentRegionView.isNeedCheckDirty) {
                    result = false;
                } else {
                    result = Civica.RegionManager.CurrentRegionView.isContainDirtyView;
                }
            }

            if (result === true) {
                that.isOnCheckIsDirty = true;
                that.openConfirmPopup(isResetDirty);
            } else {
                if (typeof that.actionAfterCheckIsDirty === 'function') {
                    that.actionAfterCheckIsDirty();
                }
                that.resetDirtyChecking(isResetDirty);
            }
            return result;
        },

        getGridForms: function() {
            var that = this;
            that.$gridForms = that.$wndHandler.find('.k-grid');
        },

        /**
         * get the jquery object of form of the region view
         * @private
         */
        getForm: function() {
            var that = this;

            //if (that.options.isRentRegion) {
            //    var current = "." + Civica.RegionManager.CurrentRegionView.uid;
            //    that.$form = $("form", current);
            //} else {
            if (that.isSubRootView === true && Helpers.isNull(that.parent) === false) {
                that.$form = that.parent.getForm();
                that.$forms = that.parent.getForm();
            } else {
                /*if (that.options.isRentRegion) {
                    that.$form = Civica.RegionManager.CurrentRegionView.currentChild != null
                           ? $("form:first", "." + Civica.RegionManager.CurrentRegionView.currentChild.uid)
                           : $("form:first", "." + Civica.RegionManager.CurrentRegionView.uid);
                }
                else*/
				if (Helpers.isNull(that.$wndHandler) === false) {
                    that.$form = that.$wndHandler.find('form:first');
				}

                if (that.$form == null || that.$form.length == 0) {
                    return that.$wndHandler;
                }
            }
            //}
            return that.$form;
        },

        /**
         * close the region view
         * @private
         */
        close: function() {
            var that = this,
                dirtyAction = that.invokeCheckIsDirty;
            Civica.RegionManager.CurrentRegionView.isClose = true;
            Civica.RegionManager.CurrentRegionView.currentClosedLozengeName = this.relatedEntities;
            Civica.RegionManager.CurrentRegionView.isNeedCheckDirty = true;
            if (that.isSaveAble === false) {
                that.forceClose();
                return;
            }

            if (typeof that.options.onClosing === 'function') {
                that.options.onClosing(uid);
            } else if (typeof that.options.onClosing !== "undefined" && that.options.onClosing !== '') {
                Helpers.executeFunctionByName(that.options.onClosing, window, that.uid); //javascript magic string is here: (^_^;)
            }

            if (Helpers.isNull(that.currentChild) === false) {
                that.currentChild.actionAfterCheckIsDirty = that.forceClose; //that.currentCivica.RegionManager.CurrentRegionView.forceClose;
                that.currentChild.invokeCheckIsDirty();
            } else {
                that.actionAfterCheckIsDirty = that.forceClose; //Civica.RegionManager.CurrentRegionView.forceClose;
                that.invokeCheckIsDirty();
            }
        },

        /**
         * open the notify popup of region view Eg: checkIsDirty popup
         * @private
         */
        openMessagePopUp: function() {
            
            var that = this,
                confirmTemplate = '<div id="" class="popup-box-head accent-colour-background clearfix">' + '<div id="dirtyPopupContent" class="box-title normal-text left"> Confirm</div>' + '<div class="button-funcs right">' + '<a id="pop-close" class="close" title="Close" href="#">Close</a>' + '</div>' + '</div>' + '<div class="popup-box-content">Do you wish to save the changes you have made before leaving this screen?</div>' + '<div class="YNButton clearfix" id="dirtyPopupButton">' + '<button id="btnYes" class="active-background active-text btn" title="Yes" type="button">Yes</button>' + '<button id="btnNo" class="active-background active-text btn" title="NO" type="button">No</button>' + '</div>',
                confirmPopup = $('</a>').popupBoxExtension({
                    isAjax: false,
                    data: confirmTemplate,
                    cssClass: 'dirty-popup-box',
                    callback: function() {
                        var popup = this;
                        $('#dirtyPopupButton #btnYes').unbind('click').click(function() {
                            that.closePopup(popup);
                            that.invokeSave(); //== true means invoke from check is dirty popup
                            if (typeof that.actionAfterCheckIsDirty === 'function') {
                                that.actionAfterCheckIsDirty();
                            }
                        });

                        $('#dirtyPopupButton #btnNo').unbind('click').click(function() {
                            that.closePopup(popup);

                            if (typeof that.actionAfterCheckIsDirty === 'function') {
                                that.actionAfterCheckIsDirty();
                            }
                        });
                    },
                    callbackOptions: {}
                });
        },

        /**
         * open the litmit message popup of the region view Eg: checkIsDirty popup
         * @private
         */
        openLimitMessagePopup: function() {
            var that = this,
                messagePopupTemplate = '<div class="popup-box-inner">' + '<div id="showMessagePop" class="popup-box-head accent-colour-background clearfix">' + '<div class="box-title normal-text left">Confirm</div>' + '<div class="button-funcs right">' + '<a id="pop-close" class="close" title="Close" href="#">Close</a>' + '</div>' + '</div>' + '<div class="popup-box-content">' + 'You already opened ' + that.options.limit + ' lozenges. Please close opened lozenge to continue.</div>' + '<div class="YNButton clearfix">' + '<button id="btnOkies" class="active-background active-text" title="Ok" type="button">Ok</button>' + '</div>' + '</div>',
                confirmPopup = $('</a>').popupBoxExtension({
                    isAjax: false,
                    data: messagePopupTemplate,
                    cssClass: 'dirty-popup-box',
                    callback: function() {
                        var popup = this;
                        $('#btnOkies').unbind('click').click(function() {
                            that.closePopup(popup);
                        });
                    },
                    callbackOptions: {}
                });
        },

        /**
         * close the notify popup of the region view Eg: checkIsDirty popup
         * @private
         * @param {popup object} popupBox - the popup that user want to close
         */
        closePopup: function(popupBox) {
            
            if (Civica.RegionView.isYesConfirm == undefined || Civica.RegionView.isYesConfirm == false) {
                Civica.RegionManager.CurrentRegionView.isClose = false;
                Civica.RegionManager.CurrentRegionView.currentClosedLozengeName = "";
            }
            Civica.RegionView.isYesConfirm = false;
            Civica.RegionManager.closePopup(popupBox); //bind key up event, because popup show unbinded this event
        },

        /**
         * Open the Auto popup of the region view.
         * @private
         */
        openFormAutoRefreshPopup: function() {
            var that = this;
            that.markAsUpToDate();
            that.invokeProcessTileCounter();
            if (Civica.RegionManager.CurrentRegionView.options.isConfigurationScreen) {
                that.invokeDataRefresh();
            } else {
                that.loadContent();
            }

            return;
        },

        /**
         * reset dirty status of the region view.
         * @private
         * @param {popup object} popupBox - the popup that user want to close
         */
        resetDirtyChecking: function(isresetdirty) {

            if (Civica.RegionManager.CurrentRegionView != null) {
                Civica.RegionManager.CurrentRegionView.isNeedCheckDirty = false;
                if (isresetdirty) {
                    Civica.RegionManager.CurrentRegionView.isContainDirtyView = false;
                    this.removeHighlightBar();
                }
            }
        },

        /**
         * Open the confirm popup of the region view.
         * @private
         * @param {bool} isResetDirty - check whether forcing to reset form original model
         */
        openConfirmPopup: function(isresetdirty) {
            var that = this,
                confirmTemplate = '<div id="" class="popup-box-head accent-colour-background clearfix">' + '<div id="dirtyPopupContent" class="box-title normal-text left"> Confirm</div>' + '<div class="button-funcs right">' + '<a id="pop-close" class="close" title="Close" href="#">Close</a>' + '</div>' + '</div>' + '<div class="popup-box-content">Do you wish to save the changes you have made before leaving this screen?</div>' + '<div class="YNButton clearfix" id="dirtyPopupButton">' + '<button id="btnYes" class="active-background active-text btn" title="Yes" type="button">Yes</button>' + '<button id="btnNo" class="active-background active-text btn" title="NO" type="button">No</button>' + '</div>';
            if ($(".dirty-popup-box").length > 0)
                return;
            var confirmPopup = $('</a>').popupBoxExtension({
                isAjax: false,
                data: confirmTemplate,
                cssClass: 'dirty-popup-box',
                isDisableCloseButton: true,
                callback: function() {
                    var popup = this;

                    $('#dirtyPopupButton #btnYes').focus().unbind('click').click(function() {
                        Civica.RegionView.isYesConfirm = true;
                        Civica.RegionView.isSaveConfirm = true;
                        that.resetDirtyChecking(true); //place at begin to make sure CurrentRegionView have not been destroyed
                        that.closePopup(popup);
                        var sucessSave = false;
                        if (that.options.isRentRegion) {
                            sucessSave = Civica.RegionManager.CurrentRegionView.saveAllTabs(true);
                        } else {
                            sucessSave = that.invokeSave(true);
                        }
                        if (sucessSave) {
                            if (typeof that.actionAfterCheckIsDirty === 'function') {
                                that.actionAfterCheckIsDirty();
                            }
                            Civica.RegionManager.checkAndProcessLogout();
                        } else {
                            //work around here
                            that.initSaveEvent();
                        }
                        if (Helpers.isNull(that.children) === false && that.children.length > 0 && Helpers.isNull(that.currentChild) === false) {
                            that.currentChild.scaleHeight();
                        } else {
                            that.scaleHeight();
                        }
                        
                    }).focus();

                    $('.dirty-popup-box .close:visible').off('click').on('click', function() {
                        if (typeof that.actionAfterPopupClose == 'function')
                            that.actionAfterPopupClose();
                        that.closePopup(popup);
                        that.resetDirtyChecking(isresetdirty);
                        if (Civica.RegionManager.IsInLogoutMode) {
                            that.forceClose();
                            Civica.RegionManager.checkAndProcessLogout();
                            return;
                        }
                    });

                    $('#dirtyPopupButton #btnNo').off('click').on('click', function() {
                        that.resetDirtyChecking(true); //place at begin to make sure CurrentRegionView have not been destroyed
                        that.closePopup(popup);
                        if (Civica.RegionManager.IsInLogoutMode) {
                            that.forceClose();
                            Civica.RegionManager.checkAndProcessLogout();
                            return;
                        }
                        if (Helpers.isNull(that.$gridForms) === false) {
                            that.$gridForms.each(function() {
                                var kGrid = $(this).data('kendoGrid');
                                if (typeof kGrid !== 'undefined') {
                                    kGrid.resetTrackingDataSource();
                                    kGrid.dataSource.read();
                                }
                            });
                        }
                        that.originalModel = that.$form.serialize();
                        if (typeof that.actionAfterCheckIsDirty === 'function') {
                            that.actionAfterCheckIsDirty();
                            that.invokeChangeSubViewCallback();
                            if (Helpers.isNull(that.children) === false && that.children.length > 0 && Helpers.isNull(that.currentChild) === false) {
                                that.currentChild.scaleHeight();
                            } else {
                                that.scaleHeight();
                            }
                        }
                    });
                    $('#dirtyPopupButton #btnYes').focus();
                },
                callbackOptions: {}
            });
        },

        /**
         * Open the notify popup of the region view.
         * @private
         */
        openNotifyPopup: function() {
            
            var that = this,
                notifyTemplate = '<div id="" class="popup-box-head accent-colour-background clearfix">' + '<div id="dirtyPopupContent" class="box-title normal-text left"> Confirm</div>' + '<div class="button-funcs right">' + '<a id="pop-close" class="close" title="Close" href="#">Close</a>' + '</div>' + '</div>' + '<div class="popup-box-content">Do you wish to save the changes you have made before leaving this screen?</div>' + '<div class="YNButton clearfix" id="notifyPopupButton">' + '<button id="btnOK" class="active-background active-text btn" title="Yes" type="button">OK</button>' + '</div>',
                notifyPopup = $('body').popupBoxExtension({
                    isDeferred: false,
                    isAjax: false,
                    data: notifyTemplate,
                    isNotify: true,
                    callback: function() {
                        $('#notifyPopupButton #btnOK').unbind('click').click(function() {
                            that.closePopup(popup);
                            that.loadContent();

                        });
                    }
                });
        },


        /**
         * Obsolete function.
         * @private
         */
        checkDataOutOfDate: function(url) {
            var that = this;
            return false;
        },


        /**
         * Reload a sub region view 
         * @api
         * @param {string} controlClass - The css class of the sub region view
         */
        reloadChildWnd: function(controlClass) {
            var that = this;
            if (Helpers.isNull(that.children) === false && that.children.length > 0) {
                for (var j = 0; j < that.children.length; j++) {
                    if (controlClass === that.children[j].controlClass) {
                        return that.children[j].loadContent();
                    }
                }
            }
        },

        /**
         * compare two models 
         * @private
         * @param {object} o1 - The model 1
         * @param {object} o2 - The model 2
         */
        compareModels: function(o1, o2) {
            for (var p in o1) {
                switch (typeof(o1[p])) {
                    case 'object':
                        if (!compare(o1[p], o2[p]))
                            return false;

                        break;
                    default:
                        if (o2[p] == null) return false;

                        if (o2[p].toString().indexOf('/Date') == -1) {
                            if (o1[p].toString() != o2[p].toString()) return false;
                        }
                }
            }
            return true;
        },

        /**
         * reset model status for the autorefesh feature
         * @private
         * @param {object} m - The model will be reset
         */
        cleanModelForAutoRefresh: function(m) {
            var that = this;
            var keptFields = new Array();
            keptFields[0] = 'Id';
            keptFields[1] = 'TimestampString';

            if (that.options.dataRefreshFields != '') {
                keptFields = that.dataRefreshFields.split(',');
            }

            for (var key in m) {
                if (typeof m[key] == "object") {
                    that.cleanModelForAutoRefresh(m[key]);
                } else {
                    var exists = false;
                    for (var i = 0; i <= keptFields.length - 1; i++) {
                        if (keptFields[i].toLowerCase() == key.toLowerCase()) {
                            exists = true;
                            break;
                        }
                    }
                    if (!exists)
                        m[key] = null;

                }
            }
        },

        openSubViewWhenInit: function(controlClass) {
            var that = this;
            for (var i = 0, n = that.prepareToOpenSubViews.length; i < n; i++) {
                if (that.prepareToOpenSubViews[i].options.controlClass === controlClass) {
                    that.prepareToOpenSubViews[i].$linkToOpen.click();
                    return true;
                }
            }
            return false; // find nothing
        },

        /**
         * Obsolete property.
         * @private
         */
        initTaskBar: DoNothing,

        /**
         * Obsolete property.
         * @private
         */
        refresh: DoNothing,

        /**
         * Obsolete property.
         * @private
         */
        enable: DoNothing,

        /**
         * Obsolete property.
         * @private
         */
        disable: DoNothing,
    });
})(jQuery, window.tmx = window.tmx || {});
