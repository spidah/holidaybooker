$(document).ready(function() {
  var setupImageClicks = function() {
    $('a.change-head,a.change-admin').click(function() {
      var row = $(this).parent().parent().get(0);
      $.ajax({
        type: 'PUT',
        url: $(this).attr('href'),
        data: "authenticity_token=" + encodeURIComponent(AUTH_TOKEN),
        success: function(html) {
          $(row).before(html).remove();
          setupImageClicks();
        }
      });
      return false;
    });
  };

  setupImageClicks();
});

jQuery.ajaxSetup({'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");}});
