import Ember from 'ember';

export default Ember.Component.extend({
    classNames: ['mia-input'],
    classNameBindings: ['hasError', 'class'],
    hasError: function () {
        return (this.get('errors') && this.get('errors').length > 0) || !!(this.get('error'));
    }.property('errors', 'error'),
    errors: null,
    error: null
});
