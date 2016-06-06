import Ember from 'ember';

export default Ember.Component.extend({
    store: Ember.inject.service('store'),
    actions: {
        addMotif() {
            this.sendAction('createMotif', this.$().find('form.add-motif-form').serializeArray() );
        },
        setParentMotif(motifId) {
            this.store.find('motif', motifId).then(function (motif) {
                this.get('motif').set('parent', motif);
            });
        },
        back() {
          window.history.back();
        }
    }
});
