import Ember from 'ember';

export default Ember.Controller.extend({
    auth: Ember.inject.service('auth'),
    user: Ember.computed.alias('auth.unconfirmedUser'),
    actions: {
        signUp: function() {
            var _this = this;
            _this.set('errors', null);
            this.get('auth').signup( $('form.sign-up').first().serializeArray() ).then(function (data, response) {
            }, function (xhr) {
                _this.set('errors', xhr.responseJSON.errors);
                console.error(xhr);
            });
        }
    }
});
