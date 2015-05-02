/** @jsx React.DOM */
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
        url: 'calendar/show_event',
        data: {
          id: calEvent.id,
          //could pass all the other fields here to avoid a database lookup...
        },
        dataType: 'script',
        complete: function(){
          console.log("Yoyoyo")
          console.log($('#loco').text());
          var loc = $('#loco').text();
          console.log(loc);
          console.log("^^loc");
          var address = new google.maps.places.Autocomplete((loc),
                                                        { types: ['geocode'] });
          console.log("lalalala");
          //initialize();
          get_my_interactive_map(address);
          console.log("after");
        }
      });
      return false;
    },

    header: {
      left:   'today',
      center: 'title',
      right:  'prev,next'
    }

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