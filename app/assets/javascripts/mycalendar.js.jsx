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
        <div>
          <Event title={calEvent.title} timePeriod={timePeriod} location={calEvent.location} description={calEvent.description}/>
          <AdminButtons eventID={calEvent.id} title={calEvent.title}/>
        </div>,
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

  $('#panel').outerHeight($('#calendar').outerHeight() - $('#panel_header').outerHeight());

  var timer,
    $win = $(window);
  $win.on('resize', function() {
    clearTimeout(timer);
    timer = setTimeout(function() {
      $('#panel').outerHeight($('#calendar').outerHeight() - $('#panel_header').outerHeight());
    }, 250);
  });

});
