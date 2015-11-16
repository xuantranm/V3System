$(document).ready(function () {
    tmx.vivablast.service.init();
});

(function ($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.service = {
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
            tmx.vivablast.service.loadService(uid);
            tmx.vivablast.service.registerEventIndex(uid);

            $("#StockCode").autocomplete({
                source: "/Service/ListCode?term" + $("#StockCode").val()
            });

            $("#StockName").autocomplete({
                source: "/Service/ListName?term" + $("#StockName").val()
            });
        },

        loadService: function () {
            $.ajax({
                url: '/Service/LoadDataList',
                type: 'GET',
                data: {
                    page: tmx.vivablast.service.page(),
                    size: tmx.vivablast.service.pageSize(),
                    code: tmx.vivablast.service.getCode(),
                    name: tmx.vivablast.service.getName(),
                    store: tmx.vivablast.service.getStore(),
                    category: tmx.vivablast.service.getCategory(),
                    enable: '1'
                },
                datatype: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.service.registerEventIndexInList();
                    }
                }
            });
        },

        exportExcel: function () {
            var search = "page=" + tmx.vivablast.service.page();
            search += "&size=" + tmx.vivablast.service.pageSize();
            search += "&code=" + tmx.vivablast.service.getCode();
            search += "&name=" + tmx.vivablast.service.getName();
            search += "&store=" + tmx.vivablast.service.getStore();
            search += "&category=" + tmx.vivablast.service.getCategory();
            search += "&enable=" + "1";
            document.location.href = "/Service/ExportToExcel?" + search;
        },

        getCode: function () {
            return $('#StockCode').val();
        },

        getName: function () {
            return $('#StockName').val();
        },

        getStore: function () {
            var result = $('#searchStore').val();
            result = result === "" ? 0 : result;
            return result;
        },
        
        getCategory: function () {
            var result = $('#searchCategory').val();
            result = result === "" ? 0 : result;
            return result;
        },

        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $(".pagination a:first").addClass("current");
                    tmx.vivablast.service.loadService(uid);
                }
            }
            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.service.loadService(uid);
            });

            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.service.loadService(uid);
            });

            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.service.exportExcel(uid);
            });
        },

        registerEventIndexInList: function () {
            $('#ServiceLst').dataTable({
                "sDom": "Rlfrtip",
                "bLengthChange": false,
                "bFilter": false,
                "bInfo": false,
                "bPaginate": false,
                "aaSorting": [[2, "asc"]],
                "aoColumnDefs": [
                    {
                        "bSortable": false,
                        "aTargets": [0] // <-- -1 gets last column and turns off sorting
                    }
                ]
            });

            $('.pagination a').off("click").on("click", function () {
                $("a.current").removeClass("current");
                $(this).addClass("current");
                tmx.vivablast.service.loadService();
            });

            $('.btn-danger').off("click").on("click", function () {
                var id = $(this).closest('tr').find('.ItemKey').val();
                var entityName = $(this).closest('tr').find('.StockCode').text();
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
                                    tmx.vivablast.service.loadService();
                                }
                                else if (response.result === $('#hidUnDelete').val()) {
                                    openErrorDialog({
                                        title: "Can not delete",
                                        data: "The service <b>" + entityName + "</b> has been used."
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
        }
    };
})(jQuery, window.tmx = window.tmx || {});