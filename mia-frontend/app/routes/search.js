import Ember from 'ember';

export default Ember.Route.extend({
    queryParams: {
        motif_ids: {
            refreshModel: true
        },
        refresh: {
            refreshModel: true
        }
    },
    model(params, transition) {
        var store = this.store;
        var response;
        if (params['motif_ids'] && params['motif_ids'].length > 0) {
            response = Ember.RSVP.hash({
                videos: store.query('video', params),
                motifs: store.query('motif', params)
            });
        } else {
            response = Ember.RSVP.hash({
                videos: [],
                motifs: []
            });
        }
        return response;
    },
    setupController(controller, models) {
        controller.set('motifs', models.motifs);
        controller.set('videos', models.videos);
    }
});
