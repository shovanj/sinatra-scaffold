function deleteRecord(table, record_id) {
    $.ajax({
      type: "DELETE",
      url: table + '/' + record_id,
      success: function (response) {
          $(".alert-error").hide();
          $('tr#record_'+ record_id).hide();
      },
      error:function (request, status, error) {
          $(".alert-error").html("Record could be deleted. Please check server log.").show();
      },
    });
}

$(document).ready(function() {
    $('.delete_link').click(function(){
        if (confirm("Are you sure you want to delete?")){
            var record_id = $(this).attr('data-id');
            var table = $(this).attr('data-table');
            deleteRecord(table, record_id);
            return true;
        }
    });
});
