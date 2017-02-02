;
(function($) {
    /** get attributes of element **/
    $.fn.getAttributes = function() {
        var attributes = {};

        if(!this.length)
            return this;

        $.each(this[0].attributes, function(index, attr) {
            attributes[attr.name] = attr.value;
        });

        return attributes;
    };


    /** Popup Box **/
    $.fn.popupBox = function(opts) {
        var def = {
            baseUrl: '',
            overlay: 'overlay',
            close: '.close',
            cssClass: 'popup-box',
            //loading: Helpers.resolveUrl('Images/img/loader.gif'),
            closeCallback: function() { },
            isAjax: true,
            isAnimated: true,
            isDeferred: false,
            data: null,
            isNotify: false
        },
        o = $.extend(def, opts),
        _this = this, overlay = $('<div id="' + o.overlay + '"></div>'),
        //loading = $('<img src="' + o.loading + '" id="loader"></div>'),
        outterpo = o.cssClass,
        innerpo = 'popup-box-inner',
        outterWrap = '<div class="' + outterpo + '"></div>',
        inner_wrap = '<div class="' + innerpo + '"></div>',
        url = o.baseUrl;

        this.init = function () {
            
            if (typeof tmx !== 'undefined' && typeof tmx.RegionManager !== 'undefined') {
            tmx.RegionManager.unbindKeyUp();
            }
            popbox = null;
            poinbox = null;
            if(o.isDeferred === false) {
                _this.open(url);
            } else {
                _this.deferredOpen(url);
            }
            poinbox.keyup(function (e) {
                if (e.keyCode == 27) {
                    pobox.remove();
                    overlay.detach();

                    e.stopPropagation();
                    if (typeof tmx !== 'undefined' && typeof tmx.RegionManager !== 'undefined') {
                    tmx.RegionManager.bindKeyUp();
                }
                }
            });
        };

        this.event = function() {

        };

        this.open = function(url) {
            var _heightpo, _widthpo, mrt, mrl,
                attrs = this.getAttributes();

            $.each(attrs, function(i, data) {
                if(i == 'href' || i == 'data-rel') {
                    if(data != '') {
                        o.baseUrl = data;
                    }
                }
            });

            loading.appendTo('body');
            overlay.appendTo('body');
            $(outterWrap).html(inner_wrap).appendTo('body');
            pobox = $('.' + outterpo), poinbox = $('.' + innerpo);
            if(o.isAjax === true) {
                $.ajax({
                    type: "GET",
                    url: url,
                    cache: false
                }).done(function(result) {
                    poinbox.empty().append(result);
                    loading.detach();
                    _heightpo = pobox.height(), _widthpo = pobox.width(), mrt = parseInt(_heightpo / 2), mrl = parseInt(_widthpo / 2);
                    _this.setPosition();
                    // Xuan
                    //pobox.css({ 'margin-left': -mrl + 'px', 'margin-top': -mrt + 'px' });

                    var scanDataGrid = setInterval(function () {
                        if(pobox.find('table').length > 0) {
                            var widthReal = pobox.width();
                            if(widthReal > 0) {
                                if(widthReal > 1000) {
                                    pobox.width(1000);
                                    //pobox.css({ 'margin-left': '-500px' }).show();
                                } else {
                                    pobox.width(widthReal);
                                    mrl = parseInt(widthReal / 2);
                                    //pobox.css({ 'margin-left': -mrl + 'px' }).show();
                                }
                                clearInterval(scanDataGrid);
                                Helpers.firstFocus(poinbox);
                            }
                        } else {
                            mrl = parseInt(_widthpo / 2);
                            //pobox.css({ 'margin-left': -mrl + 'px' }).show();
                            clearInterval(scanDataGrid);
                            Helpers.firstFocus(poinbox);
                        }
                    }, 200);


                    if(typeof o.callback === 'function') {
                        if(o.callbackOptions) {
                            o.callback.apply({ pobox: pobox, overlay: overlay }, [o.callbackOptions]);
                        } else {
                            o.callback();
                        }
                    }
                    _this.close();
                });
            } else {
                //setTimeout(function() { loading.detach(); }, 1000);
                loading.detach();
                poinbox.empty().append(o.data);
                _heightpo = pobox.height(), _widthpo = pobox.width(), mrt = parseInt(_heightpo / 2), mrl = parseInt(_widthpo / 2);
                _this.setPosition();
                //pobox.css({ 'margin-left': -mrl + 'px', 'margin-top': -mrt + 'px' }).show();
                if(typeof o.callback === 'function') {
                    if(o.callbackOptions) {
                        o.callback.apply({ pobox: pobox, overlay: overlay }, [o.callbackOptions]);
                    } else {
                        o.callback();
                    }
                }
                //Helpers.firstFocus(poinbox);
                _this.close();
            }
            overlay.show();
        };

        this.setPosition = function() {
            if(o.isNotify == true) {
                //pobox.css({ top: '0', left: '50%' });
            } else {
                //pobox.css({ top: '50%', left: '50%' });
            }
        },

        this.deferredOpen = function(url) {
            var _heightpo, _widthpo, mrt, mrl,
               attrs = this.getAttributes();

            $.each(attrs, function(i, data) {
                if(i == 'href' || i == 'data-rel') {
                    if(data != '') {
                        o.baseUrl = data;
                    }
                }
            });

            if(o.isAjax === true) {
                $.ajax({
                    type: "GET",
                    url: url,
                    cache: false
                }).done(function(result) {
                    if(typeof result === 'undefined' || result === null || result === '' || result.nodeName === '#document') {
                        //Do nothing
                        loading.detach();
                        return;
                    } else {
                        overlay.appendTo('body').show();
                        $(outterWrap).html(inner_wrap).appendTo('body');
                        pobox = $('.' + outterpo), poinbox = $('.' + innerpo);
                        setTimeout(function() { loading.detach(); }, 1000);
                        poinbox.empty().append(result);
                        _heightpo = pobox.height(), _widthpo = pobox.width(), mrt = parseInt(_heightpo / 2), mrl = parseInt(_widthpo / 2);
                        //pobox.css({ top: '50%', left: '50%', 'margin-left': -mrl + 'px', 'margin-top': -mrt + 'px' }).show();
                        if(typeof o.callback === 'function') {
                            if(o.callbackOptions) {
                                o.callback.apply({ pobox: pobox, overlay: overlay }, [o.callbackOptions]);
                            } else {
                                o.callback();
                            }
                        }
                        Helpers.firstFocus(poinbox);
                        _this.close();
                    }
                });
            } else {
                $(outterWrap).html(inner_wrap).appendTo('body');
                pobox = $('.' + outterpo), poinbox = $('.' + innerpo);
                setTimeout(function() { loading.detach(); }, 1000);
                poinbox.empty().append(o.data);
                _heightpo = pobox.height(), _widthpo = pobox.width(), mrt = parseInt(_heightpo / 2), mrl = parseInt(_widthpo / 2);
                //pobox.css({ top: '50%', left: '50%', 'margin-left': -mrl + 'px', 'margin-top': -mrt + 'px' }).show();
                if(typeof o.callback === 'function') {
                    if(o.callbackOptions) {
                        o.callback.apply({ pobox: pobox, overlay: overlay }, [o.callbackOptions]);
                    } else {
                        o.callback();
                    }
                }
                Helpers.firstFocus(poinbox);
                _this.close();
            }

        };

        this.close = function() {
            var close = $(o.close);
            close.on('click', function(e) {
                var $this = $(this);
                e.preventDefault();
                o.closeCallback();
                e.stopPropagation();
                pobox.remove();
                overlay.detach();

            });

            //$(window)
            //    .click(function(e) {
            //        //e.target.id == o.overlay ? close.trigger('click') : false;
            //    })
            //    .keydown(function(e) {
                    
            //    });
        };

        if(this.init) {
            this.init();
        }

        return this;
    };
})(jQuery);