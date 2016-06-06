import Ember from 'ember';

export default Ember.Component.extend({
    classNames: ['error-messenger'],
    messages: Ember.inject.service('messages'),
    errorMessageChanged: Ember.observer('messages.errorMessage', function () {
        this.$().slideDown();
        $('.panel-medium').css("top", "55px");
        var _this = this;
        window.setTimeout(function () {
            _this.$().slideUp();
            $('.panel-medium').css("top", "0");
        }, 4000);
    })
});
