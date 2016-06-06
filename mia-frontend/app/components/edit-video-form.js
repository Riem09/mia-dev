import Ember from 'ember';

export default Ember.Component.extend({
    updateVideo: null,
    title: Ember.computed.oneWay('video.title'),
    description: Ember.computed.oneWay('video.description'),
    videoUpload: Ember.computed.alias('video.video_upload'),
    actions: {
        submit: function () {
            this.sendAction('updateVideo', this.$().find('form').serializeArray(), this.get('video.id'));
        }
    }
});
