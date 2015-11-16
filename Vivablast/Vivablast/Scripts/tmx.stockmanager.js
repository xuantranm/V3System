$(document).ready(function () {
    tmx.vivablast.stockManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.stockManager = {
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
            tmx.vivablast.stockManager.loadStock(uid);
            tmx.vivablast.stockManager.registerEventIndex(uid);
            
            $("#StockCode").autocomplete({
                source: "/Stock/ListCode?term" + $("#StockCode").val()
            });

            $("#StockName").autocomplete({
                source: "/Stock/ListName?term" + $("#StockName").val()
            });

            $("#StockCode").on("keyup blur change", function (event) {
                var form = $(this).closest('form');
                if ($(this).val() != '' || $(this).val() != 'Not found') {
                    loadStockName(form,$(this),$('#StockName'));
                }
            });

            $("#StockName").on("keyup blur change", function (event) {
                var form = $(this).closest('form');
                if ($(this).val() != '' || $(this).val() != 'Not found') {
                    loadStockCode(form, $(this), $('#StockCode'));
                }
            });
        },

        loadStock: function () {
            if (tmx.vivablast.stockManager.pageSize() == 1000) {
                openYesNoDialog({
                    sectionTitle: "Load all data",
                    title: "Are you sure load all data. It will display slowly.",
                    data: '',
                    yesCallback: function() {
                        $.ajax({
                            url: '/Stock/LoadStock',
                            type: 'GET',
                            data: {
                                page: tmx.vivablast.stockManager.page(),
                                size: tmx.vivablast.stockManager.pageSize(),
                                stockCode: tmx.vivablast.stockManager.getStockCode(),
                                stockName: tmx.vivablast.stockManager.getStockName(),
                                store: tmx.vivablast.stockManager.getStore(),
                                type: tmx.vivablast.stockManager.getType(),
                                category: tmx.vivablast.stockManager.getCategory(),
                                enable: '1'
                            },
                            datatype: 'json',
                            contentType: 'application/json; charset=utf-8',
                            success: function (data) {
                                if (data.length != 0) {
                                    $('#list-session').empty().append(data);
                                    tmx.vivablast.stockManager.registerEventIndexInList();
                                }
                            }
                        });
                    },
                    noCallback: function() {

                    }
                });
            } else {
                $.ajax({
                    url: '/Stock/LoadStock',
                    type: 'GET',
                    data: {
                        page: tmx.vivablast.stockManager.page(),
                        size: tmx.vivablast.stockManager.pageSize(),
                        stockCode: tmx.vivablast.stockManager.getStockCode(),
                        stockName: tmx.vivablast.stockManager.getStockName(),
                        store: tmx.vivablast.stockManager.getStore(),
                        type: tmx.vivablast.stockManager.getType(),
                        category: tmx.vivablast.stockManager.getCategory(),
                        enable: '1'
                    },
                    datatype: 'json',
                    contentType: 'application/json; charset=utf-8',
                    success: function (data) {
                        if (data.length != 0) {
                            $('#list-session').empty().append(data);
                            tmx.vivablast.stockManager.registerEventIndexInList();
                        }
                    }
                });
            }
            
            if ($('#searchStore').val() != "") {
                $('.store' + $('#searchStore').val()).attr('style', 'display:block');
            } else {
                $('[class^=store]').attr('style', 'display:block');
            }
        },

        exportExcel: function () {
            var search = "page=" + tmx.vivablast.stockManager.page();
            search += "&size=" + tmx.vivablast.stockManager.pageSize();
            search += "&stockCode=" + tmx.vivablast.stockManager.getStockCode();
            search += "&stockName=" + tmx.vivablast.stockManager.getStockName();
            search += "&store=" + tmx.vivablast.stockManager.getStore();
            search += "&type=" + tmx.vivablast.stockManager.getType();
            search += "&category=" + tmx.vivablast.stockManager.getCategory();
            search += "&enable=" + "1";
            document.location.href = "/Stock/ExportToExcel?" + search;
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

        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $(".pagination a:first").addClass("current");
                    tmx.vivablast.stockManager.loadStock(uid);
                }
            }
            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.stockManager.loadStock(uid);
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
                        openErrorDialog({
                            title: "Can't load Category Data",
                            data: "Please contact Administrator support."
                        });
                    }
                });
            });
            
            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.stockManager.loadStock(uid);
            });

            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.stockManager.exportExcel(uid);
            });
        },

        registerEventIndexInList: function () {
            $('#StockLst').dataTable({
                "sDom": "Rlfrtip",
                "bLengthChange": false,
                "bFilter": false,
                "bInfo": false,
                "bPaginate": false,
                "aaSorting": [[1, "asc"]],
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
                tmx.vivablast.stockManager.loadStock();
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
                                    tmx.vivablast.stockManager.loadStock();
                                }
                                else if (response.result === $('#hidUnDelete').val()) {
                                    openErrorDialog({
                                        title: "Can not delete",
                                        data: "The stock <b>" + entityName + "</b> has been used."
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