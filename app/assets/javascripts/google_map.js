var autocomplete;
var componentForm = {
    street_number: 'short_name',
    route: 'long_name',
    locality: 'long_name',
    administrative_area_level_1: 'short_name',
    country: 'short_name',
    postal_code: 'short_name'
};
var fullAddress = {
    street_number: '',
    route: '',
    locality: '',
    administrative_area_level_1: '',
    country: '',
    postal_code: ''
};
var idMap = {
    street_number: 'event_st_number',
    route: 'event_st_name',
    locality: 'event_city',
    postal_code: 'event_zip',
    administrative_area_level_1: 'event_state',
    country: 'event_country'};

function initialize() {
    autocomplete = new google.maps.places.Autocomplete((document.getElementById('autocomplete')),
                                                        { types: ['geocode'] });
    // When the user selects an address from the dropdown,
    // populate the address fields in the form.
    google.maps.event.addListener(autocomplete, 'place_changed', function() {
        fillInAddress();
    });
}


function fillInAddress() {
    var place = autocomplete.getPlace();

    for (var component in componentForm) {
        document.getElementById(idMap[component]).value = '';
        document.getElementById(idMap[component]).disabled = false;
    }

    for (var i = 0; i < place.address_components.length; i++) {
        var addressType = place.address_components[i].types[0];
        if (componentForm[addressType]) {
            var val = place.address_components[i][componentForm[addressType]];
            document.getElementById(idMap[addressType]).value = val;
        }
    }

    get_interactive_map();
}

function read_full_address() {
    for (var component in componentForm) {
        fullAddress[component] = document.getElementById(idMap[component]).value;
    }
}

function format_address_string() {
     return [(fullAddress['street_number'] + ' ' + fullAddress['route']).replace(' ', '+'),
       fullAddress['locality'].replace(' ', '+'), fullAddress['administrative_area_level_1'].replace(' ', '+'),
       fullAddress['country'].replace(' ', '+'), fullAddress['postal_code']].join(',').replace(' ', '+');
}

function get_interactive_map() {
    var key = 'AIzaSyBktYa3JqWkksJQOd6pajaI8SDms7iKO3M';
    read_full_address();
    var address = format_address_string();
    var map = $(['<iframe width="400" height="400" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/place?key=', key, '&q=', address, '"></iframe>'].join(""));
    $('#map').html(map).show();
}

function geolocate() {
    initialize();
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            var geolocation = new google.maps.LatLng(
                position.coords.latitude, position.coords.longitude);
            var circle = new google.maps.Circle({
                center: geolocation,
                radius: position.coords.accuracy
            });
            autocomplete.setBounds(circle.getBounds());
        });
    }
}


// JUST CALL get_interactive_map() TO OPEN THE MAP.  BUT MAKE SURE THAT THE LOCATION FIELDS ARE POPULATED FIRST
