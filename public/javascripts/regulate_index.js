// Triggers an event on an element and returns the event result
function fire(obj, name, data) {
  var event = new $.Event(name);
  obj.trigger(event, data);
  return event.result !== false;
}
function allowAction(element) {
  var message = element.attr('data-confirm');
  return !message || (fire(element, 'confirm') && confirm(message));
}
// Handles "data-method" on links such as:
// <a href="/users/5" data-method="delete" rel="nofollow" data-confirm="Are you sure?">Delete</a>
function handleMethod(link) {
  var href = link.attr('href'),
    method = link.attr('data-method'),
    csrf_token = $('meta[name=csrf-token]').attr('content'),
    csrf_param = $('meta[name=csrf-param]').attr('content'),
    form = $('<form method="post" action="' + href + '"></form>'),
    metadata_input = '<input name="_method" value="' + method + '" type="hidden" />';
  if (csrf_param !== undefined && csrf_token !== undefined) {
    metadata_input += '<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden" />';
  }
  form.hide().append(metadata_input).appendTo('body');
  form.submit();
}
$('a.delete_link').bind('click',function(e){
  var link = $(this);
  if (!allowAction(link)){ return false; }
  handleMethod(link);
  return false;
});

