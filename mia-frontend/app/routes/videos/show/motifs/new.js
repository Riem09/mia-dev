import Ember from 'ember';

export default Ember.Route.extend({
    setupController(controller, models) {
        controller.set('video', models.video);
        controller.set('currentTime', models.currentTime);
        var currentTimeS = parseFloat(models.currentTime);
        controller.set('startFraction', (currentTimeS * 1000.0) / parseInt(models.video.get('video_upload').get('duration_ms')) );
    },
    resetController(controller, isExiting, transition) {
        if (isExiting) {
            controller.set('motif', null);
            controller.set('startFraction', 0);
            controller.set('endFraction', 1);
            controller.set('currentTime', 0);
        }
    }
});
