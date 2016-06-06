import Ember from 'ember';

export default Ember.Component.extend({

    classNames: ['video-motif-duration'],
    attributeBindings: ['data-ember-action'],
    dataEmberAction: '',
    tagName: 'div',
    totalDuration: 0,
    videoMotif: null,

    leftPosition: function () {
        var result = 0;
        if (this.get('totalDuration') > 0) {
            result = this.get('videoMotif.start_time_ms') / this.get('totalDuration') * 100.0;
        }
        return result;
    }.property('videoMotif.start_time_ms', 'totalDuration'),

    width: function () {
        var result = 100;
        if (this.get('totalDuration') > 0) {
            result = ((this.get('videoMotif.end_time_ms') - this.get('videoMotif.start_time_ms')) / this.get('totalDuration')) * 100.0;
        }
        return result;
    }.property('videoMotif.start_time_ms', 'videoMotif.end_time_ms', 'totalDuration'),

    hexColorObserver: Ember.observer('videoMotif.motif.hex_color', function () {
        this.$().css('background-color', new Ember.Handlebars.SafeString(this.get("videoMotif.motif.hex_color")));
    }).on('didInsertElement'),

    leftPositionObserver: Ember.observer('leftPosition', function () {
        this.$().css('left', new Ember.Handlebars.SafeString(this.get('leftPosition') + "%" ));
    }).on('didInsertElement'),

    widthObserver: Ember.observer('width', function () {
        this.$().css('width', new Ember.Handlebars.SafeString(this.get('width') + "%"));
    }).on('didInsertElement'),

//    mousedown: function () {
////        this.sendAction('action', this.get('videoMotif'));
//        return true;
//    }

    didInsertElement() {
        var _this = this;
        this.$().on('click.video-motif-duration', function () {
            _this.sendAction('action', _this.get('videoMotif'));
            return true;
        });
    },
    willDestroyElement() {
        this.$().off('.video-motif-duration');
    }
});
