$(document).ready(function () {
    tmx.vivablast.userManager.init();
});

(function ($, tmx) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};
    
    tmx.vivablast.userManager = {
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
            tmx.vivablast.userManager.loadUser(uid);
            tmx.vivablast.userManager.registerEventIndex(uid);
            $("#searchUser").autocomplete({
                source: "/User/ListUserName?term" + $("#searchUser").val()
            });
        },

        getSearch: function () {
            return $('#searchUser').val();
        },

        getDep: function () {
            return $('#searchDepartment').val();
        },

        getStore: function () {
            var store = $('#searchStore').val();
            store = store === "" ? 0 : store;
            return store;
        },
        
        loadUser: function () {
            $.ajax({
                url: '/User/LoadUser',
                type: 'GET',
                data: {
                    page: tmx.vivablast.userManager.page(),
                    size: tmx.vivablast.userManager.pageSize(),
                    user: tmx.vivablast.userManager.getSearch(),
                    department: tmx.vivablast.userManager.getDep(),
                    store: tmx.vivablast.userManager.getStore(),
                    fd: '',
                    td: '',
                    enable: '1'
                },
                datatype: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (data) {
                    if (data.length != 0) {
                        $('#list-session').empty().append(data);
                        tmx.vivablast.userManager.registerEventIndexInList();
                    }
                }
            });
        },
        
        exportExcel: function () {
            var search = "page=" + tmx.vivablast.userManager.page();
            search += "&size=" + tmx.vivablast.userManager.pageSize();
            search += "&user=" + tmx.vivablast.userManager.getSearch();
            search += "&department=" + tmx.vivablast.userManager.getDep();
            search += "&store=" + tmx.vivablast.userManager.getStore();
            search += "&fd=''";
            search += "&td=''";
            search += "&enable=1";
            document.location.href = "/User/ExportToExcel?" + search;
        },

        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $(".pagination a:first").addClass("current");
                    tmx.vivablast.userManager.loadUser(uid);
                }
            }
            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.userManager.loadUser(uid);
            });
            
            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.userManager.loadUser(uid);
            });
            
            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.userManager.exportExcel(uid);
            });
        },

        registerEventIndexInList: function () {
            $('#UserLst').dataTable({
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
                tmx.vivablast.userManager.loadUser();
            });

            $('.btn-danger').off("click").on("click", function () {
                var id = $(this).closest('tr').find('.ItemKey').val();
                var entityName = $(this).closest('tr').find('.UserName').text();
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
                                    tmx.vivablast.userManager.loadUser();
                                }
                                else if (response.result === $('#hidUnDelete').val()) {
                                    openErrorDialog({
                                        title: "Can not delete",
                                        data: "The user <b>" + entityName + "</b> has been used."
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