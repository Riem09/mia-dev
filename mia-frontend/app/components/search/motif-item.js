import Ember from 'ember';

export default Ember.Component.extend({
    classNames: ['motif-item'],
    motif: null,
    actions: {
        removeMotif() {
            this.sendAction('onRemove', this.get('motif'));
        }
    }
});
