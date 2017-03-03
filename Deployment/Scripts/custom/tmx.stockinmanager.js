$(document).ready(function () {
    tmx.vivablast.stockinManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.stockinManager = {
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
            tmx.vivablast.stockinManager.loadDataList();
            tmx.vivablast.stockinManager.registerEventIndex(uid);

            $("#StockCode").autocomplete({
                source: "/Stock/ListCode?term" + $("#StockCode").val()
            });

            $("#StockName").autocomplete({
                source: "/Stock/ListName?term" + $("#StockName").val()
            });
        },

        loadDataList: function () {
            $.ajax({
                url: '/StockIn/LoadDataList',
                type: 'GET',
                data: {
                    page: tmx.vivablast.stockinManager.page(),
                    size: tmx.vivablast.stockinManager.pageSize(),
                    store: tmx.vivablast.stockinManager.getStore(),
                    poType: tmx.vivablast.stockinManager.getPoType(),
                    status: tmx.vivablast.stockinManager.getStatus(),
                    po: tmx.vivablast.stockinManager.getPoCode(),
                    supplier: tmx.vivablast.stockinManager.getSupplier(),
                    srv: tmx.vivablast.stockinManager.getSRV(),
                    stockCode: tmx.vivablast.stockinManager.getStockCode(),
                    stockName: tmx.vivablast.stockinManager.getStockName(),
                    fd: tmx.vivablast.stockinManager.getFD(),
                    td: tmx.vivablast.stockinManager.getTD(),
                    enable: '1'
                },
                datatype: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.stockinManager.registerEventIndexInList();
                    }
                }
            });
        },
        
        exportExcel: function () {
            var search = "page=" + tmx.vivablast.stockinManager.page();
            search += "&size=" + tmx.vivablast.stockinManager.pageSize();
            search += "&store=" + tmx.vivablast.stockinManager.getStore();
            search += "&poType=" + tmx.vivablast.stockinManager.getPoType();
            search += "&status=" + tmx.vivablast.stockinManager.getStatus();
            search += "&po=" + tmx.vivablast.stockinManager.getPoCode();
            search += "&supplier=" + tmx.vivablast.stockinManager.getSupplier();
            search += "&srv=" + tmx.vivablast.stockinManager.getSRV();
            search += "&stockCode=" + tmx.vivablast.stockinManager.getStockCode();
            search += "&stockName=" + tmx.vivablast.stockinManager.getStockName();
            search += "&fd=" + tmx.vivablast.stockinManager.getFD();
            search += "&td=" + tmx.vivablast.stockinManager.getTD();
            search += "&enable=1";
            document.location.href = "/StockIn/ExportToExcel?" + search;
        },
        
        getStore: function () {
            var store = $('#searchStore').val();
            store = store === "" ? 0 : store;
            return store;
        },
        
        getPoType: function () {
            var potype = $('#searchPeType').val();
            potype = potype === "" ? 0 : potype;
            return potype;
        },
        
        getStatus: function () {
            var value = $('#searchStatus').val();
            return value;
        },

        getPoCode: function () {
            var data = $('#searchPE').val();
            data = data === "" ? 0 : data;
            return data;
        },
        
        getSupplier: function () {
            var supplier = $('#searchSupplier').val();
            supplier = supplier === "" ? 0 : supplier;
            return supplier;
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
        
        loadLstProductSearch: function () {
            var poId = $('#ddlCreatePoCode').val();
            var temp = "";
            $('#LstFullfillmentDetail .vbcolum').each(function () {
                if (temp.length == 0) {
                    temp = $(this).find('.StockId').val();
                }
                else {
                    temp = temp + ';' + $(this).find('.StockId').val();
                }
            });
            var ids = temp;
            var storeId = $('#SearchProduct #searchProductSearchStore').val();
            var typeId = $('#SearchProduct #searchProductSearchType').val();
            var cate = $('#SearchProduct #searchProductSearchCategory').val();
            var stockCode = $('#SearchProduct #searchProductSearchStock').val();
            window.Helpers.ajaxHelper.getHtml({
                controller: 'Fulfillment',
                action: 'GetProductSearch',
                data: {
                    page: tmx.vivablast.stockinManager.getPageProductSearch,
                    pageSize: tmx.vivablast.stockinManager.getPageSizeProductSearch,
                    poId: poId,
                    ids: ids,
                    storeId: storeId,
                    typeId: typeId,
                    cate: cate,
                    stockCode: stockCode
                },
                success: function (data) {
                    if (data.length != 0) {
                        $('#searchProductDiv').empty().append(data);
                        tmx.vivablast.stockinManager.registerEventSearchProductFormList();
                    }
                },
                async: false
            });
        },
        
        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $(".pagination a:first").addClass("current");
                    tmx.vivablast.stockinManager.loadDataList(uid);
                }
            }

            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.stockinManager.loadDataList(uid);
            });

            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.stockinManager.loadDataList(uid);
            });

            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.stockinManager.exportExcel(uid);
            });
        },

        registerEventIndexInList: function () {
            $('#MasterList').dataTable({
                "sDom": "Rlfrtip",
                "bLengthChange": false,
                "bFilter": false,
                "bInfo": false,
                "bPaginate": false,
                "aaSorting": [[1, "desc"]],
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
                        url: '/StockIn/LoadDataDetailList',
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
                                tmx.vivablast.stockinManager.registerEventIndexInListDetail();
                            }
                        }
                    });
                }
                $(this).find(".arrow").toggleClass("up");
            });

            $('.pagination a').off("click").on("click", function () {
                $("a.current").removeClass("current");
                $(this).addClass("current");
                tmx.vivablast.stockinManager.loadDataList();
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