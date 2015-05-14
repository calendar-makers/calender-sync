$(document).ready(function() {
  $('#calendar').fullCalendar({

    events: function(start, end, timezone, callback){
      $.getJSON('events.json', function(data){
        callback(data);
      });
    },

    eventColor: '#A6C55F',

    eventLimit: 'true',

    eventClick: function(calEvent, jsEvent, view) {
      jsEvent.stopPropagation();
      jsEvent.preventDefault();
      $.ajax({
        type: 'GET',
        url: calEvent.url,
        dataType: 'script',
        complete: function(){
          get_interactive_map(calEvent.location)
        }
      });
    },

    header: {
      left:   'today',
      center: 'title',
      right:  'prev,next'
    }
  });

  $('#panel').outerHeight($('#calendar').outerHeight(true) - $('#panel_header').outerHeight(true));

  var timer,
    $win = $(window);
  $win.on('resize', function() {
    clearTimeout(timer);
    timer = setTimeout(function() {
      $('#panel').outerHeight($('#calendar').outerHeight(true) - $('#panel_header').outerHeight(true));
    }, 250);
  });

});
