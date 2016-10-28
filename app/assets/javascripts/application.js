// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.turbolinks
//= require bootstrap-sprockets



var disableddates = (typeof disableddates === 'undefined') ? [] : disableddates;
var d = new Date();
var date = ('0'+(d.getMonth()+1)).slice(-2) + '-' + ('0'+d.getDate()).slice(-2);
var today = d.getFullYear() + '-' + date;
var nextYear = (d.getFullYear()+1) + '-' + date;

function DisableSpecificDates(date) {
    var string = jQuery.datepicker.formatDate('dd-mm-yy', date);
    return [disableddates.indexOf(string) == -1];
  };

  $( function() {
    var dateFormat = "mm/dd/yy",

      from = $( "#from" )
        .datepicker({
        	beforeShowDay: DisableSpecificDates,
        	minDate: new Date(today),
					maxDate: new Date(nextYear),
          defaultDate: "+1w",
          changeMonth: true,
          numberOfMonths: 2,
          dateFormat: "dd-mm-yy"
        })
        .on( "change", function() {
          to.datepicker( "option", "minDate", getDate( this ) );
        }),
      to = $( "#to" ).datepicker({
        beforeShowDay: DisableSpecificDates,
        minDate: new Date(today),
				maxDate: new Date(nextYear),
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 2,
        dateFormat: "dd-mm-yy"
      })
      .on( "change", function() {
        from.datepicker( "option", "maxDate", getDate( this ) );
      });
 
    function getDate( element ) {
      var date;
      try {
        date = $.datepicker.parseDate( dateFormat, element.value );
      } catch( error ) {
        date = null;
      }
 
      return date;
    };

  });