import Ember from 'ember';

export default Ember.Route.extend({
    model: function () {
        var store = this.store;
        return new Ember.RSVP.hash({
            motifs: store.query('motif', {})
        });
    },
    setupController(controller, models) {
        controller.set('motifs', models.motifs);
    }
});

