$(document).ready(function() {
  $('#calendar').fullCalendar({

    events: function(start, end, timezone, callback){
      $.getJSON('events.json', function(data){
        callback(data);
      });
    },

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

  setPanelHeight = function() {
      $('#panel').outerHeight($('#calendar').find('.fc-view-container').outerHeight(true));
  };

  setPanelHeight();

  var timer;
  $(window).resize(function() {
    clearTimeout(timer);
    timer = setTimeout(function() {
        setPanelHeight();
    }, 250);
  });

});
