(function( $ ) {

  $.extend(jQuery.expr[':'], {
    focus: function(element) {
        return element == document.activeElement;
    }
  });

  var timer,
      stored_keys = null,

  Regulate = {

    longPoll: function longPoll( force, callback ){
      var text = $('#page_view').val(),
          m = /\{\{(\w)*\}\}/g,
          keys = [],
          invalid_keys = [],
          deleted_keys = [],
          existing_keys = existing_custom_fields || {},
          blacklist = ['{{view}}', '{{title}}'],
          i,
          f = force || false;

      if( $('#page_view').is(':focus') && f === false) {
        timer = setTimeout( longPoll , 1e3);
        return false;
      }

      $.each( text.match( m ), function( i, v ) {
          if( ~blacklist.indexOf( v ) ) {

            if( !~invalid_keys.indexOf( v ) ) {
              invalid_keys.push( v );
            }

          } else {
            keys.push( v );
          }
      });

      if( stored_keys !== null ) {
        i = stored_keys.length;
        while(i--){
          if( ! ~keys.indexOf( stored_keys[i] ) ) {
            deleted_keys.push( stored_keys[i] );
            $('textarea.'+ stored_keys[i].replace(/[\{,\}]/g, "") ).remove();

          }
        }
      }

      $.each( keys, function( i, v ) {
        var clear_v = v.replace(/[\{,\}]/g, ""),
            form_obj = {
              'name': 'page[edit_regions][' + clear_v + ']',
              'class': clear_v,
              'value': existing_keys[clear_v] || 'Default Text for '+v
            };

        if( $('textarea').hasClass( clear_v )) {
          return;
        }

        $("<textarea>", form_obj ).appendTo('#page_new');

      });

      $('#custom_field_errors').empty();

      $.each( invalid_keys, function( i, v ) {
        if( v !== "{{title}}" ) {
          $('#custom_field_errors').append("Your key "+ v +" just got regulated, try using another key.</br>");
        }
      });

      stored_keys = keys;
      timer = setTimeout( longPoll , 1e3);

      if( $.isFunction( callback ) ){
        callback();
      }
    },

    init: function(){
      var buffer;
      Regulate.longPoll();

      $('form').bind('submit', function( e ){
        var f = e.target;

        e.preventDefault();

        clearTimeout( timer );

        Regulate.longPoll( null, function(){
          $(f).unbind('submit').submit();
        });

      });

      $(window).bind('keyup', function(e) {
        if( e.keyCode == 221 && buffer == 221 ) {
          Regulate.longPoll( true );
        }

        buffer = e.keyCode;

      });
    }

  };

  $( Regulate.init );

  window.Regulate = Regulate;

})(jQuery);
