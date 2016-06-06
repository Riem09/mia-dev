import Ember from 'ember';
import ENV from 'mia-frontend/config/environment';

export default Ember.Route.extend({
    model: function (params) {
//        console.debug("videos/show.js");
        return new Ember.RSVP.hash({
            video: this.store.find('video', params.id),
            currentTime: params.t || 0
        });
    },
    setupController(controller, models) {
        controller.set('video', models.video);
        controller.set('currentTime', models.currentTime);
    },
    actions: {
        onDelete() {
            var _this = this;
            var models = this.modelFor('videos.show');
            var result = window.confirm("Are you sure you would like to delete the video '"+ models.video.get('title') + "'?");
            if (result) {
//                console.debug("have video", models.video);
                this.ajax.destroy({
                    url: ENV.V1_API_URL + '/videos/'+models.video.id
                }).then(function () {
                    _this.replaceWith('videos', { queryParams: { refresh: true } });
                }, function (status, response) {
                    console.error("Could not delete video: ", status, response);
                });
            }
        },
        publish() {
            var _this = this;
            var video = this.modelFor('videos.show').video;
            this.ajax.patch({
                url: ENV.V1_API_URL + '/videos/'+video.id,
                data: {
                    'video[published]': true
                }
            }).then(function () {
                video.set('published', true);
            });
        },
        unpublish() {
            var _this = this;
            var video = this.modelFor('videos.show').video;
            this.ajax.patch({
                url: ENV.V1_API_URL + '/videos/'+video.id,
                data: {
                    'video[published]': false
                }
            }).then(function () {
                video.set('published', false);
            });
        }
    }
});
