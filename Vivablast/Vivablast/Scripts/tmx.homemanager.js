$(document).ready(function () {
    tmx.vivablast.homeManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.homeManager = {
        init: function (uid) {
            $('#loading-indicator').hide();
        }
    };
})(jQuery, window.tmx = window.tmx || {});