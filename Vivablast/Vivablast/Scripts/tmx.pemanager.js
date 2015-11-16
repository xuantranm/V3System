$(document).ready(function () {
    tmx.vivablast.peManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.peManager = {
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
            tmx.vivablast.peManager.loadPe(uid);
            tmx.vivablast.peManager.registerEventIndex(uid);

            $("#POSearch").autocomplete({
                source: "/PE/ListCode?term" + $("#sCode").val()
            });

            $("#StockCode").autocomplete({
                source: "/Stock/ListCode?term" + $("#StockCode").val()
            });

            $("#StockName").autocomplete({
                source: "/Stock/ListName?term" + $("#StockName").val()
            });
            
            $("#MRFSearch").autocomplete({
                source: "/Requisition/ListCode?term" + $("#MRFSearch").val()
            });
        },

        loadPe: function () {
            $.ajax({
                url: '/Pe/LoadPo',
                type: 'GET',
                data: {
                    page: tmx.vivablast.peManager.page(),
                    size: tmx.vivablast.peManager.pageSize(),
                    store: tmx.vivablast.peManager.getStore(),
                    potype: tmx.vivablast.peManager.getPoType(),
                    po: tmx.vivablast.peManager.getPo(),
                    status: tmx.vivablast.peManager.getStatus(),
                    mrf: tmx.vivablast.peManager.getMrf(),
                    supplier: tmx.vivablast.peManager.getSupplier(),
                    project: tmx.vivablast.peManager.getProject(),
                    stockCode: tmx.vivablast.peManager.getStockCode(),
                    stockName: tmx.vivablast.peManager.getStockName(),
                    fd: tmx.vivablast.peManager.getFd(),
                    td: tmx.vivablast.peManager.getTd(),
                    enable: '1'
                },
                datatype: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.peManager.registerEventIndexInList();
                    }
                }
            });
        },

        exportExcel: function () {
            var search = "page=" + tmx.vivablast.peManager.page();
            search += "&size=" + tmx.vivablast.peManager.pageSize();
            search += "&store=" + tmx.vivablast.peManager.getStore();
            search += "&potype=" + tmx.vivablast.peManager.getPoType();
            search += "&po=" + tmx.vivablast.peManager.getPo();
            search += "&status=" + tmx.vivablast.peManager.getStatus();
            search += "&mrf=" + tmx.vivablast.peManager.getMrf();
            search += "&supplier=" + tmx.vivablast.peManager.getSupplier();
            search += "&project=" + tmx.vivablast.peManager.getProject();
            search += "&stockCode=" + tmx.vivablast.peManager.getStockCode();
            search += "&stockName=" + tmx.vivablast.peManager.getStockName();
            search += "&fd=" + tmx.vivablast.peManager.getFd();
            search += "&td=" + tmx.vivablast.peManager.getTd();
            search += "&enable=1";
            document.location.href = "/Pe/ExportToExcel?" + search;
        },

        getStore: function () {
            var result = $('#searchStore').val();
            result = result === "" ? 0 : result;
            return result;
        },

        getPoType: function () {
            var result = $('#poType').val();
            result = result === "" ? 0 : result;
            return result;
        },

        getPo: function () {
            return $('#POSearch').val();
        },

        getStatus: function () {
            return $('#searchStatus').val();
        },

        getMrf: function () {
            return $('#MRFSearch').val();
        },

        getSupplier: function () {
            var result = $('#supplier').val();
            result = result === "" ? 0 : result;
            return result;
        },

        getProject: function () {
            var result = $('#project').val();
            result = result === "" ? 0 : result;
            return result;
        },

        getStockCode: function () {
            return $('#StockCode').val();
        },

        getStockName: function () {
            return $('#StockName').val();
        },

        getFd: function () {
            if ($('#fromDate').val() != "") {
                var parts = $('#fromDate').val().split('/');
                var dmyDate = parts[1] + '/' + parts[0] + '/' + parts[2];
                return dmyDate;
            }
            return null;
        },

        getTd: function () {
            if ($('#toDate').val() != "") {
                var parts = $('#toDate').val().split('/');
                var dmyDate = parts[1] + '/' + parts[0] + '/' + parts[2];
                return dmyDate;
            }
            return null;
        },

        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $(".pagination a:first").addClass("current");
                    tmx.vivablast.peManager.loadPe(uid);
                }
            }

            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.peManager.loadPe(uid);
            });

            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.peManager.loadPe(uid);
            });

            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.peManager.exportExcel(uid);
            });
        },

        registerEventIndexInList: function () {
            $('#POLst').dataTable({
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

            $("#POLst tr.vbcolum td:not(:first-child)").click(function () {
                if ($(this).parent().next("tr").hasClass("detail")) {
                    $(this).parent().next("tr").toggle();

                } else {
                    var id = $(this).closest('tr').find('.ItemKey').val();
                    var htmls = '<tr class="detail">' +
                                                '<td colspan="14">' +
                                                    '<div class="' + id + '"><div>' +
                                                '</td>' +
                                            '</tr>';
                    $(htmls).insertAfter($(this).closest('tr'));
                    $.ajax({
                        url: '/Pe/LoadPeDetail',
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
                                tmx.vivablast.peManager.registerEventIndexInListDetail();
                            }
                        }
                    });
                }
                $(this).find(".arrow").toggleClass("up");
            });

            $('.pagination a').off("click").on("click", function () {
                $("a.current").removeClass("current");
                $(this).addClass("current");
                tmx.vivablast.peManager.loadPe();
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
                                    tmx.vivablast.peManager.loadPe();
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
            $('.DetailList').dataTable({
                "bDestroy": true
            });
        }
    };
})(jQuery, window.tmx = window.tmx || {});