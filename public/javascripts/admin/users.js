$(document).ready(function() {
  var setupHeadClick = function() {
    $('a.change-head').click(function() {
      var elem = this;
      var row = $(elem).parent().parent().get(0);
      $.ajax({
        type: 'GET',
        url: $(elem).attr('href'),
        success: function(html) {
          $(row).before(html).remove();
          setupHeadClick();
        }
      });
      return false;
    });
  };

  setupHeadClick();
});

jQuery.ajaxSetup({'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");}});
