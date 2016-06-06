import Ember from 'ember';
import ENV from 'mia-frontend/config/environment';

export default Ember.Controller.extend({
    actions: {
        createVideo(data) {
            var _this = this;
            this.ajax.post({
                url: ENV.V1_API_URL + '/videos',
                data: data
            }).then(function (data) {
                _this.set('errors', null);
                _this.replaceRoute('videos.show', data.data.id);
            }, function (xhr, statusText, message) {
                if (xhr.status == 422) {
                    console.debug(xhr);
                    _this.set('errors', xhr.responseJSON);
                }
            });
        }
    }
});
