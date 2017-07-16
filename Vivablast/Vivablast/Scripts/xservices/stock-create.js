var form = $('form');
$(document).ready(function () {
    $('#Entity_StoreId').on('change', function (e) {
        if ($(this).val() > 0) {
            $('#Entity_Store').val($("option:selected", this).text());
        } else {
            $('#Entity_Store').val('');
        }
    });

    $('#Entity_iType').on('change', function (e) {
        if ($(this).val() > 0) {
            $('#Entity_Type').val($("option:selected", this).text());
        } else {
            $('#Entity_Type').val('');
        }

        loadCategory($(this).val());
        loadStock($(this).val(), 0);
        loadUnit($(this).val());
        //loadLabel($(this).val());
    });


    $('#Entity_vStockID').autocomplete({
        source: "/autocomplete/liststockcode?term" + $("#vStockName").val(),
    });

    $("#Entity_vStockName").autocomplete({
        source: "/autocomplete/liststockname?term" + $("#Entity_vStockName").val(),
    });

    
    $('#Entity_bCategoryID').on('change', function (e) {
        if ($(this).val() > 0) {
            $('#Entity_Category').val($("option:selected", this).text());
        } else {
            $('#Entity_Category').val('');
        }
    });

    $('#Entity_bUnitID').on('change', function (e) {
        if ($(this).val() > 0) {
            $('#Entity_Unit').val($("option:selected", this).text());
        } else {
            $('#Entity_Unit').val('');
        }
    });

    $('#Entity_bPositionID').on('change', function (e) {
        if ($(this).val() > 0) {
            $('#Entity_Position').val($("option:selected", this).text());
        } else {
            $('#Entity_Position').val('');
        }
    });

    $(document).keypress(function (e) {
        if (e.which == 13) {
            // submit
        }
    });
});

function loadStock(typeId, categoryId) {
    var url = "/autocomplete/LoadStockCodeByType";
    $.ajax({
        url: url,
        data: { type: typeId, category: categoryId },
        cache: false,
        type: "POST",
        success: function (data) {
            $("#Entity_vStockID").val(data);
        },
        error: function () {
            alert("Error: Can't load Stock Code.Please contact Administrator support.");
        }
    });
}

function loadCategory(typeId) {
    var url = "/autocomplete/LoadCategoryByType";
    $.ajax({
        url: url,
        data: { type: typeId },
        cache: false,
        type: "POST",
        success: function (data) {
            var markup = "<option value=''>Select</option>";
            for (var x = 0; x < data.length; x++) {
                markup += "<option value=" + data[x].Value + ">" + data[x].Text + "</option>";
            }
            $("#Entity_bCategoryID").html(markup);
            $("#Entity_bCategoryID").trigger("chosen:updated");
        },
        error: function () {
            alert("Error: Can't load Category Data.Please contact Administrator support.");
        }
    });
}
        
function loadUnit(typeId) {
    var url = "/autocomplete/LoadUnitByType";
    $.ajax({
        url: url,
        data: { type: typeId },
        cache: false,
        type: "POST",
        success: function (data) {
            var markup = "<option value=''>Select</option>";
            for (var x = 0; x < data.length; x++) {
                markup += "<option value=" + data[x].Value + ">" + data[x].Text + "</option>";
            }
            $("#Entity_bUnitID").html(markup);
            $("#Entity_bUnitID").trigger("chosen:updated");
        },
        error: function () {
            alert("Error: Can't load Category Data.Please contact Administrator support.");
        }
    });
}
        
//function loadLabel(typeId) {
//    var url = "/Stock/LoadLabelByType";
//    $.ajax({
//        url: url,
//        data: { type: typeId },
//        cache: false,
//        type: "POST",
//        success: function (data) {
//            var markup = "<option value=''>Select</option>";
//            for (var x = 0; x < data.length; x++) {
//                markup += "<option value=" + data[x].Value + ">" + data[x].Text + "</option>";
//            }
//            $("#bLabelID").html(markup);
//            $("#bLabelID").trigger("chosen:updated");
//        },
//        error: function () {
//            alert("Error: Can't load Category Data.Please contact Administrator support.");
//        }
//    });
//}