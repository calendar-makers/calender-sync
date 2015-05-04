var autocomplete;
var componentForm = {
    street_number: 'short_name',
    route: 'long_name',
    locality: 'long_name',
    administrative_area_level_1: 'short_name',
    country: 'short_name',
    postal_code: 'short_name'
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

function read_full_address_from_form() {
    var fullAddress = {
        event_st_number: '',
        event_st_name: '',
        event_city: '',
        event_zip: '',
        event_state: '',
        event_country: ''
    };
    for (var component in componentForm) {
        id = idMap[component];
        fullAddress[id] = document.getElementById(id).value;
    }
    return fullAddress;
}

function fix_null_fields(address) {
    for (var field in address) {
        if (!address[field]) {
            address[field] = '';
        }
    }
    return address;
}

function read_full_address(address) {
    if (address) {
        return fix_null_fields(address);
    } else {
        return read_full_address_from_form();
    }
}

function format_address_string(address) {
     return [(address['event_st_number'] + ' ' + address['event_st_name']).replace(' ', '+'),
              address['event_city'].replace(' ', '+'), address['event_state'].replace(' ', '+'),
              address['event_country'].replace(' ', '+'), address['event_zip']].join(',').replace(' ', '+');  // CHECK THIS FINAL REPLACE
}

function get_interactive_map(address_map) {
    var key = 'AIzaSyBktYa3JqWkksJQOd6pajaI8SDms7iKO3M';
    var address = read_full_address(address_map);
    var address_string = format_address_string(address);
    var map = $(['<iframe width="98%" height="50%" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/place?key=', key, '&q=', address_string, '"></iframe>'].join(""));
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
