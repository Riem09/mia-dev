import Ember from 'ember';

export default Ember.Controller.extend({
    classNames: ['search'],
    queryParams: ['motif_ids', 'keywords', 'refresh'],
    motif_ids: [],
    keywords: [],
    showAddMotif: false,
    store: Ember.inject.service('store'),
    motifsChanged: function() {
      let motifsModel = this.get('motifs');

      if(Ember.isArray(motifsModel) && Ember.isEmpty(motifsModel)) {
        this.set('showAddMotif', true);
      }
    }.observes('motifs').on('init'),
    getMotifIds() {
        return this.get('motifs').map( function (elem) { return elem.get('id'); } );
    },
    actions: {
        toggleShowAddMotif() {
            this.toggleProperty('showAddMotif');
        },
        addMotif(motifId) {
            this.set('showAddMotif', false);
            var motif_ids = this.getMotifIds();
            motif_ids.push(motifId);
            this.transitionToRoute({
                queryParams: {
                    motif_ids: motif_ids
                }
            });
        },
        removeMotif(motif) {
            var motifs = this.get('motifs');
            motifs = motifs.filter(function (elem) {
                return elem.id != motif.id;
            });
            this.set('motifs', motifs);
            var motif_ids = this.getMotifIds();
            this.transitionToRoute({
                queryParams: {
                    motif_ids: motif_ids
                }
            });
        }
    }
});
