import Ember from 'ember';

export default Ember.Controller.extend({
    disabledAttr: function () {
        return !(this.get('motif.id') && this.get('relatedMotif.id'));
    }.property('motif', 'relatedMotif'),
    actions: {
        setMotif(motifId) {
            var _this = this;
            this.store.find('motif', motifId).then(function (motif) {
                _this.set('relatedMotif', motif);
            });
        },
        doSubmit(motifID) {
            /**
             * I (jamie@skyrocket.is) changed from the normal form to the big open
             * panel. Part of doing this was formatting the data in the way the
             * api expects it. I hope to never, ever do this again.
             *
             * TODO: This is formatting data for an api endpoint that isn't
             * really doing what it should be.
             */
            let payload = [
              {
                name: "related_motif[motif1_id]",
                value: this.get('motif.id')
              },
              {
                name: "related_motif[motif2_id]",
                value: motifID
              }
            ];
            // this.send('submit', payload );
            this.send('submit', payload );
        }
    }
});
