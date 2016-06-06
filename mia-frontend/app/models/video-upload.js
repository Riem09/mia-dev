import DS from 'ember-data';

export default DS.Model.extend({
    source_video: DS.attr('string'),
    webm_video_url: DS.attr('string'),
    mp4_video_url: DS.attr('string'),
    duration_ms: DS.attr('number'),
    status: DS.attr('string'),
    message: DS.attr('string'),
    user: DS.belongsTo('user'),
    isReady: function () {
        return this.get('status') == 'Complete';
    }.property('status'),
    isComplete: function () {
        var status = this.get('status');
        return (status == 'Complete' || status == 'Error' || status == 'Canceled');
    }.property('status'),
    statusMessage: function () {
        var status = this.get('status');
        var message = "";
        switch (status) {
            case 'Submitted':
            case 'Progressing':
                message = "MIA is processing the video. This may take a few minutes.";
                break;
            case 'Canceled':
                message = "The video processing was canceled.";
                break;
            case 'Error':
                message = "We're sorry; we could not process the video.";
                break;
            case 'Complete':
                message = "The video has been processed.";
                break;
        }
        return message;
    }.property('status'),
    durationS: function () {
        return this.get('duration_ms') / 1000.0;
    }.property('duration_ms')
});
