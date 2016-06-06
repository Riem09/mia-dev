import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['motif-letterbox'],
  muted: true,
  playbackRate: 0.3,
  motifImageStyle: function() {
    return new Ember.Handlebars.SafeString("background-image: url('" + this.get('motif.image_url') + "');");
  }.property('motif.image_url')
});
