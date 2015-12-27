$(document).ready(function () {
    tmx.vivablast.supManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.supManager = {
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
            tmx.vivablast.supManager.loadSupplier(uid);
            tmx.vivablast.supManager.registerEventIndex(uid);
            $("#StockCode").autocomplete({
                source: "/Stock/ListCode?term" + $("#StockCode").val()
            });

            $("#StockName").autocomplete({
                source: "/Stock/ListName?term" + $("#StockName").val()
            });

            $("#vSupplierName").autocomplete({
                source: "/Supplier/ListName?term" + $("#vSupplierName").val()
            });
        },

        loadSupplier: function () {
            $.ajax({
                url: '/Supplier/LoadSupplier',
                type: 'GET',
                data: {
                    page: tmx.vivablast.supManager.page,
                    size: tmx.vivablast.supManager.pageSize,
                    supplierType: tmx.vivablast.supManager.getSupType(),
                    supplierId: tmx.vivablast.supManager.getSupplierId(),
                    supplierName: tmx.vivablast.supManager.getSupplierName(),
                    stockCode: tmx.vivablast.supManager.getStockCode(),
                    stockName: tmx.vivablast.supManager.getStockName(),
                    country: tmx.vivablast.supManager.getCountry(),
                    market: tmx.vivablast.supManager.getMarket(),
                    enable: '1'
                },
                datatype: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.supManager.registerEventIndexInList();
                    }
                }
            });
            $('#loading-indicator').hide();
        },
        
        exportExcel: function () {
            //$('#loading-indicator').show();
            var search = "page=" + tmx.vivablast.supManager.page();
            search += "&size=" + tmx.vivablast.supManager.pageSize();
            search += "&supplierType=" + tmx.vivablast.supManager.getSupType();
            search += "&supplierId=" + tmx.vivablast.supManager.getSupplierId();
            search += "&supplierName=" + tmx.vivablast.supManager.getSupplierName();
            search += "&stockCode=" + tmx.vivablast.supManager.getStockCode();
            search += "&stockName=" + tmx.vivablast.supManager.getStockName();
            search += "&country=" + tmx.vivablast.supManager.getCountry();
            search += "&market=" + tmx.vivablast.supManager.getMarket();
            search += "&enable=1";
            document.location.href = "/Supplier/ExportToExcel?" + search;
        },
        
        getSupType: function () {
            var result = $('#searchType').val();
            result = result === "" ? 0 : result;
            return result;
        },
        
        getSupplierId: function () {
            var result = $('#Id').val();
            result = result === "" ? 0 : result;
            return result;
        },
        
        getSupplierName: function () {
            var result = $('#vSupplierName').val();
            return result;
        },

        getStockCode: function () {
            return $('#StockCode').val();
        },

        getStockName: function () {
            return $('#StockName').val();
        },
        
        getCountry: function () {
            var result = $('#searchCountry').val();
            result = result === "" ? 0 : result;
            return result;
        },
        
        getMarket: function () {
            var result = $('#searchMarket').val();
            result = result === "" ? 0 : result;
            return result;
        },
        
        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $(".pagination a:first").addClass("current");
                    tmx.vivablast.supManager.loadSupplier(uid);
                }
            }

            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.supManager.loadSupplier(uid);
            });

            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.supManager.loadSupplier(uid);
            });

            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.supManager.exportExcel(uid);
            });
        },

        registerEventIndexInList: function () {
            $('#SupplierLst').dataTable({
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
            
            $("#SupplierLst tr.vbcolum td:not(:first-child)").click(function () {
                if ($(this).parent().next("tr").hasClass("detail")) {
                    $(this).parent().next("tr").toggle();

                } else {
                    var id = $(this).closest('tr').find('.ItemKey').val();
                    var htmls = '<tr class="detail">' +
                                                '<td colspan="17">' +
                                                    '<div class="' + id + '"><div>' +
                                                '</td>' +
                                            '</tr>';
                    $(htmls).insertAfter($(this).closest('tr'));
                    $.ajax({
                        url: '/Supplier/LoadProductDetail',
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
                                tmx.vivablast.supManager.registerEventIndexInListDetail();
                            }
                        }
                    });
                }
                $(this).find(".arrow").toggleClass("up");
            });
            
            $('.pagination a').off("click").on("click", function () {
                $("a.current").removeClass("current");
                $(this).addClass("current");
                tmx.vivablast.supManager.loadSupplier();
            });

            $('.btn-danger').off("click").on("click", function () {
                var id = $(this).closest('tr').find('.ItemKey').val();
                var entityName = $(this).closest('tr').find('.SupplierName').text();
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
                                    tmx.vivablast.supManager.loadSupplier();
                                }
                                else if (response.result === $('#hidUnDelete').val()) {
                                    openErrorDialog({
                                        title: "Can not delete",
                                        data: "The supplier <b>" + entityName + "</b> has been used."
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
        registerEventIndexInListDetail: function () {
            $('.DetailLst').dataTable({
                "bDestroy": true
            });
        }
    };
})(jQuery, window.tmx = window.tmx || {});