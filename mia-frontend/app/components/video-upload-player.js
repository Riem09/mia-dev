import Ember from 'ember';
import ENV from 'mia-frontend/config/environment';

export default Ember.Component.extend({
  classNames: ['video-upload-player'],
  classNameBindings: ['play'],
  videoUpload: {},
  playbackRate: 1,
  muted: true,
  overlay: false,

  //if the user wants to have the current time
  currentTime: null,
  currentFraction: null,

  //sets the lower limit of the loop
  startTimeMs: null,

  //sets current position of playback
  seekTime: null,

  endTimeMs: null,
  loop: true,
  volume: 0.5,
  play: false,
  currentlyPlaying: false,

  playScroll: false,
  topBoundary: 0,
  bottomBoundary: 0,

  isLoaded: false,

  _store: Ember.inject.service('store'),

  videoElem() {
    return this.$video()[0];
  },
  $video() {
    return this.$().find('video');
  },
  $webm() {
    return this.$video().find('source[type="video/webm"]');
  },
  $mp4() {
    return this.$video().find('source[type="video/mp4"]');
  },
  updateWebm() {
    var parameter = new Date().getMilliseconds();
    this.$webm().attr('src', this.get('videoUpload.webm_video_url') + "?random=" + parameter);
    this.videoElem().load();
  },
  updateMp4() {
    var parameter = new Date().getMilliseconds();
    this.$mp4().attr('src', this.get('videoUpload.mp4_video_url') + "?random=" + parameter);
    this.videoElem().load();
  },
  updateVideoPlayer() {
    var ve = this.videoElem();
    ve.playbackRate = this.get('playbackRate');
    ve.muted = this.get('muted');
    ve.loop = this.get('loop');
    ve.volume = this.get('volume');
  },
  checkEndTimeMs() {
    if (!this.get('endTimeMs')) {
      this.set('endTimeMs', this.get('videoUpload.duration_ms'));
    }
  },
  startTime() {
    var result = 0;
    if (this.get('seekTime')) {
      result = this.get('seekTime');
    } else if (this.get('startTimeMs')) {
      result = this.get('startTimeMs') / 1000.0;
    }
    return result;
  },
  loopStartTime() {
    return this.get('startTimeMs') / 1000.0;
  },
  endLimit() {
    var ms = 0;
    if (this.get('endTimeMs')) {
      ms = this.get('endTimeMs');
    } else {
      ms = this.get('videoUpload.duration_ms');
    }
    return ms / 1000.0;
  },
  playVideo() {
    if (this.$()) {
      this.videoElem().play();
      this.set('currentlyPlaying', true);
      this.startWatcher();
    }
  },
  pauseVideo() {
    if (this.$()) {
      this.videoElem().pause();
      this.set('currentlyPlaying', false);
      this.stopWatcher();
    }
  },
  startWatcher() {
    var _this = this;
    if (this.watchInterval == null) {
      var interval = window.setInterval(function() {
        Ember.run(function() {
          if (_this.videoElem().currentTime > _this.endLimit()) {
            _this.set('seekTime', _this.loopStartTime());
            _this.notifyPropertyChange('seekTime');
          } else {
            _this.set('currentTime', _this.videoElem().currentTime);
            _this.set('currentFraction', _this.videoElem().currentTime / _this.get('videoUpload.durationS'));
          }
        });
      }, 50);
      this.watchInterval = interval;
    }
  },
  stopWatcher() {
    var interval = this.watchInterval;
    window.clearInterval(interval);
    this.watchInterval = null;
  },
  setTime(t) {
    var _this = this;
    t = parseFloat(t);
    t = t.toFixed(4);
    _this.videoElem().currentTime = t;
    Ember.run.once(this, function() {
      _this.set('currentTime', t);
      _this.set('currentFraction', t / _this.get('videoUpload.durationS'));
    });
  },

  interval: function() {
    return 5000; // Time between polls (in ms)
  }.property().readOnly(),

  // Schedules the function `f` to be executed every `interval` time.
  schedule: function(f) {
    return Ember.run.later(this, function() {
      f.apply(this);
      var complete = this.get('videoUpload.isComplete');
      if (!complete) {
        this.set('timer', this.schedule(f));
      }
    }, this.get('interval'));
  },

  // Stops the pollster
  stop: function() {
    Ember.run.cancel(this.get('timer'));
  },

  // Starts the pollster, i.e. executes the `onPoll` function every interval.
  start: function() {
    if (!this.get('timer')) {
      this.set('timer', this.schedule(this.get('onPoll')));
    }
  },

  onPoll: function() {
    var _this = this;
    var videoId = this.get('videoUpload.id');
    if (videoId) {
      this.ajax.doGet({
        url: ENV.V1_API_URL + '/video_uploads/' + videoId
      }).then(function(data, status, xhr) {
        _this.get('_store').pushPayload(data);
      }, function(response) {
        console.error(response);
      });
    }
  },

  completeObserver: Ember.observer('videoUpload.isComplete', function() {
    var complete = this.get('videoUpload.isComplete');
    if (complete) {
      this.stop();
    } else {
      this.start();
    }
  }).on('didInsertElement'),
  startScrollListener() {
    let self = this;
    $(window).scroll(() => Ember.run.debounce(self, self.checkToPlayOnScroll(), 50));
    $(window).resize(() => Ember.run.debounce(self, self.checkToPlayOnScroll(), 50));
  },
  didInsertElement() {

    if(this.get('playScroll')) {
      this.startScrollListener()
      this.getBoundaries();
    }

    this.addObserver('videoUpload.status', this, function() {
      this.updateWebm();
      this.updateMp4();
    });
    this.addObserver('muted', this, this.updateVideoPlayer);
    this.addObserver('playbackRate', this, this.updateVideoPlayer);
    this.addObserver('loop', this, this.updateVideoPlayer);
    this.addObserver('volume', this, this.updateVideoPlayer);
    this.addObserver('seekTime', this, function() {
      this.setTime(_this.get('seekTime'));
    });
    this.addObserver('play', this, function() {
        if(this.get('currentlyPlaying')) {
            this.pauseVideo();
        } else {
            this.playVideo();
        }
    });
    var _this = this;
    this.$video().on('loadeddata.video-upload-player', function() {
      Ember.run(function() {
        _this.set('isLoaded', true);
        _this.$().find('.video-container').css('opacity', 1);
        _this.updateVideoPlayer();
        _this.setTime(_this.startTime());

        if (_this.get('play')) {
          _this.playVideo();
        }
      });
    });
    Ember.run.scheduleOnce('afterRender', this, function() {
      _this.updateWebm();
      _this.updateMp4();
    });
  },
  getBoundaries() {
    let offsets = this.$().offset();
    let height = this.$().height();

    this.set('topBoundary', offsets.top);
    this.set('bottomBoundary', offsets.top + height);
  },
  checkToPlayOnScroll() {
    let topOfViewPort = window.scrollY;
    let bottomOfViewPort = window.innerHeight + window.scrollY + 20;

    if (this.get('topBoundary') > topOfViewPort && this.get('bottomBoundary') < bottomOfViewPort) {
      this.playVideo();
    } else {
      this.pauseVideo();
    }
  },
  willDestroyElement() {
    this.stopWatcher();
    this.$video().children().filter("video").each(function() {
      this.pause();
      delete this;
      $(this).remove();
    });
    this.$video().empty();
    this.$video().load();
    this.$video().off('.video-upload-player');
  }
});
