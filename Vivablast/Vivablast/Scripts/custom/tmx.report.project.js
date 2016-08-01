$(document).ready(function () {
    tmx.vivablast.reportProjectManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};
    
    tmx.vivablast.reportProjectManager = {
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
            tmx.vivablast.reportProjectManager.loadReport(uid);
            tmx.vivablast.reportProjectManager.registerEventIndex(uid);
        },
        
        loadReport: function () {
            var fd = convertDateToMMDDYYYY($('#fromDate').val());
            var td = convertDateToMMDDYYYY($('#toDate').val());
            if (fd != null && td != null && Date.parse(fd) > Date.parse(td)) {
                $('#list-session').empty();
                openErrorDialog({
                    title: "Can not search",
                    data: "The from date <b>" + $('#fromDate').val() + "</b> is greater than to date <b>" + $('#toDate').val() + "</b>."
                });
            }
            else {
                var url;
                if ($("#groupingItems").is(':checked')) {
                    url = '/report/loaddynamicprojectgroupitems';
                } else {
                    url = '/report/loaddynamicproject';
                }
                $.ajax({
                    url: url,
                    type: 'GET',
                    data: {
                        page: page(),
                        size: size(),
                        projectId: $('#searchProjectCode').val(),
                        stockTypeId: ($('#searchStockType').val() === "") ? 0 : $('#searchStockType').val(),
                        categoryId: ($('#searchStockCategory').val() === "") ? 0 : $('#searchStockCategory').val(),
                        stockCode: $('#searchStockCode').val(),
                        stockName: $('#searchStockName').val(),
                        actionFag: $('#searchAction').val(),
                        supplierId: $('#searchSupplier').val(),
                        fd: fd,
                        td: td
                    },
                    datatype: 'json',
                    contentType: 'application/json; charset=utf-8',
                    success: function (data) {
                        if (data.length != 0) {
                            $('#list-session').empty().append(data);
                            tmx.vivablast.reportProjectManager.registerEventIndexInList();
                        }
                    }
                });
            }
        },

        exportExcel: function () {
            var search = "&page=" + page();
            search += "&size=" + size();
            search += "&poType=" + $('#searchPoType').val();
            search += "&po=" + $('#searchPoCode').val(),
            search += "&stockType=" + $('#searchStockType').val();
            search += "&category=" + $('#searchStockCategory').val();
            search += "&stockCode=" + $('#searchStockCode').val();
            search += "&stockName=" + $('#searchStockName').val();
            search += "&fd=" + convertDateToMMDDYYYY($('#fromDate').val());
            search += "&td=" + convertDateToMMDDYYYY($('#toDate').val());
            document.location.href = "/report/exporttoexcel?" + search;
        },
        
        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $(".pagination a:first").addClass("current");
                    tmx.vivablast.reportProjectManager.loadReport(uid);
                }
            }

            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.reportProjectManager.loadReport(uid);
            });
            
            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.reportProjectManager.loadReport(uid);
            });
            
            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.reportProjectManager.exportExcel(uid);
            });

            $('#searchProjectName').val($('#searchProjectCode').val());

            $('#searchProjectCode').on('change', function (e) {
                $('#searchProjectName').val($('#searchProjectCode').val());
            });

            $('#searchProjectName').on('change', function (e) {
                $('#searchProjectCode').val($('#searchProjectName').val());
            });
        },

        registerEventIndexInList: function () {
            $('#reportLst').dataTable({
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
                tmx.vivablast.reportProjectManager.loadReport();
            });
        },
    };
})(jQuery, window.tmx = window.tmx || {});