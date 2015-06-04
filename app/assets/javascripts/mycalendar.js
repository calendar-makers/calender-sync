$(document).ready(function() {
  $('#calendar').fullCalendar({

    events: function(start, end, timezone, callback){
      $.getJSON('events.json', {start: start.toDate(), end: end.toDate()}, function(data){
        callback(data);
      });
    },

    eventLimit: 'true',

    eventClick: function(calEvent, jsEvent, view) {
      //jsEvent.stopPropagation();
      //jsEvent.preventDefault();
      $.ajax({
        type: 'GET',
        url: calEvent.url,
        dataType: 'script'//,
        //complete: function(){
          //get_interactive_map(calEvent.location)
        //}
      });
      return false;
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

  // Prevent any form submission caused by a simple press of the ENTER key
  $(window).on('keydown', function(e) {
      var enter_key_code = 13;
      if (e.keyCode == enter_key_code) {
          return false;
      }
  });
});
