export function initialize(/* container, application */) {
    var token = $('meta[name="csrf-token"]').attr('content');
    if (!Cookies.get('CSRF-TOKEN')) {
        Cookies.set('CSRF-TOKEN', token);
    }
    $.ajaxPrefilter( function(options, originalOptions, xhr) {
        xhr.setRequestHeader('X-CSRF-TOKEN', Cookies.get('CSRF-TOKEN'));
    });
}

export default {
  name: 'set-csrf',
  initialize: initialize
};
