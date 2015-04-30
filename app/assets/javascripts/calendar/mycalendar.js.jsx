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
