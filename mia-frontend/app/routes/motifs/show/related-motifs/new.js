import Ember from 'ember';
import ENV from 'mia-frontend/config/environment';

export default Ember.Route.extend({
    setupController(controller, model) {
        controller.set('motif', model);
    },
    actions: {
        willTransition(t) {
            t.router.refresh();
        },
        submit(data) {
            var _this = this;
            this.ajax.post({
                url: ENV.V1_API_URL + '/related_motifs',
                data: data
            }).then(function () {
               _this.transitionTo('motifs.show', data[0].value);
            }, function (status, response) {
                console.error(status, response);
            });

        }
    }
});
