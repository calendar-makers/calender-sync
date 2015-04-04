$(document).ready(function() {
  $('#calendar').fullCalendar({
      // put your options and callbacks here
    dayClick: function() {
      alert('a day has been clicked!');
    },
    
    events: function(start, end, timezone, callback){
      $.getJSON('events.json', function(data){
        console.log("I'm in the events function");
        console.log(data);
        callback(data);
      });
    },

    eventColor: '#66CC00',

    header: {
      left:   'today prev,next',
      center: 'title',
      right:  ''
    }
    
  });

  go_to_date(date);

  console.log("hello world");
  $.getJSON('events.json', function(data){
    console.log("I'm in the json call");
    console.log(data);
  });
  
  $('#my-button').click(function() {
    var moment = $('#calendar').fullCalendar('getDate');
    alert("The current date of the calendar is " + moment.format());
  });
});

function go_to_date(date){
  console.log("I'm going to date")
  console.log(date)
  $('#calendar').fullCalendar('gotoDate', date)
}
