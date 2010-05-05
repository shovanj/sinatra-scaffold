$(document).ready(function(){
  // alternate colors
  $("#table tr:even").addClass("eventr");;
  $("#table tr:odd").addClass("oddtr");

  $("#search_link").click(function () {
    $("#search_area").toggle();
  });
});
