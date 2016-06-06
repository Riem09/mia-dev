import DS from 'ember-data';
import Util from '../util';

export default DS.Model.extend({
    start_time_ms: DS.attr('number'),
    end_time_ms: DS.attr('number'),
    created_at: DS.attr('date'),
    updated_at: DS.attr('date'),
    video: DS.belongsTo('video', { async: true }),
    motif: DS.belongsTo('motif', { async: true }),
    owner: DS.belongsTo('user', { async: true }),
    isGeneral: function () {
        return this.get('start_time_ms') == 0 && this.get('end_time_ms') == this.get('video.duration_ms');
    }.property('start_time_ms', 'end_time_ms', 'video.duration_ms'),
    createdDateHumanized: function () {
        return Util.humanizeDate(this.get('created_at'));
    }.property('created_at')
});
