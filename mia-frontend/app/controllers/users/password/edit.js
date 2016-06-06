import Ember from 'ember';

export default Ember.Controller.extend({
    queryParams: ['reset_password_token'],
    auth: Ember.inject.service('auth'),
    actions: {
        submit() {
            var _this = this;
            this.get('auth').confirmNewPassword(this.get('reset_password_token'),
                                                this.get('password'),
                                                this.get('password_confirmation')).then(function (data, xhr) {
                _this.transitionToRoute('sign-in');
            }, function (xhr, status, message) {
               if (xhr.status == 422) {
                   _this.set('errors', xhr.responseJSON);
               }
            });
        }
    }
});
