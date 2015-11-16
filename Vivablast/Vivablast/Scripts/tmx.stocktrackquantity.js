$(document).ready(function() {
    tmx.vivablast.stockTrackQuantity.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || { };

    tmx.vivablast.stockTrackQuantity = {
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
        
        init: function(uid) {
            $('#loading-indicator').hide();
            tmx.vivablast.stockTrackQuantity.loadLstQtyMng(uid);
            tmx.vivablast.stockTrackQuantity.registerEventForm(uid);
            
            $("#StockCode").autocomplete({
                source: "/Stock/ListCode?term" + $("#StockCode").val()
            });

            $("#StockName").autocomplete({
                source: "/Stock/ListName?term" + $("#StockName").val()
            });

            $("#StockCode").on("keyup blur change", function (event) {
                var form = $(this).closest('form');
                if ($(this).val() != '' || $(this).val() != 'Not found') {
                    loadStockName(form, $(this), $('#StockName'));
                }
            });

            $("#StockName").on("keyup blur change", function (event) {
                var form = $(this).closest('form');
                if ($(this).val() != '' || $(this).val() != 'Not found') {
                    loadStockCode(form, $(this), $('#StockCode'));
                }
            });
        },

        loadLstQtyMng: function () {
            $.ajax({
                url: '/Stock/GetStockManagementQty',
                type: 'GET',
                data: {
                    page: tmx.vivablast.stockTrackQuantity.page(),
                    size: tmx.vivablast.stockTrackQuantity.pageSize(),
                    stockCode: tmx.vivablast.stockTrackQuantity.getStockCode(),
                    stockName: tmx.vivablast.stockTrackQuantity.getStockName(),
                    store: tmx.vivablast.stockTrackQuantity.getStore(),
                    type: tmx.vivablast.stockTrackQuantity.getType(),
                    category: tmx.vivablast.stockTrackQuantity.getCategory(),
                    fd: tmx.vivablast.stockTrackQuantity.getFD(),
                    td: tmx.vivablast.stockTrackQuantity.getTD(),
                    enable: '1'
                },
                datatype: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.stockTrackQuantity.registerEventList();
                    }
                }
            });
        },
        
        exportExcel: function () {
            var search = "page=" + tmx.vivablast.stockTrackQuantity.page();
            search += "&size=" + tmx.vivablast.stockTrackQuantity.pageSize();
            search += "&stockCode=" + tmx.vivablast.stockTrackQuantity.getStockCode();
            search += "&stockName=" + tmx.vivablast.stockTrackQuantity.getStockName();
            search += "&store=" + tmx.vivablast.stockTrackQuantity.getStore();
            search += "&type=" + tmx.vivablast.stockTrackQuantity.getType();
            search += "&category=" + tmx.vivablast.stockTrackQuantity.getCategory();
            search += "&fd=" + tmx.vivablast.stockTrackQuantity.getFD();
            search += "&td=" + tmx.vivablast.stockTrackQuantity.getTD();
            search += "&enable=" + "1";
            document.location.href = "/Stock/QtyExportToExcel?" + search;
        },
        
        getStockCode: function () {
            return $('#StockCode').val();
        },

        getStockName: function () {
            return $('#StockName').val();
        },

        getStore: function () {
            return $('#searchStore').val();
        },

        getType: function () {
            var result = $('#searchType').val();
            result = result === "" ? 0 : result;
            return result;
        },

        getCategory: function () {
            var result = $('#searchCategory').val();
            result = result === "" ? 0 : result;
            return result;
        },

        getFD: function () {
            return convertDateToMMDDYYYY($('#fromDate').val());
        },

        getTD: function () {
            return convertDateToMMDDYYYY($('#toDate').val());
        },

        registerEventForm: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $(".pagination a:first").addClass("current");
                    tmx.vivablast.stockTrackQuantity.loadLstQtyMng(uid);
                }
            }

            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.stockTrackQuantity.loadLstQtyMng(uid);
            });

            $('#searchType').on('change', function (e) {
                var typeId = 0;
                if ($('#searchType').val() !== "") {
                    typeId = $('#searchType').val();
                }
                var url = "/Stock/LoadCategoryByType";
                $.ajax({
                    url: url,
                    data: { type: typeId },
                    cache: false,
                    type: "POST",
                    success: function (data) {
                        var markup = "<option value=''>All</option>";
                        for (var x = 0; x < data.length; x++) {
                            markup += "<option value=" + data[x].Value + ">" + data[x].Text + "</option>";
                        }
                        $("#searchCategory").html(markup);
                        $("#searchCategory").trigger("chosen:updated");
                    },
                    error: function () {
                        alert("Error: Can't load Category Data.Please contact Administrator support.");
                    }
                });
            });

            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.stockTrackQuantity.loadLstQtyMng(uid);
            });

            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.stockTrackQuantity.exportExcel(uid);
            });
        },
        
        registerEventList: function () {
            $('#StockQtyManageLst').dataTable({
                "sDom": "Rlfrtip",
                "bAutoWidth": false,
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
            
            $('.pagination a').off("click").on("click", function () {
                $("a.current").removeClass("current");
                $(this).addClass("current");
                tmx.vivablast.stockTrackQuantity.loadLstQtyMng();
            });
        }
    };
})(jQuery, window.tmx = window.tmx || { });