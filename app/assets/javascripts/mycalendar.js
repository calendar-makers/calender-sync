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

  setOuterHeight = function() {
      $('#panel').outerHeight($('#calendar .fc-view-container').outerHeight(true));
  };

  setOuterHeight();

  var timer;
  $(window).resize(function() {
    clearTimeout(timer);
    timer = setTimeout(function() {
        setOuterHeight();
    }, 250);
  });

});
