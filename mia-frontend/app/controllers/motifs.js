import Ember from 'ember';

export default Ember.Controller.extend({
  showSearchBox: false,
  actions: {
    toggleShowSearchBox() {
      this.toggleProperty('showSearchBox');
    },
    gotoNewMotif() {
      this.set('showSearchBox', false);
      this.transitionToRoute('motifs.new');
    },
    gotoMotif(motifId) {
      this.set('showSearchBox', false);
      this.transitionToRoute('motifs.show', motifId);
    }
  }
});
