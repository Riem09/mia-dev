import Ember from 'ember';
import ENV from 'mia-frontend/config/environment';

export default Ember.Controller.extend({
    motif: null,
    store: Ember.inject.service('store'),


    startFraction: 0,
    endFraction: 1,
    currentFraction: 0,
    startFractionObserver: Ember.observer('startFraction', function () {
       this.set('currentFraction', this.get('startFraction'));
    }),
    endFractionObserver: Ember.observer('endFraction', function () {
        this.set('currentFraction', this.get('endFraction'));
    }),
    actions: {
        setMotif: function (motifId) {
            var _this = this;
            this.store.find('motif', motifId).then(function (motif) {
                _this.set('motif', motif);
            });
        },
        saveVideoMotif: function () {
            var _this = this;
            var videoDurationMs = parseInt(_this.get('video.video_upload.duration_ms'));
            this.ajax.post({
                url: ENV.V1_API_URL + '/video_motifs',
                data: {
                    'video_motif[motif_id]': _this.get('motif.id'),
                    'video_motif[video_id]': _this.video.id,
                    'video_motif[start_time_ms]': parseFloat(_this.startFraction) * videoDurationMs,
                    'video_motif[end_time_ms]': parseFloat(_this.endFraction) * videoDurationMs
                }
            }).then(function (data, response) {
                _this.store.pushPayload(data);
                _this.replaceRoute('videos.show', data.data.relationships.video.data.id);
            }, function (status, response) {
                console.error("Was unable to create video motif: ", status, response);
            });

        }
    },
    afterModel() {
        this.set('currentTime', this.modelFor('currentTime'));
    }
});
