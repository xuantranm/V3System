$(document).ready(function () {
    tmx.vivablast.projectDetail.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};
    
    tmx.vivablast.projectDetail = {
        page: function () {
            var id = $(".pagination a.current").html();
            if (typeof id === 'undefined') {
                id = 1;
            }
            return id;
        },
        size: function () {
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
            tmx.vivablast.projectDetail.loadTransactionStock(uid);
            tmx.vivablast.projectDetail.registerEventIndex(uid);
        },

        getProject: function () {
            return $('#Id').val();
        },

        getType: function () {
            return $('#type').val();
        },

        getFD: function () {
            return convertDateToMMDDYYYY($('#fromDate').val());
        },

        getTD: function () {
            return convertDateToMMDDYYYY($('#toDate').val());
        },
        
        loadTransactionStock: function () {
            var fd = tmx.vivablast.projectDetail.getFD();
            var td = tmx.vivablast.projectDetail.getTD();
            if (fd != null && td != null && Date.parse(fd) > Date.parse(td)) {
                $('#list-session').empty();
                openErrorDialog({
                    title: "Can not search",
                    data: "The from date <b>" + $('#fromDate').val() + "</b> is greater than to date <b>" + $('#toDate').val() + "</b>."
                });
            }
            else {
                $.ajax({
                    url: '/Project/TransactionStock',
                    type: 'GET',
                    data: {
                        page: tmx.vivablast.projectDetail.page(),
                        size: tmx.vivablast.projectDetail.size(),
                        project: tmx.vivablast.projectDetail.getProject(),
                        type: tmx.vivablast.projectDetail.getType(),
                        fd: fd,
                        td: td
                    },
                    datatype: 'json',
                    contentType: 'application/json; charset=utf-8',
                    success: function (data) {
                        if (data.length != 0) {
                            $('#list-session').empty().append(data);
                            tmx.vivablast.projectDetail.registerEventIndexInList();
                        }
                    }
                });
            }
        },

        exportExcel: function () {
            //$('#loading-indicator').show();
            var search = "&page=" + tmx.vivablast.projectDetail.page();
            search += "&size=" + tmx.vivablast.projectDetail.size();
            search += "&project=" + tmx.vivablast.projectDetail.getProject();
            search += "&type=" + tmx.vivablast.projectDetail.getType();
            search += "&fd=" + tmx.vivablast.projectDetail.getFD();
            search += "&td=" + tmx.vivablast.projectDetail.getTD();
            document.location.href = "/Project/ExportTransactionStock?" + search;
        },
        
        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $(".pagination a:first").addClass("current");
                    tmx.vivablast.projectDetail.loadTransactionStock(uid);
                }
            }
            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.projectDetail.loadTransactionStock(uid);
            });
            
            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.projectDetail.loadTransactionStock(uid);
            });
            
            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.projectDetail.exportExcel(uid);
            });
        },

        registerEventIndexInList: function () {
            $('#List').dataTable({
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
                tmx.vivablast.projectDetail.loadTransactionStock();
            });
        },
    };
})(jQuery, window.tmx = window.tmx || {});