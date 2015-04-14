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
      var eventEnd = calEvent.start.add(calEvent.duration, 'hour');
      var endTime;
      if (calEvent.duration >= 24) {
        endTime = eventEnd.format('MMMM Do YYYY, h:mm a');
      } else {
        endTime = eventEnd.format('h:mm a');
      }
      React.render(
        <Event name={calEvent.title} start={startTime} end={endTime} location={calEvent.location} description={calEvent.description}/>,
        document.getElementById('panel')
      );
    },

    header: {
      left:   'today',
      center: 'title',
      right:  'prev,next'
    }

  });

  // go_to_date(date);

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

function go_to_date(date){
  console.log("I'm going to date")
  console.log(date)
  $('#calendar').fullCalendar('gotoDate', date)
}
