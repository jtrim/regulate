(function($){
  var Regulate = window.Regulate || Regulate || {};

  Regulate = {
    init: function Regulate_init(){
      // some code that needs to be executed after doc ready
      Regulate.bindEvents();
    },
    bindEvents: function Regulate_liveEvents(){
      // more globally bound events
    },
    helpers: function Regulate_helpers(){
      // helper for searching through arrays
      Regulate.helpers.arraySearch = function(a){
        var o = {};
        for(var i=0;i<a.length;i++){
          o[a[i]]='';
        }
        return o;
      };
      //j. resigs array remove overload
      Array.prototype.remove = function(from, to) {
        var rest = this.slice((to || from) + 1 || this.length);
        this.length = from < 0 ? this.length + from : from;
        return this.push.apply(this, rest);
      };
      // duck punch Array.indexOf into IE browsers
      if(!Array.indexOf){
        Array.prototype.indexOf = function(obj){
          for(var i=0; i<this.length; i++){
            if(this[i]==obj){
              return i;
            }
          }
          return -1;
        };
      }
    }
  };

  window.Regulate = Regulate;
  $(document).ready(Regulate.init);

})(jQuery);
