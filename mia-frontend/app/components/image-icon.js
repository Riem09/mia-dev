import Ember from 'ember';

export default Ember.Component.extend({
    icon_url: null,
    classNames: ['image-icon'],
    iconUrl: function () {
        return new Ember.Handlebars.SafeString(this.get('icon_url'));
    }.property('icon_url')
});
