$(document).ready(function () {
    tmx.vivablast.stockoutManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.stockoutManager = {
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
            tmx.vivablast.stockoutManager.loadDataList();
            tmx.vivablast.stockoutManager.registerEventIndex(uid);

            $("#StockCode").autocomplete({
                source: "/Stock/ListCode?term" + $("#StockCode").val()
            });

            $("#StockName").autocomplete({
                source: "/Stock/ListName?term" + $("#StockName").val()
            });
        },

        loadDataList: function () {
            $.ajax({
                url: '/StockOut/LoadDataList',
                type: 'GET',
                data: {
                    page: tmx.vivablast.stockoutManager.page(),
                    size: tmx.vivablast.stockoutManager.pageSize(),
                    store: tmx.vivablast.stockoutManager.getStore(),
                    project: tmx.vivablast.stockoutManager.getProject(),
                    stockType: tmx.vivablast.stockoutManager.getStockType(),
                    stockCode: tmx.vivablast.stockoutManager.getStockCode(),
                    stockName: tmx.vivablast.stockoutManager.getStockName(),
                    siv: tmx.vivablast.stockoutManager.getSIV(),
                    fd: tmx.vivablast.stockoutManager.getFD(),
                    td: tmx.vivablast.stockoutManager.getTD(),
                    enable: '1'
                },
                datatype: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.stockoutManager.registerEventIndexInList();
                    }
                }
            });
        },

        exportExcel: function () {
            var search = "page=" + tmx.vivablast.stockoutManager.page();
            search += "&size=" + tmx.vivablast.stockoutManager.pageSize();
            search += "&store=" + tmx.vivablast.stockoutManager.getStore();
            search += "&project=" + tmx.vivablast.stockoutManager.getProject();
            search += "&stockType=" + tmx.vivablast.stockoutManager.getStockType();
            search += "&stockCode=" + tmx.vivablast.stockoutManager.getStockCode();
            search += "&stockName=" + tmx.vivablast.stockoutManager.getStockName();
            search += "&siv=" + tmx.vivablast.stockoutManager.getSIV();
            search += "&fd=" + tmx.vivablast.stockoutManager.getFD();
            search += "&td=" + tmx.vivablast.stockoutManager.getTD();
            search += "&enable=1";
            document.location.href = "/StockOut/ExportToExcel?" + search;
        },

        getStore: function () {
            var store = $('#searchStore').val();
            store = store === "" ? 0 : store;
            return store;
        },

        getProject: function () {
            var data = $('#searchProjectCode').val();
            data = data === "" ? 0 : data;
            return data;
        },

        getStockType: function () {
            var data = $('#searchType').val();
            data = data === "" ? 0 : data;
            return data;
        },

        getSIV: function () {
            return $('#searchSIV').val();
        },

        getStockCode: function () {
            return $('#StockCode').val();
        },

        getStockName: function () {
            return $('#StockName').val();
        },

        getFD: function () {
            if ($('#fromDate').val() != "") {
                var parts = $('#fromDate').val().split('/');
                var dmyDate = parts[1] + '/' + parts[0] + '/' + parts[2];
                return dmyDate;
            }
            return '';
        },

        getTD: function () {
            if ($('#toDate').val() != "") {
                var parts = $('#toDate').val().split('/');
                var dmyDate = parts[1] + '/' + parts[0] + '/' + parts[2];
                return dmyDate;
            }
            return '';
        },

        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $(".pagination a:first").addClass("current");
                    tmx.vivablast.stockoutManager.loadDataList(uid);
                }
            }

            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.stockoutManager.loadDataList(uid);
            });

            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.stockoutManager.loadDataList(uid);
            });

            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.stockoutManager.exportExcel(uid);
            });
        },

        registerEventIndexInList: function () {
            $('#MasterList').dataTable({
                "sDom": "Rlfrtip",
                "bLengthChange": false,
                "bFilter": false,
                "bInfo": false,
                "bPaginate": false,
                "aaSorting": [[2, "desc"]],
                "aoColumnDefs": [
                    {
                        "bSortable": false,
                        "aTargets": [-1] // <-- gets last column and turns off sorting
                    }
                ]
            });

            $("#MasterList tr.vbcolum td:not(:first-child)").click(function () {
                if ($(this).parent().next("tr").hasClass("detail")) {
                    $(this).parent().next("tr").toggle();

                } else {
                    var id = $(this).closest('tr').find('.ItemKey').val();
                    var htmls = '<tr class="detail">' +
                                                '<td colspan="10">' +
                                                    '<div class="' + id + '"><div>' +
                                                '</td>' +
                                            '</tr>';
                    $(htmls).insertAfter($(this).closest('tr'));

                    $.ajax({
                        url: '/StockOut/LoadDataDetailList',
                        type: 'GET',
                        data: {
                            id: id,
                            enable: '1'
                        },
                        datatype: 'json',
                        contentType: 'application/json; charset=utf-8',
                        success: function (data) {
                            if (data.length != 0) {
                                $("." + id).empty().append(data);
                                tmx.vivablast.stockoutManager.registerEventIndexInListDetail();
                            }
                        }
                    });
                }
                $(this).find(".arrow").toggleClass("up");
            });

            $('.pagination a').off("click").on("click", function () {
                $("a.current").removeClass("current");
                $(this).addClass("current");
                tmx.vivablast.stockoutManager.loadDataList();
            });

            //$('.btn-danger').off("click").on("click", function () {
            //    var id = $(this).closest('tr').find('.ItemKey').val();
            //    var entityName = $(this).closest('tr').find('.StoreName').text();
            //    openYesNoDialog({
            //        sectionTitle: "Delete",
            //        title: "Are you sure delete <b>" + entityName + "</b>.",
            //        data: '',
            //        yesCallback: function () {
            //            $.ajax({
            //                url: $('#hidDeleteUrl').val(),
            //                type: "POST",
            //                data: {
            //                    id: id
            //                },
            //                cache: false,
            //                success: function (response) {
            //                    if (response.result === true) {
            //                        tmx.vivablast.storeManager.loadStore();
            //                    }
            //                    else if (response.result === $('#hidUnDelete').val()) {
            //                        openErrorDialog({
            //                            title: "Can not delete",
            //                            data: "The store <b>" + entityName + "</b> has been used."
            //                        });
            //                    }
            //                },
            //                error: function () {
            //                    errorSystem();
            //                }
            //            });
            //        },
            //        noCallback: function () {
            //        }
            //    });
            //});
        },

        registerEventIndexInListDetail: function () {
            $('.DetailList').dataTable({
                "bDestroy": true
            });
        }
    };
})(jQuery, window.tmx = window.tmx || {});