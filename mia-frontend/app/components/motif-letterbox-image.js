import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['motif-letterbox-image'],
  motifImageStyle: function() {
    return new Ember.Handlebars.SafeString("background-image: url('" + this.get('motif.image_url') + "');");
  }.property('motif.image_url')
});
