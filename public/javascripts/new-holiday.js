$(document).ready(function() {
  var dateField = 0;
  var startDate = null;
  var endDate = null;

  var logmessage = function(message) {
    $('pre#logging-output').append(message + '\r\n');
  };

  var blankTime = function(date) {
    date.setMilliseconds(0);
    date.setSeconds(0);
    date.setMinutes(0);
    date.setHours(0);
  };

  var dateToStr = function(date) {
    return date.getYear().toString() + '-' + (date.getMonth() + 1 < 10 ? '0' : '') + (date.getMonth() + 1).toString() + '-' + (date.getDate() < 10 ? '0' : '') + date.getDate().toString();
  };

  var strToDate = function(dateStr, date) {
    arr = dateStr.split('-');
    date.setDate(new Number(arr[2]));
    date.setMonth(new Number(arr[1]) - 1);
    date.setFullYear(new Number(arr[0]));
    blankTime(date);
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
    blankTime(to);
  };

  var colourDays = function() {
    var index = new Date();
    index.setDate(1);
    index.setMonth(startDate.getMonth());
    index.setFullYear(startDate.getFullYear());
    blankTime(index);

    var elem;
    while (true) {
      elem = $('div[title=' + dateToStr(index) + ']');
      if (elem.length == 1 && (index >= startDate) && (index <= endDate)) {
        elem.addClass('selected');
      } else {
        elem.removeClass('selected');
      }
      index.setDate(index.getDate() + 1);
      if (index.getMonth() > endDate.getMonth()) {
        break;
      }
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
      strToDate(dstring, startDate);
      endDate = new Date();
      copyDates(endDate, startDate);
      dateField = 1;
    } else {
      endDate = new Date();
      strToDate(dstring, endDate);
      dateField = 0;
    }
    checkDates();
    colourDays();
    outputDates();
  };

  var setDayClicks = function() {
    $('div.day').click(function() {
      var date = $(this).attr('title');
      if (date) {
        setDateBoundary(date);
      }
    });
  };

  var setMonthClicks = function() {
    $('a.change-month').click(function() {
      date = $(this).attr('title');
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