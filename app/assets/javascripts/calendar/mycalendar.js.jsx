/** @jsx React.DOM */
$(document).ready(function() {
  var timePeriod = function(start, end) {
    var startTime = start.format('MMMM D, YYYY, h:mm a');
    var endTime;
    var eventEnd = end;
    if (eventEnd == null) {
      endTime = null;
    } else if (eventEnd.diff(start, 'hours') >= 24) {
      endTime = end.format('MMMM D, YYYY, h:mm a');
    } else {
      endTime = end.format('h:mm a');
    }

    var timePeriod;
    if (endTime == null) {
      timePeriod = startTime;
    } else {
      timePeriod = startTime + ' to ' + endTime;
    }
    return timePeriod;
  }

  $('#calendar').fullCalendar({
    events: function(start, end, timezone, callback) {
      $.getJSON('events.json', function(data) {
        console.log("I'm in the events function");
        console.log(data);
        callback(data);
      });
    },

    eventColor: '#A6C55F',

    eventClick: function(calEvent, jsEvent, view) {
      jsEvent.stopPropagation();
      jsEvent.preventDefault();
      $('#panel').load(calEvent.url);
    },

    header: {
      left:   'today',
      center: 'title',
      right:  'prev,next'
    }

  });

  $.getJSON('events.json', function(data){
    console.log("I'm in the json call");
    console.log(data);
  });

  $('#panel').outerHeight($('#calendar').outerHeight(true) - $('#panel_header h2').outerHeight(true));

  var timer,
    $win = $(window);
  $win.on('resize', function() {
    clearTimeout(timer);
    timer = setTimeout(function() {
      $('#panel').outerHeight($('#calendar').outerHeight(true) - $('#panel_header h2').outerHeight(true));
    }, 250);
  });

});
