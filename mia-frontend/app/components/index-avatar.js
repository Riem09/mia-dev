import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['index-avatar-wrap'],
  avatar_url: null,
  didInsertElement() {
    var self = this;
    self.$().on('mouseenter.index-avatar', function() {
      self.sendAction();
    });
    self.$().on('mouseleave.index-avatar', function() {
      self.sendAction();
    });
  }
})
