$(document).ready(function () {
    tmx.vivablast.reactiveStockManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.reactiveStockManager = {
        page: function () {
            var id = $("#mycontent .pagination a.current").html();
            if (typeof id === 'undefined') {
                id = 1;
            }
            return id;
        },
        pageSize: function () {
            var id = $("#mycontent #pageSize").val();
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
            tmx.vivablast.reactiveStockManager.loadReActiveStock(uid);
            tmx.vivablast.reactiveStockManager.registerEventIndex(uid);
        },

        loadReActiveStock: function () {
            $('#loading-indicator').show();
            window.Helpers.ajaxHelper.getHtml({
                controller: 'ReActiveStock',
                action: 'LoadStock',
                data: {
                    page: tmx.vivablast.reactiveStockManager.page,
                    size: tmx.vivablast.reactiveStockManager.pageSize,
                    stock: tmx.vivablast.reactiveStockManager.getSearch(),
                    store: tmx.vivablast.reactiveStockManager.getStore(),
                    type: tmx.vivablast.reactiveStockManager.getType(),
                    category: tmx.vivablast.reactiveStockManager.getCategory()
                },
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.reactiveStockManager.registerEventIndexInList();
                    }
                },
                async: false
            });
            $('#loading-indicator').hide();
        },

        exportExcel: function () {
            var search = "page=" + tmx.vivablast.reactiveStockManager.page();
            search += "&size=" + tmx.vivablast.reactiveStockManager.pageSize();
            search += "&stock=" + tmx.vivablast.reactiveStockManager.getSearch();
            search += "&store=" + tmx.vivablast.reactiveStockManager.getStore();
            search += "&type=" + tmx.vivablast.reactiveStockManager.getType();
            search += "&category=" + tmx.vivablast.reactiveStockManager.getCategory();
            document.location.href = "/ReActiveStock/ExportToExcel?" + search;
        },
        
        getSearch: function () {
            return $('#system #StockSearch').val();
        },

        getStore: function () {
            var result = $('#system #searchStore').val();
            result = result === "" ? 0 : result;
            return result;
            // return $('#system #searchStore').val();
            // return "2,3";
        },
        
        getType: function () {
            var result = $('#system #searchType').val();
            result = result === "" ? 0 : result;
            return result;
        },
        
        getCategory: function () {
            var result = $('#system #searchCategory').val();
            result = result === "" ? 0 : result;
            return result;
        },

        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $("#mycontent .pagination a:first").addClass("current");
                    tmx.vivablast.reactiveStockManager.loadReActiveStock(uid);
                }
            }
            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $("#mycontent .pagination a:first").addClass("current");
                tmx.vivablast.reactiveStockManager.loadReActiveStock(uid);
            });
            
            $('#searchType').on('change', function (e) {
                var url = "/ReActiveStock/LoadCategoryByType";
                $.ajax({
                    url: url,
                    data: { type: $(this).val() },
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
                $("#mycontent .pagination a:first").addClass("current");
                tmx.vivablast.reactiveStockManager.loadReActiveStock(uid);
            });
            
            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.reactiveStockManager.exportExcel(uid);
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
                        "aTargets": [-1] // <-- gets last column and turns off sorting
                    }
                ]
            });

            var onClickReActive = function () {
                var r = confirm("Are you sure Re-Active this stock!");
                if (r == true) {
                    $.ajax({
                        async: false,
                        url: $('#hidReActiveUrl').val(),
                        type: "POST",
                        data: {
                            condition: $(this).closest('tr').find('.ItemKey').text()
                        },
                        cache: false,
                        success: function (response) {
                            if (response.result === true) {
                                tmx.vivablast.reactiveStockManager.loadReActiveStock();
                            }
                            else if (response.result === false) {
                                alert("Can't Re-Active this stock. Please contact Administrator support.");
                            }
                        },
                        error: function () {
                            alert("Error: Please contact Administrator support.");
                        }
                    });
                }  
            };
            
            $('.btnReActive').off("click").on("click", onClickReActive);
            
            $('.pagination a').off("click").on("click", function () {
                $("a.current").removeClass("current");
                $(this).addClass("current");
                tmx.vivablast.reactiveStockManager.loadReActiveStock();
            });
        }
    };
})(jQuery, window.tmx = window.tmx || {});