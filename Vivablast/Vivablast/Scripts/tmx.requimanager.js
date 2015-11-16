$(document).ready(function () {
    tmx.vivablast.requiManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.requiManager = {
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
            tmx.vivablast.requiManager.loadRequisition(uid);
            tmx.vivablast.requiManager.registerEventIndex(uid);
            
            $("#searchMRF").autocomplete({
                source: "/Requisition/ListCode?term" + $("#searchMRF").val()
            });

            $("#StockCode").autocomplete({
                source: "/Stock/ListCode?term" + $("#StockCode").val()
            });

            $("#StockName").autocomplete({
                source: "/Stock/ListName?term" + $("#StockName").val()
            });
        },

        loadRequisition: function () {
            $.ajax({
                url: '/Requisition/LoadRequisition',
                type: 'GET',
                data: {
                    page: tmx.vivablast.requiManager.page(),
                    size: tmx.vivablast.requiManager.pageSize(),
                    store: tmx.vivablast.requiManager.getStore(),
                    mrf: tmx.vivablast.requiManager.getMrf(),
                    stockCode: tmx.vivablast.requiManager.getStockCode(),
                    stockName: tmx.vivablast.requiManager.getStockName(),
                    status: tmx.vivablast.requiManager.getStatus(),
                    fd: tmx.vivablast.requiManager.getFD(),
                    td: tmx.vivablast.requiManager.getTD(),
                    enable: '1'
                },
                datatype: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.requiManager.registerEventIndexInList();
                    }
                }
            });
        },

        exportExcel: function () {
            var search = "page=" + tmx.vivablast.requiManager.page();
            search += "&size=" + tmx.vivablast.requiManager.pageSize();
            search += "&store=" + tmx.vivablast.requiManager.getStore();
            search += "&mrf=" + tmx.vivablast.requiManager.getMrf();
            search += "&stockCode=" + tmx.vivablast.requiManager.getStockCode();
            search += "&stockName=" + tmx.vivablast.requiManager.getStockName();
            search += "&status=" + tmx.vivablast.requiManager.getStatus();
            search += "&fd=" + tmx.vivablast.requiManager.getFD();
            search += "&td=" + tmx.vivablast.requiManager.getTD();
            search += "&enable=1";
            document.location.href = "/Requisition/ExportToExcel?" + search;
        },
        
        getStore: function () {
            var result = $('#searchStore').val();
            result = result === "" ? 0 : result;
            return result;
        },

        getMrf: function () {
            return $('#searchMRF').val();
        },

        getStockCode: function () {
            return $('#StockCode').val();
        },

        getStockName: function () {
            return $('#StockName').val();
        },

        getStatus: function () {
            return $('#searchStatus').val();
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
                    tmx.vivablast.requiManager.loadRequisition(uid);
                }
            }
            
            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.requiManager.loadRequisition(uid);
            });
            
            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.requiManager.loadRequisition(uid);
            });
            
            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.requiManager.exportExcel(uid);
            });
        },

        registerEventIndexInList: function () {
            $('#RequisitionLst').dataTable({
                "sDom": "Rlfrtip",
                "bLengthChange": false,
                "bFilter": false,
                "bInfo": false,
                "bPaginate": false,
                "aaSorting": [[2, "desc"]],
                "aoColumnDefs": [
                    {
                        "bSortable": false,
                        "aTargets": [0] // <-- -1 gets last column and turns off sorting
                    }
                ]
            });

            $("#RequisitionLst tr.vbcolum td:not(:first-child)").click(function () {
                if ($(this).parent().next("tr").hasClass("detail")) {
                    $(this).parent().next("tr").toggle();
                    
                } else {
                    var id = $(this).closest('tr').find('.ItemKey').val();
                    var htmls = '<tr class="detail">' +
                                                '<td colspan="15">' +
                                                    '<div class="'+id+'"><div>' +
                                                '</td>' +
                                            '</tr>';
                    $(htmls).insertAfter($(this).closest('tr'));
                    
                    $.ajax({
                        url: '/Requisition/LoadRequisitionDetail',
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
                                tmx.vivablast.requiManager.registerEventIndexInListDetail();
                            }
                        }
                    });
                }
                $(this).find(".arrow").toggleClass("up");
            });
            
            $('.pagination a').off("click").on("click", function () {
                $("a.current").removeClass("current");
                $(this).addClass("current");
                tmx.vivablast.requiManager.loadRequisition();
            });

            $('.btn-danger').off("click").on("click", function () {
                var id = $(this).closest('tr').find('.ItemKey').val();
                openYesNoDialog({
                    sectionTitle: "Delete",
                    title: "Are you sure delete <b>" + $(this).closest('tr').find('.MainEntity').text() + "</b>.",
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
                                    tmx.vivablast.requiManager.loadRequisition();
                                }
                                else if (response.result === $('#hidUnDelete').val()) {
                                    alert("Delete unsuccessful. This record has used.");
                                }
                            },
                            error: function () {
                                alert("Error: Please contact Administrator support.");
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