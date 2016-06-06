import Ember from 'ember';

export default Ember.Route.extend({
    auth: Ember.inject.service('auth'),
    beforeModel: function () {
        if (this.get('auth.user.isConfirmed')) {
            this.transitionTo('');
        }
    }
});
