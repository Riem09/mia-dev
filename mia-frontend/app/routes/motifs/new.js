import Ember from 'ember';

export default Ember.Route.extend({
  model: function (params) {
    var motif = this.store.peekRecord('motif', params.parent_id);
    if (motif) {
        return motif.reload();
    } else {
        return this.store.find('motif', params.parent_id);
    }
  },
  setupController(controller, model) {
      this.controller.set('parent', model);
  }
});
