import Ember from 'ember';

export default Ember.Component.extend({
    imageUrl: null,
    imageStyle: function () {
        return new Ember.Handlebars.SafeString("background-image: url('"+this.get('imageUrl')+"');");
    }.property('imageUrl')
});
