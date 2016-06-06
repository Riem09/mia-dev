import Ember from 'ember'

export default Ember.Component.extend({
  classNames: ['.motif-add-opener'],
  done: null, //Override this method with a "motif" arg when implementing the component
  showPanel: false,
  didInsertElement() {
    if(!this.get('done')) {
      throw `motif-add-opener Error:
        Must add a function callback for when this component finishes its job.
        Example: {{motif-add-opener done=myCoolFunction}}`;
    }
  },
  actions: {
    openPanel() {
      this.set('showPanel', true);
    },
    closePanel() {
      this.set('showPanel', false);
    },
    sendMotif(motifID) {
      this.set('showPanel', false);
      this.sendAction('done', motifID)
    }
  }
});
