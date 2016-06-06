import Ember from 'ember';
import ENV from 'mia-frontend/config/environment';

export default Ember.Controller.extend({
    auth: Ember.inject.service('auth'),
    user: Ember.computed.alias('auth.user'),
    changingPassword: false,
    actions: {
        toggleChangePassword: function () {
            console.debug("asldkf");
            this.toggleProperty('changingPassword');
        },
        submit: function () {
            var formData = $('.edit-user-form').serializeArray();
            var _this = this;
            _this.set('errors', null);
            this.ajax.put({
                url: ENV.V1_API_URL + '/users',
                data: formData
            }).then(function (data, xhr) {
                _this.transitionToRoute('users.show',_this.get('user').id);
            }, function (xhr, status, text) {
                if (xhr.status == 422) {
                    _this.set('errors', xhr.responseJSON.errors);
                }
            });
        }
    }
});
