/** @jsx React.DOM */
$(document).ready(function() {

  $(document).on('submit', '#create_event', function(e, data){
    //alert("form clicked");
    //console.log(e);
    //console.log(data);
    //console.log(this);
    var data = $(this).serialize();
    //console.log($(this).serialize());
    e.stopPropagation();
    e.preventDefault();

    $.post('/events', data, function(){
      console.log("completed");
      $('#calendar').fullCalendar('refetchEvents');
    })
  });


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
        dataType: 'script'
      });
      return false;
    },

    header: {
      left:   'today',
      center: 'title',
      right:  'prev,next'
    }

  });
/*
  $(document).on('click','.button',function(){
    $('#calendar').fullCalendar('refetchEvents');
  });
*/
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
