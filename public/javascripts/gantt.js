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

  var setupForm = function() {
    $('div.holiday-rejected-reason').hide();
    $('input#holiday_submit').attr('disabled', 'true');

    $('input#holiday_rejected_f').click(function() {
      $('div.holiday-rejected-reason').hide();
      $('input#holiday_submit').removeAttr('disabled');
    });

    $('input#holiday_rejected_t').click(function() {
      $('div.holiday-rejected-reason').show();
      $('input#holiday_submit').removeAttr('disabled');
    });
  };

  setupMonthClicks();
  setupForm();
});

jQuery.ajaxSetup({'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");}});
