import Ember from 'ember';

export default Ember.Component.extend({
    classNames: ['info-message'],
    messages: Ember.inject.service('messages'),
    infoMessageChanged: Ember.observer('messages.infoMessage', function () {
      this.$().slideDown();
      $('.panel-medium').css("top", "55px");
      var _this = this;
      window.setTimeout(function () {
          _this.$().slideUp();
          $('.panel-medium').css("top", "0");
      }, 4000);
    })
});
