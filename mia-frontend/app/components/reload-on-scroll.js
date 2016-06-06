import Ember from 'ember';

export default Ember.Component.extend({

  didInsertElement() {
    // Call 'loadNext' when user scrolls to bottom of page
    $(window).scroll( () => {
      if ($(window).scrollTop() == $(document).height()-$(window).height()){
        this.get('loadNext')();
      }
    });
  },

  didDestroyElement() {
    $(window).unbind('scroll');
  }

});
