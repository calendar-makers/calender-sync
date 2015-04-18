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
  console.log("You come here often? We love people who love the console so why don't you send us an email and we will send you a job! jobs@fasterfood.io");
  //console.log("hello world");

});

function go_to_date(date){
  console.log("I'm going to date")
  console.log(date)
  $('#calendar').fullCalendar('gotoDate', date)
}
