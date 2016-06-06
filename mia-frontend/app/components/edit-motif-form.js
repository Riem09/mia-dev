import Ember from 'ember';

export default Ember.Component.extend({
    actions: {
        sendUpdateMotif(event) {
            this.sendAction('updateMotif', this.$().find('form').serializeArray() );
        }
    }
});
