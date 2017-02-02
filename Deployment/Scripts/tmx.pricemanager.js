$(document).ready(function () {
    tmx.vivablast.priceManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.priceManager = {
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
            tmx.vivablast.priceManager.loadPrice(uid);
            tmx.vivablast.priceManager.registerEventIndex(uid);
            $("#StockCode").autocomplete({
                source: "/Stock/ListCode?term" + $("#StockCode").val()
            });

            $("#StockName").autocomplete({
                source: "/Stock/ListName?term" + $("#StockName").val()
            });
        },

        loadPrice: function () {
            $.ajax({
                url: '/Price/LoadPrice',
                type: 'GET',
                data: {
                    page: tmx.vivablast.priceManager.page,
                    size: tmx.vivablast.priceManager.pageSize,
                    store: tmx.vivablast.priceManager.getStore(),
                    supplier: tmx.vivablast.priceManager.getSupplier(),
                    stockCode: tmx.vivablast.priceManager.getStockCode(),
                    stockName: tmx.vivablast.priceManager.getStockName(),
                    status: tmx.vivablast.priceManager.getStatus(),
                    fd: tmx.vivablast.priceManager.getFD(),
                    td: tmx.vivablast.priceManager.getTD(),
                    enable: '1'
                },
                datatype: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.priceManager.registerEventIndexInList();
                    }
                }
            });
        },
        
        exportExcel: function () {
            var search = "page=" + tmx.vivablast.priceManager.page();
            search += "&size=" + tmx.vivablast.priceManager.pageSize();
            search += "&store=" + tmx.vivablast.priceManager.getStore();
            search += "&supplier=" + tmx.vivablast.priceManager.getSupplier();
            search += "&stockCode=" + tmx.vivablast.priceManager.getStockCode();
            search += "&stockName=" + tmx.vivablast.priceManager.getStockName();
            search += "&status=" + tmx.vivablast.priceManager.getStatus();
            search += "&fd=" + tmx.vivablast.priceManager.getFD();
            search += "&td=" + tmx.vivablast.priceManager.getTD();
            search += "&enable=1";
            document.location.href = "/Price/ExportToExcel?" + search;
        },
        
        getStockCode: function () {
            return $('#StockCode').val();
        },

        getStockName: function () {
            return $('#StockName').val();
        },

        getStore: function () {
            var result = $('#searchStore').val();
            result = result === "" ? 0 : result;
            return result;
        },
        
        getSupplier: function () {
            var result = $('#searchSupplier').val();
            result = result === "" ? 0 : result;
            return result;
        },

        getStatus: function() {
            var result = $('#searchStatus').val();
            result = result === "" ? 0 : result;
            return result;
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
                    $("#mycontent .pagination a:first").addClass("current");
                    tmx.vivablast.priceManager.loadPrice(uid);
                }
            }
            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.priceManager.loadPrice(uid);
            });
            
            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.priceManager.loadPrice(uid);
            });
            
            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.priceManager.exportExcel(uid);
            });
        },

        registerEventIndexInList: function () {
            $('#PriceLst').dataTable({
                "sDom": "Rlfrtip",
                "bLengthChange": false,
                "bFilter": false,
                "bInfo": false,
                "bPaginate": false,
                "aaSorting": [[7, "asc"]],
                "aoColumnDefs": [
                    {
                        "bSortable": false,
                        "aTargets": [-1] // <-- gets last column and turns off sorting
                    }
                ]
            });

            $('.pagination a').off("click").on("click", function () {
                $("a.current").removeClass("current");
                $(this).addClass("current");
                tmx.vivablast.priceManager.loadPrice();
            });

            $('.btn-danger').off("click").on("click", function () {
                var id = $(this).closest('tr').find('.ItemKey').val();
                var entityName = $(this).closest('tr').find('.StockCode').text() + ':' + $(this).closest('tr').find('.PriceValue').text();
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
                                    tmx.vivablast.priceManager.loadPrice();
                                }
                                else if (response.result === $('#hidUnDelete').val()) {
                                    openErrorDialog({
                                        title: "Can not delete",
                                        data: "The price of <b>" + entityName + "</b> has been used."
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