import Ember from 'ember';

export default Ember.Route.extend({
    auth: Ember.inject.service('auth'),
    model: function (params) {
        var _this = this;
        return this.get('auth').confirm(params).then(function () {
            _this.transitionTo('sign-in', { queryParams: { confirmed: true } });
        });
    }
});
