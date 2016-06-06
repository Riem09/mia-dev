import Ember from 'ember';

export default Ember.Route.extend({
  resetController(controller, isExiting, transition) {
    if (isExiting) {
      controller.set('showSearchBox', false);
    }
  }
});
