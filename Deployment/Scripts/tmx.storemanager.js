$(document).ready(function () {
    tmx.vivablast.storeManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.storeManager = {
        page: function () {
            var id = $(".pagination a.current").html();
            if (typeof id === 'undefined') {
                id = 1;
            }
            return id;
        },
        pageSize: function () {
            var id = $("#pageSize").val();
            id = id === "" ? 10 : id;
            return id;
        },
        sortBy: 1,
        sortType: 1,
        urltemp: '',
        /** unique id of element maintenance lozenge */
        uid: '',
        /** The CSS class is used to select lozenge element*/
        cssClassSelector: '',
        /** The tab option configuration*/

        init: function (uid) {
            $('#loading-indicator').hide();
            tmx.vivablast.storeManager.loadStore(uid);
            tmx.vivablast.storeManager.registerEventIndex(uid);
            
            $("#StoreCode").autocomplete({
                source: "/Store/ListCode?term" + $("#StoreCode").val()
            });
            $("#StoreName").autocomplete({
                source: "/Store/ListName?term" + $("#StoreName").val()
            });
        },

        loadStore: function () {
            $.ajax({
                url: '/Store/LoadStore',
                type: 'GET',
                data: {
                    page: tmx.vivablast.storeManager.page,
                    size: tmx.vivablast.storeManager.pageSize,
                    storeCode: tmx.vivablast.storeManager.getStoreCode(),
                    storeName: tmx.vivablast.storeManager.getStoreName(),
                    country: tmx.vivablast.storeManager.getCountry(),
                    enable: '1'
                },
                datatype: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.storeManager.registerEventIndexInList();
                    }
                }
            });
        },

        exportExcel: function () {
            //$('#loading-indicator').show();
            var search = "page=" + tmx.vivablast.storeManager.page();
            search += "&size=" + tmx.vivablast.storeManager.pageSize();
            search += "&storeCode=" + tmx.vivablast.storeManager.getStoreCode();
            search += "&storeName=" + tmx.vivablast.storeManager.getStoreName();
            search += "&country=" + tmx.vivablast.storeManager.getCountry();
            search += "&enable=" + "1";
            document.location.href = "/Store/ExportToExcel?" + search;
        },
        
        getStoreCode: function () {
            return $('#StoreCode').val();
        },

        getStoreName: function () {
            return $('#StoreName').val();
        },
        getCountry: function () {
            var country = $('#country').val();
            country = country === "" ? 0 : country;
            return country;
        },

        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $("#mycontent .pagination a:first").addClass("current");
                    tmx.vivablast.storeManager.loadStore(uid);
                }
            }
            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $("#mycontent .pagination a:first").addClass("current");
                tmx.vivablast.storeManager.loadStore(uid);
            });
            
            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $("#mycontent .pagination a:first").addClass("current");
                tmx.vivablast.storeManager.loadStore(uid);
            });
            
            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.storeManager.exportExcel(uid);
            });
        },

        registerEventIndexInList: function () {
            $('#StoreLst').dataTable({
                "sDom": "Rlfrtip",
                "bLengthChange": false,
                "bFilter": false,
                "bInfo": false,
                "bPaginate": false,
                "aaSorting": [[1, "desc"]],
                "aoColumnDefs": [
                    {
                        "bSortable": false,
                        "aTargets": [0] // <-- -1 is gets last column and turns off sorting
                    }
                ]
            });

            $('.pagination a').off("click").on("click", function () {
                $("a.current").removeClass("current");
                $(this).addClass("current");
                tmx.vivablast.storeManager.loadStore();
            });
            
            $('.btn-danger').off("click").on("click", function () {
                var id = $(this).closest('tr').find('.ItemKey').val();
                var entityName = $(this).closest('tr').find('.StoreName').text();
                openYesNoDialog({
                    sectionTitle: "Delete",
                    title: "Are you sure delete <b>" + entityName + "</b>.",
                    data: '',
                    yesCallback: function () {
                        $.ajax({
                            url: $('#hidDeleteUrl').val(),
                            type: "POST",
                            data: {
                                id: id
                            },
                            cache: false,
                            success: function (response) {
                                if (response.result === true) {
                                    tmx.vivablast.storeManager.loadStore();
                                }
                                else if (response.result === $('#hidUnDelete').val()) {
                                    openErrorDialog({
                                        title: "Can not delete",
                                        data: "The store <b>" + entityName + "</b> has been used."
                                    });
                                }
                            },
                            error: function () {
                                errorSystem();
                            }
                        });
                    },
                    noCallback: function () {

                    }
                });
            });
        },
    };
})(jQuery, window.tmx = window.tmx || {});