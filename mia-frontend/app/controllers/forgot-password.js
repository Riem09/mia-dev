import Ember from 'ember';

export default Ember.Controller.extend({
    auth: Ember.inject.service('auth'),
    actions: {
        submit(email) {
            var _this = this;
            this.get('auth').requestNewPassword(email).then(function (data, xhr) {
                _this.set('done', true);
            }, function (xhr, status, message) {
                if (xhr.status == 422) {
                    _this.set('errors', xhr.responseJSON);
                }
            });
        }
    }
});
