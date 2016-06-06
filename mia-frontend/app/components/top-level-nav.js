import Ember from 'ember';

export default Ember.Component.extend({
    auth: Ember.inject.service('auth'),
    user: Ember.computed.alias('auth.user'),
    classNames: ['top-level-nav'],
    signOut: function () {
        this.get('auth').signout().then(function () {
        }, function (status) {
            console.error(status);
        });
    }
});
