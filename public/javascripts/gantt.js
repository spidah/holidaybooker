$(document).ready(function() {
  var setupMonthClicks = function() {
    $('a.change-month').click(function() {
      link = $(this).attr('href');
      $.ajax({
        type: 'GET',
        url: link,
        success: function(html) {
          $('#gantt').before(html).remove();
          setupMonthClicks();
        }
      });
      return false;
    });
  };

  setupMonthClicks();
});

jQuery.ajaxSetup({'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");}});
