import Ember from 'ember';
import Util from '../util';

export default Ember.Component.extend({
    classNames: ['video-list-item'],
    videoShowPath: 'videos.show',
    playbackRate: 0.3,
    slowRate: 0.3,
    startTimeMs: 0,
    endTimeMs: null,
    timeline: true,
    videoDuration: function () {
        return Util.formatTime( this.get('video.duration_ms') );
    }.property('video.duration_ms'),
    init() {
        this._super();
        this.set('endTimeMs', this.get('endTimeMs') || this.get('video.combined_end_time') || this.get('video.duration_ms'));
        this.set('startTimeMs', this.get('startTimeMs') || this.get('video.combined_start_time') || 0);
    },
    didInsertElement() {
        var _this = this;
        _this.$().on('mouseenter.video-list-item', function () {
            _this.set("playbackRate", 1);
            _this.set('muted', false);
        });
        _this.$().on('mouseleave.video-list-item', function () {
            _this.set('playbackRate', _this.get('slowRate'));
            _this.set('muted', true);
        });
    },
    willRemoveElement() {
        this.$().off('.video-list-item');
    }
});
