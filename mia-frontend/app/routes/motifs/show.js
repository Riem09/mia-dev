import Ember from 'ember';
import ENV from 'mia-frontend/config/environment';

export default Ember.Route.extend({
    model: function (params) {
      var motif = this.store.peekRecord('motif', params.id);
      if (motif) {
          return motif.reload();
      } else {
          return this.store.find('motif', params.id);
      }
    },
    setupController: function(controller, model) {
        this.controllerFor('motifs').set('motif', model);
    },
    actions: {
        removeRelatedMotif(related_motif) {
            var _this = this;
            this.ajax.destroy({
                url: ENV.V1_API_URL + '/related_motifs/' + related_motif.id
            }).then(function () {
                related_motif.deleteRecord();
                _this.refresh();
            });
        }
    }
});
