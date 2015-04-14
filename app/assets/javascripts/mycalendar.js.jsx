/** @jsx React.DOM */
$(document).ready(function() {
  $('#calendar').fullCalendar({

    events: function(start, end, timezone, callback){
      $.getJSON('events.json', function(data){
        console.log("I'm in the events function");
        console.log(data);
        callback(data);
      });
    },

    eventColor: '#62C400',

    eventClick: function(calEvent, jsEvent, view) {
      var startTime = calEvent.start.format('MMMM Do YYYY, h:mm a');
      var endTime;
      var eventEnd = calEvent.end;
      if (eventEnd == null) {
        endTime = null;
      } else if (eventEnd.diff(calEvent.start, 'hours') >= 24) {
        endTime = calEvent.end.format('MMMM Do YYYY, h:mm a');
      } else {
        endTime = calEvent.end.format('h:mm a');
      }

      var timePeriod;
      if (endTime == null) {
        timePeriod = startTime;
      } else {
        timePeriod = startTime + ' to ' + endTime;
      }

      React.render(
        <Event name={calEvent.title} timePeriod={timePeriod} location={calEvent.location} description={calEvent.description}/>,
        document.getElementById('panel')
      );
    },

    header: {
      left:   'today',
      center: 'title',
      right:  'prev,next'
    }

  });

  console.log("hello world");
  $.getJSON('events.json', function(data){
    console.log("I'm in the json call");
    console.log(data);
  });

  $('#panel').height($('#calendar').height());

  var timer,
    $win = $(window);
  $win.on('resize', function() {
    clearTimeout(timer);
    timer = setTimeout(function() {
      $('#panel').height($('#calendar').height());
    }, 250);
  });

});
