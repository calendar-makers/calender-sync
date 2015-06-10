// NOTE: I'm forced to declare this global object because of a sad bug with the calendar API
//       I need it to rebuild the calendar given that refetchEvents doesn't work...

var init_object = {
    events: function(start, end, timezone, callback){
        $.getJSON('events.json', {start: start.toDate(), end: end.toDate()}, function(data){
            callback(data);
        });
    },

    eventLimit: 'true',

    eventClick: function(calEvent, jsEvent, view) {
        $.ajax({
            type: 'GET',
            url: calEvent.url,
            dataType: 'script'
        });
        return false;
    },

    header: {
        left:   'today',
        center: 'title',
        right:  'prev,next'
    }
};


$(document).ready(function() {

  $('#calendar').fullCalendar(init_object);

  var setPanelHeight = function() {
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
