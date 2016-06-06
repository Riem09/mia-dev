import DS from 'ember-data';
import Util from '../util';

export default DS.Model.extend({
    title: DS.attr('string'),
    description: DS.attr('string'),
    type: DS.attr('string'),
    published: DS.attr('boolean'),
    created_at: DS.attr('date'),
    updated_at: DS.attr('date'),
    duration_ms: DS.attr('number'),
    combined_start_time: DS.attr('number'),
    combined_end_time: DS.attr('number'),
    owner: DS.belongsTo('user', { async: false }),
    video_upload: DS.belongsTo('video-upload', { async: false }),
    video_motifs: DS.hasMany('video-motifs', { async: true }),
    motifs_with_icon: DS.hasMany('motifs', { async: true }),
    createdDateHumanized: function () {
        return Util.humanizeDate(this.get('created_at'));
    }.property('created_at'),
    isComplete: function () {
        return this.get('video_upload.status') == "Complete";
    }.property('video_upload.status'),
    timestampedVideoMotifs: Ember.computed.filterBy('video_motifs', 'isGeneral', false),
    generalVideoMotifs: Ember.computed.filterBy('video_motifs', 'isGeneral', true)
});
