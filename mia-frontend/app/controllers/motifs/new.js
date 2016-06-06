import Ember from 'ember';
import ENV from 'mia-frontend/config/environment';


export default Ember.Controller.extend({
    store: Ember.inject.service('store'),
    ajax: Ember.inject.service('ajax'),
    actions: {
        createMotif(data) {
            var _this = this;
            _this.get('ajax').post({
                url: ENV.V1_API_URL + '/motifs',
                data: data
            }).then(function (data) {
                _this.store.pushPayload(data);
                _this.replaceRoute('motifs.show', data.data.id);
            }, function (xhr) {
                if (xhr.status == 422) {
                    console.debug(xhr);
                    _this.set('errors', xhr.responseJSON);
                }
            });
        }
    }
});
