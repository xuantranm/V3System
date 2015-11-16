$(document).ready(function () {
    tmx.vivablast.categorymanager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};

    tmx.vivablast.categorymanager = {
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
            tmx.vivablast.categorymanager.loadData(uid);
            tmx.vivablast.categorymanager.registerEventIndex(uid);
            
            $("#Code").autocomplete({
                source: "/Category/ListCode?term" + $("#Code").val()
            });
            $("#Name").autocomplete({
                source: "/Category/ListName?term" + $("#Name").val()
            });
        },

        loadData: function () {
            $.ajax({
                url: '/Category/LoadData',
                type: 'GET',
                data: {
                    page: tmx.vivablast.categorymanager.page,
                    size: tmx.vivablast.categorymanager.pageSize,
                    code: tmx.vivablast.categorymanager.getCode(),
                    name: tmx.vivablast.categorymanager.getName(),
                    type: tmx.vivablast.categorymanager.getType(),
                    enable: '1'
                },
                datatype: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.categorymanager.registerEventIndexInList();
                    }
                }
            });
        },

        exportExcel: function () {
            //$('#loading-indicator').show();
            var search = "page=" + tmx.vivablast.categorymanager.page();
            search += "&size=" + tmx.vivablast.categorymanager.pageSize();
            search += "&code=" + tmx.vivablast.categorymanager.getCode();
            search += "&name=" + tmx.vivablast.categorymanager.getName();
            search += "&type=" + tmx.vivablast.categorymanager.getType();
            search += "&enable=" + "1";
            document.location.href = "/Category/ExportToExcel?" + search;
        },
        
        getCode: function () {
            return $('#Code').val();
        },

        getName: function () {
            return $('#Name').val();
        },
        getType: function () {
            var data = $('#iType').val();
            data = data === "" ? 0 : data;
            return data;
        },
        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $("#mycontent .pagination a:first").addClass("current");
                    tmx.vivablast.categorymanager.loadData(uid);
                }
            }
            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $("#mycontent .pagination a:first").addClass("current");
                tmx.vivablast.categorymanager.loadData(uid);
            });
            
            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $("#mycontent .pagination a:first").addClass("current");
                tmx.vivablast.categorymanager.loadData(uid);
            });
            
            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.categorymanager.exportExcel(uid);
            });
        },

        registerEventIndexInList: function () {
            $('#DataLst').dataTable({
                "sDom": "Rlfrtip",
                "bLengthChange": false,
                "bFilter": false,
                "bInfo": false,
                "bPaginate": false,
                "aaSorting": [[1, "desc"]],
                "aoColumnDefs": [
                    {
                        "bSortable": false,
                        "aTargets": [0] // <-- -1 is gets last column and turns off sorting
                    }
                ]
            });

            $('.pagination a').off("click").on("click", function () {
                $("a.current").removeClass("current");
                $(this).addClass("current");
                tmx.vivablast.categorymanager.loadData();
            });
            
            $('.btn-danger').off("click").on("click", function () {
                var id = $(this).closest('tr').find('.ItemKey').val();
                var entityName = $(this).closest('tr').find('.EntityName').text();
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
                                    tmx.vivablast.categorymanager.loadData();
                                }
                                else if (response.result === $('#hidUnDelete').val()) {
                                    openErrorDialog({
                                        title: "Can not delete",
                                        data: "The category <b>" + entityName + "</b> has been used."
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
    };
})(jQuery, window.tmx = window.tmx || {});