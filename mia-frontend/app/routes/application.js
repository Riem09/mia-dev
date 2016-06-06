import Ember from 'ember';

export default Ember.Route.extend({
    auth: Ember.inject.service('auth'),
    currentUser: Ember.computed.alias('auth.user'),
    activate() {
        if (!this.get('currentUser') && this.get('auth').hasSession()) {
            this.get('auth').authenticate();
        }
    },
    actions: {
        searchMotif(motifId) {
//            console.debug('routes/application: searchMotif');
            //go to videos page that includes the motif
            this.transitionTo('videos', {
                queryParams: { 'motif_ids': [motifId], 'keywords': [] }
            });
        },
        searchKeyword(keyword) {
//            console.debug("routes/application: searchKeyword");
            this.transitionTo('videos', {
                queryParams: { 'motif_ids': [], 'keywords': [keyword] }
            });
        },
        showVideos() {
//            console.debug("routes/application: showVideos");
            this.transitionTo('videos', {
                queryParams: { 'motif_ids': [], 'keywords': [] }
            });
        },
        addKeyword(obj) {
            console.debug('Add Keyword: ', obj);
        },
        back() {
            window.history.back();
        }
    }
});
