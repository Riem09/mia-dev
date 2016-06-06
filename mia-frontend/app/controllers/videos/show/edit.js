import Ember from 'ember';
import ENV from 'mia-frontend/config/environment';

export default Ember.Controller.extend({
    actions: {
        updateVideo(data, videoId) {
            var _this = this;
            _this.ajax.patch({
                url: ENV.V1_API_URL + '/videos/' + videoId,
                data: data
            }).then(function (data) {
                _this.store.pushPayload(data);
                _this.replaceRoute('videos.show', videoId);
            }, function (xhr) {
                if (xhr.status == 422) {
                    _this.set('errors', xhr.responseJSON);
                }
            });
        }
    }
});
