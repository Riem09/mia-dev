import Ember from 'ember';

export default Ember.Route.extend({
    model(params) {
        return this.store.find('user', params.id);
    },
    setupController(controller, model) {
        this._super();
        controller.set('model', model);
        controller.set('unpublished', model.get('videos').filter(function (elem) {
            return !elem.get('published');
        }));
    }
});
