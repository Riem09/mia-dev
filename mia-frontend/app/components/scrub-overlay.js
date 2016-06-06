import Ember from 'ember';

export default Ember.Component.extend({
    classNames: ['scrub-overlay'],

    //inputs
    scrubSelector: ".timeline",
    durationS: null,
    stopEvents: false,

    //outputs
    clickTimeS: function (time) { }, //called when clicked
    seekTimeS: 0, //seek time in s
    seekTimeFraction: 0,//seek time in fraction of a second
    hoverTimeS: 0, //hover time in s

    _timelineDrag: false,
    $scrubSelector() {
        return this.$().find(this.get('scrubSelector'));
    },
    clientX2Timeline(clientX) {
        var _this = this;
        var t = _this.$scrubSelector();
        var x = clientX - t.offset().left;
        var fraction = x / (t.outerWidth() * 1.0);
        return fraction * _this.get('durationS');
    },
    seekTo( timeS ) {
        this.set('seekTimeS', timeS);
        this.set('seekTimeFraction', timeS / this.get('durationS'));
    },
    didInsertElement() {
        var _this = this;
        this.$().on('click.scrub-overlay', this.get('scrubSelector'), function (e) {
            _this.sendAction('clickTimeS', _this.clientX2Timeline(e.clientX));
            return !_this.get('stopEvents');
        });
        this.$().on('mousemove.scrub-overlay', function (e) {
            _this.set('hoverTimeS', _this.clientX2Timeline(e.clientX) );
//            console.debug("set hover time ", _this.get('hoverTimeS'));
            if(_this.get('_timelineDrag')) {
                _this.seekTo( _this.clientX2Timeline(e.clientX) );
            }
            return !_this.get('stopEvents');
        });
        this.$().on('mousedown.scrub-overlay', this.get('scrubSelector'), function (e) {
            _this.set('_timelineDrag', true);
            return !_this.get('stopEvents');
        });
        this.$().on('mouseleave.scrub-overlay, mouseup.scrub-overlay', this.get('scrubSelector'), function (e) {
            _this.set('_timelineDrag', false);
            return !_this.get('stopEvents');
        });
    },
    willRemoveElement() {
        this.$().off('.scrub-overlay');
    }
});
