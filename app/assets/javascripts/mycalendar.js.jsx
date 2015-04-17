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
    // eventColor: '#FFA721',

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
          <AdminButtons calEvent={calEvent}/>
        </div>,
        document.getElementById('panel')
      );
    },

    // // used this to work on edit panel
    // eventClick: function(calEvent, jsEvent, view) {
    //   var startTime = calEvent.start.format('MMMM Do YYYY, h:mm a');
    //   var start_month  = calEvent.start.format('MMMM');
    //   var start_day    = calEvent.start.format('D');
    //   var start_year   = calEvent.start.format('YYYY');
    //   var start_hour   = calEvent.start.format('h');
    //   var start_minute = calEvent.start.format('mm');
    //   var start_ampm   = calEvent.start.format('a');
    //   var endTime;
    //   var eventEnd = calEvent.end;
    //   if (eventEnd == null) {
    //     endTime = null;
    //   } else {
    //     var end_month  = calEvent.end.format('MMMM');
    //     var end_day    = calEvent.end.format('D');
    //     var end_year   = calEvent.end.format('YYYY');
    //     var end_hour   = calEvent.end.format('h');
    //     var end_minute = calEvent.end.format('mm');
    //     var end_ampm   = calEvent.end.format('a');
    //   }
    //   var locationDetails = calEvent.location.split("\n");
    //   var location_street = locationDetails[0];
    //   var location_city   = locationDetails[1].split(", ")[0];
    //   var location_state  = locationDetails[1].split(", ")[1];

    //   React.render(
    //     <EditEvent event_id={calEvent.id} name={calEvent.title} start_month={start_month} start_day={start_day} start_year={start_year} start_hour={start_hour} start_minute={start_minute} start_ampm={start_ampm} end_month={end_month} end_day={end_day} end_year={end_year} end_hour={end_hour} end_minute={end_minute} end_ampm={end_ampm} location_street={location_street} location_city={location_city} location_state={location_state} description={calEvent.description}/>,
    //     document.getElementById('panel')
    //   );
    // },

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
