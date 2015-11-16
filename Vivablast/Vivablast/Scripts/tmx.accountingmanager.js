$(document).ready(function () {
    tmx.vivablast.accountingManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.accountingManager = {
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
            $('#loading-indicator').hide();
            tmx.vivablast.accountingManager.registerEventIndex(uid);
        },

        loadAccounting: function () {
            $('#loading-indicator').show();
            window.Helpers.ajaxHelper.getHtml({
                controller: 'Accounting',
                action: 'LoadAccountingList',
                data: {
                    page: tmx.vivablast.accountingManager.page,
                    size: tmx.vivablast.accountingManager.pageSize,
                    typeAcc: tmx.vivablast.accountingManager.getTypeAcc(),
                    statusAcc: tmx.vivablast.accountingManager.getStatusAcc(),
                    sirv: tmx.vivablast.accountingManager.getSIRV(),
                    stock: tmx.vivablast.accountingManager.getStock(),
                    beginStore: tmx.vivablast.accountingManager.getFStore(),
                    endStore: tmx.vivablast.accountingManager.getTStore(),
                    project: tmx.vivablast.accountingManager.getProject(),
                    supplier: tmx.vivablast.accountingManager.getSupplier(),
                    po: tmx.vivablast.accountingManager.getPO(),
                    fd: tmx.vivablast.accountingManager.getFD(),
                    td: tmx.vivablast.accountingManager.getTD()
                },
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.accountingManager.registerEventIndexInList();
                        if ($('#searchStatus').val() === "3")
                        {
                            $('.AccCheck').attr("disabled", true);
                        }
                        $('#loading-indicator').hide();
                    }
                },
            });
        },
        
        exportExcel: function () {
            //$('#loading-indicator').show();
            var search = "page=" + tmx.vivablast.accountingManager.page();
            search += "&size=" + tmx.vivablast.accountingManager.pageSize();
            search += "&typeAcc=" + tmx.vivablast.accountingManager.getTypeAcc();
            search += "&statusAcc=" + tmx.vivablast.accountingManager.getStatusAcc();
            search += "&sirv=" + tmx.vivablast.accountingManager.getSIRV();
            search += "&stock=" + tmx.vivablast.accountingManager.getStock();
            search += "&beginStore=" + tmx.vivablast.accountingManager.getFStore();
            search += "&endStore=" + tmx.vivablast.accountingManager.getTStore();
            search += "&project=" + tmx.vivablast.accountingManager.getProject();
            search += "&supplier=" + tmx.vivablast.accountingManager.getSupplier();
            search += "&po=" + tmx.vivablast.accountingManager.getPO();
            search += "&fd=" + tmx.vivablast.accountingManager.getFD();
            search += "&td=" + tmx.vivablast.accountingManager.getTD();
            document.location.href = "/Accounting/ExportToExcel?" + search;
        },
        
        getTypeAcc: function () {
            var typeacc = $('#system #searchType').val();
            typeacc = typeacc === "" ? 0 : typeacc;
            return typeacc;
        },
        
        getStatusAcc: function () {
            var statusacc = $('#system #searchStatus').val();
            statusacc = statusacc === "" ? 0 : statusacc;
            return statusacc;
        },
        
        getSIRV: function() {
            return $('#system #searchSIRV').val();
        },
        
        getStock: function () {
            return $('#system #searchStock').val();
        },
        
        getFStore: function () {
            var fstore = $('#system #searchFStore').val();
            fstore = fstore === "" ? 0 : fstore;
            return fstore;
        },
        
        getTStore: function () {
            var tstore = $('#system #searchTStore').val();
            tstore = tstore === "" ? 0 : tstore;
            return tstore;
        },
        
        getProject: function () {
            var project = $('#system #searchProject').val();
            project = project === "" ? 0 : project;
            return project;
        },
        
        getSupplier: function () {
            var supplier = $('#system #searchSupplier').val();
            supplier = supplier === "" ? 0 : supplier;
            return supplier;
        },
            
        getPO: function () {
            return $('#system #searchPE').val();
        },
        
        getFD: function () {
            return $('#system #fromDate').val();
        },
        
        getTD: function () {
            return $('#system #toDate').val();
        },
        
        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $("#mycontent .pagination a:first").addClass("current");
                    tmx.vivablast.accountingManager.loadAccounting(uid);
                }
            }
            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $("#mycontent .pagination a:first").addClass("current");
                tmx.vivablast.accountingManager.loadAccounting(uid);
            });
            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $("#mycontent .pagination a:first").addClass("current");
                tmx.vivablast.accountingManager.loadAccounting(uid);
            });
            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.accountingManager.exportExcel(uid);
            });
        },

        registerEventIndexInList: function () {
            $('#ContentLst').dataTable({
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

            $('.pagination a').off("click").on("click", function () {
                $("a.current").removeClass("current");
                $(this).addClass("current");
                tmx.vivablast.accountingManager.loadAccounting();
            });
            
            $('#btnSave').off("click").on("click", function () {
                var arrChecks = [];
                $('table#ContentLst tbody tr input.AccCheck:checked').each(function() {
                    arrChecks.push({
                                Id: $(this).parents('tr').find('.hidId').val(),
                                SIRV: $(this).parents('tr').find('.hidSIRV').val(),
                                StockId: $(this).parents('tr').find('.hidStockId').val(),
                                Status: $(this).parents('tr').find('.hidSIRVFag').val()
                            });
                });
                
                var dataAccounting = {
                    ListAccountingUpdate: arrChecks
                };
                
                //console.log(arrChecks);
                $.ajax({
                    url: $('#hidSaveUrl').val(),
                    dataType: 'json',
                    contentType: 'application/json',
                    type: 'POST',
                    data: ko.toJSON(dataAccounting),
                    success: function (response) {
                        if (response.result == $('#hidSuccess').val()) {
                            tmx.vivablast.accountingManager.loadAccounting();
                        }
                        else {
                            alert('Save unsuccessful. Contact IT Support.');
                        }
                    }
                });
            });
        },
    };
})(jQuery, window.tmx = window.tmx || {});