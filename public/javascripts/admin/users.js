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

  var makeDepartmentsEditable = function() {
    $('.department').editable(function(value, settings) {
      $.ajax({
        type: 'PUT',
        url: $(settings.element).attr('title'),
        data: "department=" + value + "&authenticity_token=" + encodeURIComponent(AUTH_TOKEN),
        success: function(html) {
          $($(settings.element).parent().parent().get(0)).before(html).remove();
          makeDepartmentsEditable();
        }
      });
      return('Saving...');
    }, {
      data: DEPARTMENTS,
      type: 'select',
      placeholder: 'Click to set',
      submit: 'Ok'
    });
  };

  setupImageClicks();
  makeDepartmentsEditable();
});

jQuery.ajaxSetup({'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");}});
