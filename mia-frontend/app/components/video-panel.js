import Ember from 'ember';
import Util from '../util';
import ENV from 'mia-frontend/config/environment';

export default Ember.Component.extend(Ember.TargetActionSupport, {
  classNames: ['video-panel'],

  play: false,
  //read to get current time
  currentTime: 0,
  //write to set current time
  seekTime: 0,

  //for video motif editing
  startFraction: 0,
  endFraction: 1,

  showAddGeneralMotifs: false,
  showAddTimedMotifs: false,

  /**
   * Acts as the time where the video should stay when navigating AWAY from
   * the timeline, but still within the .controls-wrapper element. This is
   * for usability so that you can click the motifs and they don't move away
   * from the mouse.
   */
  hoverStickyTime: 0,

  currentVideoMotif: null,
  currentVideoMotifIsNew: function() {
    return !(this.get('currentVideoMotif.id'));
  }.property('currentVideoMotif'),

  store: Ember.inject.service('store'),
  auth: Ember.inject.service('auth'),
  messages: Ember.inject.service('messages'),

  elapsedPercent: function() {
    return 100 * (this.get('currentTime') / (this.get('video.duration_ms') / 1000.0));
  }.property('currentTime'),

  durationString: function() {
    return Util.formatTime(this.get('video.video_upload.duration_ms'));
  }.property('video.video_upload.duration_ms'),

  currentTimeString: function() {
    return Util.formatTime(this.get('currentTime') * 1000.0);
  }.property('currentTime'),

  elapsedPercentStyle: function() {
    return new Ember.Handlebars.SafeString("width: " + this.get('elapsedPercent') + "%;");
  }.property('elapsedPercent'),

  calcStartTimeMs: function() {
    var start_time_ms = 0;
    if (this.get('editingCurrentVideoMotif')) {
      start_time_ms = this.get('currentVideoMotif.start_time_ms');
    }
    return start_time_ms;
  }.property('currentVideoMotif.start_time_ms', 'editingCurrentVideoMotif'),

  motifHoverStyle: function() {
    var style = "";
    if (this.get('editingCurrentVideoMotif')) {
      style = new Ember.Handlebars.SafeString('display: none;');
    }
    return style;
  }.property('editingCurrentVideoMotif'),

  calcEndTimeMs: function() {
    var end_time_ms = this.get('video.duration_ms');
    if (this.get('editingCurrentVideoMotif')) {
      end_time_ms = this.get('currentVideoMotif.end_time_ms');
    }
    return end_time_ms;
  }.property('currentVideoMotif.end_time_ms', 'editingCurrentVideoMotif', 'video.duration_ms'),

  durationS() {
    return this.get('video.duration_ms') / 1000.0;
  },
  $elapsed() {
    return this.$().find('.elapsed');
  },
  $timeline() {
    return this.$().find('.timeline');
  },

  init() {
    this._super();
    this.get('currentTime');
  },

  motifTimelineVideoStyle: function() {
    var style = "display: none;";
    if (this.get("motifTimelineDisplayVideo")) {
      style = "";
    }
    return style;
  }.property('motifTimelineDisplayVideo'),

  motifTimelineDisplayVideo: function() {
    return this.get('mouseInsideControls');
  }.property('mouseInsideTimeline', 'motifsAtCurrentTime'),

  motifTimelineTime: function() {
    var time = null;
    if (this.get('mouseInsideTimeline') && this.get('mouseInsideControls')) {
      time = this.get('hoverCurrentTime');
      this.set('hoverStickyTime', time);
    } else if (!this.get('mouseInsideTimeline') && this.get('mouseInsideControls')) {
      time = this.get('hoverStickyTime');
    } else {
      time = this.get('currentTime');
    }
    return time;
  }.property('currentTime', 'mouseInsideTimeline', 'hoverCurrentTime'),

  motifTimelinePosition: function() {
    var timelineWidth = this.$().find('.timeline').innerWidth();
    var currentTimeAsFractionOf1 = (this.get('motifTimelineTime') * 1000.0) / this.get('video.duration_ms');
    return currentTimeAsFractionOf1 * timelineWidth;
  }.property("motifTimelineTime", 'video.duration_ms'),

  motifTimelinePositionObserver: Ember.observer('motifTimelinePosition', function() {
    var timelineWidth = this.$().find('.timeline').innerWidth();
    var hm = this.$().find('.current-motifs');
    var motifTimelinePosition = this.get('motifTimelinePosition');

    if (hm.outerWidth() + motifTimelinePosition > timelineWidth) {

      hm.css('left', "auto");
      hm.css('right', "50px");
      hm.addClass('rtl');

    } else {

      hm.removeClass('rtl');
      hm.css('right', "auto");
      hm.css('left', (motifTimelinePosition + 50) + "px");

    }

  }).on('didInsertElement'),

  motifsAtCurrentTime: function() {
    var time = this.get('motifTimelineTime') * 1000;
    return this.get('video.timestampedVideoMotifs').filter(function(vm) {
      return vm.get('start_time_ms') <= time && vm.get('end_time_ms') > time;
    });
  }.property('motifTimelineTime', 'video.timestampedVideoMotifs'),

  startFractionObserver: Ember.observer('startFraction', function() {
    if (this.get('currentVideoMotif')) {
      this.set('currentVideoMotif.start_time_ms', this.get('video.duration_ms') * this.get('startFraction'));
    }
    this.seekTo(this.get('startFraction') * this.durationS());
  }),

  endFractionObserver: Ember.observer('endFraction', function() {
    if (this.get('currentVideoMotif')) {
      this.set('currentVideoMotif.end_time_ms', this.get('video.duration_ms') * this.get('endFraction'));
    }
    this.seekTo(this.get('endFraction') * this.durationS());
  }),

  didInsertElement() {
    var _this = this;
    this.$().on('mouseenter.video-panel', '.timeline', function(e) {
      _this.set('mouseInsideTimeline', true);
      _this.set('mouseInsideControls', true);
    });
    this.$().on('mouseleave.video-panel', '.timeline', function(e) {
      _this.set('mouseInsideTimeline', false);
    });
    this.$().on('mouseleave.video-panel.controls', '.motif-hover', function(e) {
      _this.set('mouseInsideControls', false);
    });
    this.$().on('click.video-panel', '.timeline', () => {
      _this.seekTo(_this.get('hoverCurrentTime'));
    })
    this.seekTo(this.get('seekTime'));
  },
  willDestroyElement() {
    this.$().off('.video-panel');
    this.$().find(".timeline").off('.video-panel');
  },

  seekTo(position) {
    this.set('seekTime', position);
  },

  setNewMotif(startTimeMs, endTimeMs) {
    this.set('errors', null);
    this.set('currentVideoMotif', this.get('store').createRecord('video-motif'));
    this.set('editingCurrentVideoMotif', true);
    this.set('currentVideoMotif.end_time_ms', endTimeMs);
    this.set('endFraction', endTimeMs / this.get('video.duration_ms'));
    this.set('startFraction', startTimeMs / this.get('video.duration_ms'));
  },

  doSaveVideoMotif(data) {
    var promise = null;
    if (data['id']) {
      promise = this.ajax.patch({
        url: ENV.V1_API_URL + '/video_motifs/' + data['id'],
        data: data
      });
    } else {
      promise = this.ajax.post({
        url: ENV.V1_API_URL + '/video_motifs',
        data: data
      });
    }
    return promise;
  },
  actions: {
    clickTime(sec) {
        this.seekTo(sec);
      },
      doClose() {
        this.sendAction('onClose');
      },
      newTimestampedMotif() {
        if (this.get('auth').isAuthed("Motifs can only be added by users, you must be signed in to continue")) {
          var ct = this.get('currentTime') * 1000;
          this.setNewMotif(ct, Math.min(ct + 3000, this.get('video.duration_ms')));
          this.set('showAddTimedMotifs', true);
        }
      },
      newGeneralMotif() {
        if (this.get('auth').isAuthed("Motifs can only be added by users, you must be signed in to continue")) {
          this.setNewMotif(0, this.get('video.duration_ms'));
          this.set('showAddGeneralMotifs', true);
        }
      },
      addGeneralMotif(motifId) {
        var _this = this;
        var data = {
          'video_motif[video_id]': this.get('video').id,
          'video_motif[motif_id]': motifId,
          'video_motif[start_time_ms]': 0,
          'video_motif[end_time_ms]': _this.get('video.duration_ms')
        };
        this.doSaveVideoMotif(data).then(function(data, xhr) {
          _this.get('video').reload();
        }, function(xhr) {
          if (xhr.status == 422) {
            console.debug("Error: ", xhr.responseJSON);
          }
        });
      },
      closeNewTimedMotif() {
        this.set('showAddTimedMotifs', false);
        this.send('cancelEditCurrentVideoMotif');
      },
      closeNewGeneralMotif() {
        console.log(this.get('video.owner'));
        this.set('showAddGeneralMotifs', false);
        this.send('cancelEditCurrentVideoMotif');
      },
      editVideo() {
        this.sendAction('editVideo', this.get('video.id'));
      },
      editCurrentVideoMotif() {
        this.set('errors', null);
        this.set('startFraction', this.get('currentVideoMotif.start_time_ms') / this.get('video.duration_ms'));
        this.set('endFraction', this.get('currentVideoMotif.end_time_ms') / this.get('video.duration_ms'));
        this.set('editingCurrentVideoMotif', true);
      },
      cancelEditCurrentVideoMotif() {
        var _this = this;
        var vm = this.get('currentVideoMotif');
        if (vm.id) {
          vm.rollbackAttributes();
          this.get('store').find('video-motif', vm.id).then(function(vm) {
            _this.get('store').unloadRecord(vm);
            _this.get('video').reload();
          });
        }
        this.set("currentVideoMotif", null);
        this.set('editingCurrentVideoMotif', false);
      },
      deleteCurrentVideoMotif() {
        var _this = this;
        this.ajax.destroy({
          url: ENV.V1_API_URL + '/video_motifs/' + _this.get('currentVideoMotif.id')
        }).then(function() {
          _this.get('currentVideoMotif').deleteRecord();
          _this.set('currentVideoMotif', null);
          _this.get('video').reload();
          _this.get('messages').info("Motif Deleted");
        });
      },
      saveCurrentVideoMotif() {
        var _this = this;
        var vm = this.get('currentVideoMotif');
        var data = {
          'id': vm.id,
          'video_motif[video_id]': _this.get('video').id,
          'video_motif[motif_id]': vm.get('motif.id'),
          'video_motif[start_time_ms]': vm.get('start_time_ms'),
          'video_motif[end_time_ms]': vm.get('end_time_ms')
        };
        this.doSaveVideoMotif(data).then(function(data, response) {
          var vm = _this.get('currentVideoMotif');
          if (vm.id) {
            vm.reload();
          } else {
            _this.get('video').reload();
          }
          _this.set('currentVideoMotif', null);
          _this.set('editingCurrentVideoMotif', false);
        }, function(xhr) {
          if (xhr.status == 422) {
            _this.set('errors', xhr.responseJSON);
          }
        });
      },

      toggle() {
        this.toggleProperty('play');
      },

      setDraftMotifCurrentVideoMotif(motifId) {
        var _this = this;
        this.get('store').find('motif', motifId).then(function(m) {
          _this.set("currentVideoMotif.motif", m); //_this.set('currentVideoMotif_draftMotif', m);
        });
        this.set('showAddTimedMotifs', false);
      },

      selectVideoMotif(vm) {
        this.set('play', false);
        this.set('currentVideoMotif', vm);
        this.set('editingCurrentVideoMotif', false);
        return true;
      }
  }
});
