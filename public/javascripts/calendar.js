$(document).ready(function() {
  var dateField = 0;
  var originalStartDate = null;
  var originalEndDate = null;
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

  var strToDate = function(dateStr) {
    arr = dateStr.split('-');
    date = new Date();
    date.setDate(new Number(arr[2]));
    date.setMonth(new Number(arr[1]) - 1);
    date.setFullYear(new Number(arr[0]));
    blankTime(date);
    return date;
  };

  var getDayDiv = function(date) {
    if (typeof date == 'object') {
      date = dateToStr(date);
    }
    return $('div[title=' + date + ']');
  };

  var checkDates = function() {
    if (startDate > endDate) {
      var tmp = new Date();
      copyDate(tmp, startDate);
      copyDate(startDate, endDate);
      copyDate(endDate, tmp);
    }
  };

  var copyDate = function(to, from) {
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
      elem = getDayDiv(index);
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

  var clearDays = function() {
    $('div[title*=-]').removeClass('selected');
  };

  var outputDates = function() {
    $('span.start-date').text(startDate ? startDate.toDateString() : '');
    $('span.end-date').text(endDate ? endDate.toDateString() : '');
    $('input#holiday_start_date').attr('value', startDate ? dateToStr(startDate) : '');
    $('input#holiday_end_date').attr('value', endDate ? dateToStr(endDate) : '');
  };

  var checkForConfirmed = function() {
    var index = new Date();
    copyDate(index, startDate);

    var elem;
    while (index <= endDate) {
      elem = getDayDiv(index);

      if (elem.hasClass('confirmed')) {
        return true;
      }
      index.setDate(index.getDate() + 1);
    }
    return false;
  };

  var setDateBoundary = function(date) {
    if (dateField == 0) {
      startDate = new Date();
      copyDate(startDate, date);
      endDate = new Date();
      copyDate(endDate, startDate);
      dateField = 1;
    } else {
      endDate = new Date();
      copyDate(endDate, date);
      dateField = 0;
    }
    checkDates();
    if (checkForConfirmed()) {
      dateField = 1;
      copyDate(startDate, date);
      copyDate(endDate, date);
    }
    colourDays();
    outputDates();
    showResetLink();
    enableFormSubmit();
  };

  var setDayClicks = function() {
    $('div.day').click(function() {
      if ($(this).hasClass('disabled') || $(this).hasClass('confirmed'))
        return;
      var date = $(this).attr('title');
      if (date) {
        setDateBoundary(strToDate(date));
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
          if (calendarEnabled()) {
            setDayClicks();
          }
          setMonthClicks();
          colourDays();
        }
      });
      return false;
    });
  };

  var hideResetLink = function() {
    $('p.reset-calendar').hide();
  };

  var showResetLink = function() {
    $('p.reset-calendar').show();
  };

  var disableFormSubmit = function() {
    $('input.holiday-submit').attr('disabled', 'true');
  };

  var enableFormSubmit = function() {
    $('input.holiday-submit').removeAttr('disabled');
  };

  var setupResetLink = function() {
    hideResetLink();
    $('p.reset-calendar > a').click(function() {
      startDate = originalStartDate;
      endDate = originalEndDate;
      dateField = 0;
      clearDays();
      if (startDate) {
        colourDays();
      }
      outputDates();
      hideResetLink();
      disableFormSubmit();
      return false;
    });
  };

  var checkExistingDates = function() {
    var sd = null;
    var ed = null;
    if ($('input#holiday_start_date').length == 1) {
      sd = $('input#holiday_start_date').attr('value');
      ed = $('input#holiday_end_date').attr('value');
    } else {
      sd = $('span.start-date').text();
      ed = $('span.end-date').text();
    }
    if (sd && ed) {
      startDate = strToDate(sd);
      endDate = strToDate(ed);
      originalStartDate = strToDate(sd);
      originalEndDate = strToDate(ed);
    }
  };

  var calendarEnabled = function() {
    return !$('div#calendar').hasClass('disabled');
  };

  checkExistingDates();
  if (startDate && endDate) {
    outputDates();
    colourDays();
  }
  if (calendarEnabled()) {
    setDayClicks();
    setupResetLink();
  } else {
    hideResetLink();
  }
  setMonthClicks();
  disableFormSubmit();
});

jQuery.ajaxSetup({'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");}});
