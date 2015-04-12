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

});

function go_to_date(date){
  console.log("I'm going to date")
  console.log(date)
  $('#calendar').fullCalendar('gotoDate', date)
}
