/*
 This is a manifest file that'll be compiled into application.js, which will include all the files
 listed below.

 Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
 or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.

 It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
 compiled file.

 Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
 about supported directives.

 = require jquery
 = require jquery_ujs
 = require foundation
 /////////// require turbolinks
 = require_tree .


 require_tree . require all files under assets/javascript
 = require underscore
 = require gmaps/google
 = require spin
 = require jQuery_spin.js

 = require jquery.infinitescroll
 */
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
///////////// require turbolinks


// require_tree . require all files under assets/javascript
//= require underscore
//= require gmaps/google
//= require spin
//= require jQuery_spin.js
//= require jquery-ui
//= require jquery.modal
//= require masonry/jquery.masonry
//= require masonry/jquery.event-drag
//= require masonry/jquery.imagesloaded.min
//= require masonry/jquery.infinitescroll.min
//= require masonry/modernizr-transitions
//= require masonry/box-maker
//= require masonry/jquery.loremimages.min
//= require jquery.infinitescroll
//= require sweet-alert
//= require location.js
//= require jquery
//= require jquery_ujs
//= require select2

//= require_tree .

$(function(){
    $(document).foundation();

    //close automatic alert
    var clearAlert = setTimeout(function() {
        if (!$('.alert-box').hasClass("noAutoClose")) {
            $(".alert-box a.close").click();
        }
    }, 7000);

    $(document).on("click", ".alert-box.success a.close", function(event) {
        clearTimeout(clearAlert);
    });

});

// SPINNER
var spinnerOpts = {
    lines: 13, // The number of lines to draw
    length: 20, // The length of each line
    width: 16, // The line thickness
    radius: 38, // The radius of the inner circle
    corners: 1, // Corner roundness (0..1)
    rotate: 0, // The rotation offset
    direction: 1, // 1: clockwise, -1: counterclockwise
    color: '#000', // #rgb or #rrggbb or array of colors
    speed: 1, // Rounds per second
    trail: 54, // Afterglow percentage
    shadow: true, // Whether to render a shadow
    hwaccel: true, // Whether to use hardware acceleration
    className: 'spinner', // The CSS class to assign to the spinner
    zIndex: 2e9, // The z-index (defaults to 2000000000)
    top: '50%', // Top position relative to parent
    left: '50%' // Left position relative to parent
};

$(document).ready(function(){
    //url: "<%= update_text_path%>" image_update_text_en
    $('#result_div').hide();
    $('#select_div').change(function(){
        $.ajax({
            url: "/images/update_text",
            type: "GET",
            data: {selection: $("#select_div option:selected").text() },
            dataType: "script"
        });
        //alert("Select Box changed")
    });
});

$(function(){
var $container = $('#mansonry-container');
// initialize Masonry after all images have loaded
$container.imagesLoaded( function() {
    $('#mansonry-container').masonry({
        isAnimated: true,
        animationOptions: {
            duration: 750,
            easing: 'linear',
            queue: false
        }
    });
});

$(document).ready(function(){
    $("img").load(function(){
        $('#mansonry-container').masonry({
            isAnimated: true,
            animationOptions: {
                duration: 750,
                easing: 'linear',
                queue: false
            }
        });
    });
});

$container.infinitescroll({
        navSelector  : '.pagination-centered',    // selector for the paged navigation
        nextSelector : '.pagination-centered a',  // selector for the NEXT link (to page 2)
        itemSelector : '.box',     // selector for all items you'll retrieve
        loading: {
            finishedMsg: 'No more pages to load.',
            img: 'http://i.imgur.com/6RMhx.gif'
        }
    },
    // trigger Masonry as a callback
    function( newElements ) {
        // get new #page-nav
        var nexPageNav = $(this).find('.pagination-centered');

        // substitute current #page-nav with new #page-nav from page loaded
        $('.pagination-centered').replaceWith(nexPageNav);

        // hide new items while they are loading
        var $newElems = $( newElements ).css({ opacity: 0 });
        // ensure that images load before adding to masonry layout
        $newElems.imagesLoaded(function(){
            // show elems now they're ready
            $newElems.animate({ opacity: 1 });
            $container.masonry( 'appended', $newElems, true );
        });
    }
);
});