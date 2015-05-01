function refresh(){
	$('#calendar').fullCalendar('refetchEvents')	
}

$(document).ready(function() {
	$('#create_event').click(function(){
	    console.log("I'm here I'm here I'm here!");
	    setTimeout(refresh, 1000);
	    //$('#refresh active').attr("id", "refresh");
	});
});

