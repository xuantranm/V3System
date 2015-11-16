$(document).ready(function () {
    tmx.vivablast.stockreturnManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.stockreturnManager = {
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
            tmx.vivablast.stockreturnManager.loadDataList();
            tmx.vivablast.stockreturnManager.registerEventIndex(uid);

            $("#StockCode").autocomplete({
                source: "/Stock/ListCode?term" + $("#StockCode").val()
            });

            $("#StockName").autocomplete({
                source: "/Stock/ListName?term" + $("#StockName").val()
            });
        },

        loadDataList: function () {
            $.ajax({
                url: '/StockReturn/LoadDataList',
                type: 'GET',
                data: {
                    page: tmx.vivablast.stockreturnManager.page(),
                    size: tmx.vivablast.stockreturnManager.pageSize(),
                    store: tmx.vivablast.stockreturnManager.getStore(),
                    project: tmx.vivablast.stockreturnManager.getProject(),
                    stockType: tmx.vivablast.stockreturnManager.getStockType(),
                    stockCode: tmx.vivablast.stockreturnManager.getStockCode(),
                    stockName: tmx.vivablast.stockreturnManager.getStockName(),
                    srv: tmx.vivablast.stockreturnManager.getSRV(),
                    fd: tmx.vivablast.stockreturnManager.getFD(),
                    td: tmx.vivablast.stockreturnManager.getTD(),
                    enable: '1'
                },
                datatype: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.stockreturnManager.registerEventIndexInList();
                    }
                }
            });
        },

        exportExcel: function () {
            var search = "page=" + tmx.vivablast.stockreturnManager.page();
            search += "&size=" + tmx.vivablast.stockreturnManager.pageSize();
            search += "&store=" + tmx.vivablast.stockreturnManager.getStore();
            search += "&project=" + tmx.vivablast.stockreturnManager.getProject();
            search += "&stockType=" + tmx.vivablast.stockreturnManager.getStockType();
            search += "&stockCode=" + tmx.vivablast.stockreturnManager.getStockCode();
            search += "&stockName=" + tmx.vivablast.stockreturnManager.getStockName();
            search += "&srv=" + tmx.vivablast.stockreturnManager.getSRV();
            search += "&fd=" + tmx.vivablast.stockreturnManager.getFD();
            search += "&td=" + tmx.vivablast.stockreturnManager.getTD();
            search += "&enable=1";
            document.location.href = "/StockReturn/ExportToExcel?" + search;
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

        getSRV: function () {
            return $('#searchSRV').val();
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
                    tmx.vivablast.stockreturnManager.loadDataList(uid);
                }
            }

            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.stockreturnManager.loadDataList(uid);
            });

            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.stockreturnManager.loadDataList(uid);
            });

            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.stockreturnManager.exportExcel(uid);
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
                        url: '/StockReturn/LoadDataDetailList',
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
                                tmx.vivablast.stockreturnManager.registerEventIndexInListDetail();
                            }
                        }
                    });
                }
                $(this).find(".arrow").toggleClass("up");
            });

            $('.pagination a').off("click").on("click", function () {
                $("a.current").removeClass("current");
                $(this).addClass("current");
                tmx.vivablast.stockreturnManager.loadDataList();
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