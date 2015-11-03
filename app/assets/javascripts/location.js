//$("#spinner").spin(spinnerOpts);

/*
var marker;
var text = "drag me to position";

handler = Gmaps.build('Google');
handler.buildMap(
    {
        internal: {id: 'map'}
    },
    function(){
        //var options = {timeout:60000};
        //if(navigator.geolocation) {
        //    navigator.geolocation.getCurrentPosition(displayOnMap, displayOnMap, options);
        //} else {
        //    displayOnMap(0);
        //}
        handler.fitMapToBounds();

        google.maps.event.addListener(handler.getMap(), 'click', function(e) {
            //Remove marker
            marker.setMap(null);

            marker = new google.maps.Marker({
                position: e.latLng,
                map: handler.getMap(),
                title: text,
                draggable: true
            });
            handler.addMarker(marker);
            updateFormLocation(marker.position);
        });

        //reposition map
        google.maps.event.addListener(handler.getMap(), 'center_changed', function() {
            // 3 seconds after the center of the map has changed, pan back to the
            // marker.
            window.setTimeout(function() {
                handler.getMap().panTo(marker.getPosition());
            }, 3000);
        });

    });

function displayOnMap(position){
    var myLat;
    var myLng;
    if(#{raw @hash.to_json}) {
        // todo : take values from json as lat/lng @numa help ;-)
        //marker = handler.addMarker(#{raw @hash.to_json});
        myLat = 46.793976;
        myLng = 7.15889;
    } else if('coords' in position) {
        myLat = position.coords.latitude;
        myLng = position.coords.longitude;
    } else {
        // position of UNIFR ;-)
        myLat = 46.793976;
        myLng = 7.15889;
    }

    var myLatlng = new google.maps.LatLng(myLat, myLng);
    marker = new google.maps.Marker({
        position: myLatlng,
        map: handler.getMap(),
        title: text,
        draggable: true
    });

    handler.addMarker(marker);
    handler.map.centerOn(myLatlng);
    updateFormLocation(marker.position);

    google.maps.event.addListener(marker,'dragend',function(event) {
        updateFormLocation(marker.position);
    });

    $("#spinner").spin(false) //hide spinner once location found
};

function updateFormLocation(latLng) {
    $('#vote_latitude').val(latLng.lat());
    $('#vote_longitude').val(latLng.lng());
}

*/

