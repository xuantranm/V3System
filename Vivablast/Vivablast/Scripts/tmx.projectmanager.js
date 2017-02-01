$(document).ready(function () {
    tmx.vivablast.projectManager.init();
});

(function ($, tmx, undefined) {
    /** ensure tmx.vivablast is variable */
    tmx.vivablast = tmx.vivablast || {};
    
    tmx.vivablast.projectManager = {
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
            tmx.vivablast.projectManager.loadProject(uid);
            tmx.vivablast.projectManager.registerEventIndex(uid);
            $("#projectCode").autocomplete({
                source: "/Project/ListCode?term" + $("#projectCode").val()
            });
            $("#projectName").autocomplete({
                source: "/Project/ListName?term" + $("#projectName").val()
            });
        },
        
        getProjectCode: function () {
            return $('#projectCode').val();
        },
        
        getProjectName: function () {
            return $('#projectName').val();
        },
        
        getCountry: function () {
            var country = $('#projectCountry').val();
            country = country === "" ? 0 : country;
            return country;
        },
        
        getStatus: function () {
            var country = $('#projectStatus').val();
            country = country === "" ? 0 : country;
            return country;
        },
        
        getClient: function () {
            var client = $('#projectClient').val();
            client = client === "" ? 0 : client;
            return client;
        },
        
        getFD: function () {
            return convertDateToMMDDYYYY($('#fromDate').val());
        },

        getTD: function () {
            return convertDateToMMDDYYYY($('#toDate').val());
        },
        
        loadProject: function () {
            var fd = tmx.vivablast.projectManager.getFD();
            var td = tmx.vivablast.projectManager.getTD();
            if (fd != null && td != null && Date.parse(fd) > Date.parse(td)) {
                $('#list-session').empty();
                openErrorDialog({
                    title: "Can not search",
                    data: "The from date <b>" + $('#fromDate').val() + "</b> is greater than to date <b>" + $('#toDate').val() + "</b>."
                });
            }
            else {
                $.ajax({
                    url: '/Project/LoadProject',
                    type: 'GET',
                    data: {
                        page: tmx.vivablast.projectManager.page(),
                        size: tmx.vivablast.projectManager.size(),
                        projectCode: tmx.vivablast.projectManager.getProjectCode(),
                        projectName: tmx.vivablast.projectManager.getProjectName(),
                        country: tmx.vivablast.projectManager.getCountry(),
                        status: tmx.vivablast.projectManager.getStatus(),
                        client: tmx.vivablast.projectManager.getClient(),
                        fd: fd,
                        td: td,
                        enable: '1'
                    },
                    datatype: 'json',
                    contentType: 'application/json; charset=utf-8',
                    success: function (data) {
                        if (data.length != 0) {
                            $('#list-session').empty().append(data);
                            tmx.vivablast.projectManager.registerEventIndexInList();
                        }
                    }
                });
            }
        },

        exportExcel: function () {
            //$('#loading-indicator').show();
            var search = "&page=" + tmx.vivablast.projectManager.page();
            search += "&size=" + tmx.vivablast.projectManager.size();
            search += "&projectCode=" + tmx.vivablast.projectManager.getProjectCode();
            search += "&projectName=" + tmx.vivablast.projectManager.getProjectName();
            search += "&country=" + tmx.vivablast.projectManager.getCountry();
            search += "&status=" + tmx.vivablast.projectManager.getStatus();
            search += "&client=" + tmx.vivablast.projectManager.getClient();
            search += "&fd=" + tmx.vivablast.projectManager.getFD();
            search += "&td=" + tmx.vivablast.projectManager.getTD();
            search += "&enable=1";
            document.location.href = "/Project/ExportToExcel?" + search;
        },
        
        registerEventIndex: function (uid) {
            document.onkeypress = enter;
            function enter(e) {
                if (e.which == 13) {
                    $("a.current").removeClass("current");
                    $(".pagination a:first").addClass("current");
                    tmx.vivablast.projectManager.loadProject(uid);
                }
            }
            $('#pageSize', uid).on('change', function (e) {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.projectManager.loadProject(uid);
            });
            
            $('#btnSearch', uid).off('click').on('click', function () {
                $("a.current").removeClass("current");
                $(".pagination a:first").addClass("current");
                tmx.vivablast.projectManager.loadProject(uid);
            });
            
            $('#btnExport', uid).off('click').on('click', function () {
                tmx.vivablast.projectManager.exportExcel(uid);
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
                tmx.vivablast.projectManager.loadProject();
            });
            
            $('.btn-danger').off("click").on("click", function () {
                var id = $(this).closest('tr').find('.ItemKey').val();
                var entityName = $(this).closest('tr').find('.ProjectCode').text();
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
                                    tmx.vivablast.projectManager.loadProject();
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