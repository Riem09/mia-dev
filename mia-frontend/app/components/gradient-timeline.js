import Ember from 'ember';

export default Ember.Component.extend({
    classNames: ['gradient-timeline'],

    //sets the width of the timeline
    seekTimeFraction: null,

    elapsedPercentStyle: function () {
        return new Ember.Handlebars.SafeString("width: " + (this.get('seekTimeFraction') * 100.0) + "%;");
    }.property('seekTimeFraction')
});
