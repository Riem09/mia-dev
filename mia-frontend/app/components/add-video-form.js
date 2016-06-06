import Ember from 'ember';

export default Ember.Component.extend({
    title: null,
    description: null,
    s3_key: null,
    actions: {
        onSubmit() {
            this.sendAction('createVideo', this.$().find('form').serializeArray());
        }
    }
});
