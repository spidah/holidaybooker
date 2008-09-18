$(document).ready(function() {
  var dateField = 0;
  var startDate = null;
  var endDate = null;

  var logmessage = function(message) {
    $('pre#logging-output').append(message + '\r\n');
  };

  var dateToStr = function(date) {
    return (date.getDate() < 10 ? '0' : '') + date.getDate().toString() +
      (date.getMonth() + 1 < 10 ? '0' : '') + (date.getMonth() + 1).toString() + date.getYear().toString();
  };

  var checkDates = function() {
    if (startDate > endDate) {
      var tmp = new Date();
      copyDates(tmp, startDate);
      copyDates(startDate, endDate);
      copyDates(endDate, tmp);
    }
  };

  var copyDates = function(to, from) {
    to.setDate(from.getDate());
    to.setMonth(from.getMonth());
    to.setFullYear(from.getFullYear());
  };

  var colourDays = function() {
    var index = new Date();
    index.setDate(1);
    index.setMonth(startDate.getMonth());
    index.setFullYear(startDate.getFullYear());

    var selectedNumber = 0;
    var notSelectedNumber = 0;

    var elem;
    while (true) {
      elem = $('div#' + dateToStr(index));
      if (elem && (index >= startDate) && (index <= endDate)) {
        selectedNumber++;
        elem.addClass('selected');
      } else {
        notSelectedNumber++;
        elem.removeClass('selected');
      }
      index.setDate(index.getDate() + 1);
      if (index.getMonth() > endDate.getMonth())
        break;
    }
  };

  var outputDates = function() {
    $('span.start-date').text(startDate ? startDate.toDateString() : '');
    $('span.end-date').text(endDate ? endDate.toDateString() : '');
  };

  var setDateBoundary = function(date) {
    var dstring = date.toString();
    if (dateField == 0) {
      startDate = new Date();
      startDate.setDate(new Number(dstring.substr(0, 2)));
      startDate.setMonth(new Number(dstring.substr(2, 2)) - 1);
      startDate.setFullYear(new Number(dstring.substr(4)));
      endDate = new Date();
      copyDates(endDate, startDate);
      dateField = 1;
    } else {
      endDate = new Date();
      endDate.setDate(new Number(dstring.substr(0, 2)));
      endDate.setMonth(new Number(dstring.substr(2, 2)) - 1);
      endDate.setFullYear(new Number(dstring.substr(4)));
      dateField = 0;
    }
    colourDays();
    outputDates();
  };

  var setDayClicks = function() {
    $('div.day').click(function() {
      var date = $(this).attr('id');
      if (date) {
        setDateBoundary(date);
      }
    });
  };

  var setMonthClicks = function() {
    $('a.change-month').click(function() {
      date = $(this).attr('id');
      $.ajax({
        type: 'GET',
        url: '/holidays/change_month',
        data: 'date=' + date,
        success: function(html) {
          $('#calendar').html(html);
          setDayClicks();
          setMonthClicks();
          colourDays();
        }
      });
      return false;
    });
  };

  setDayClicks();
  setMonthClicks();
});

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");}
});