import DS from 'ember-data';

export default DS.Model.extend({
    name: DS.attr('string'),
    description: DS.attr('string'),
    createdAt: DS.attr('date'),
    updatedAt: DS.attr('date'),
    image_url: DS.attr('string'),
    icon_url: DS.attr('string'),
    hex_color: DS.attr('string'),
    video_upload: DS.belongsTo('video-upload', {async: true }),
    ancestors: DS.hasMany('motif', { async: true, inverse: null }),
    parent: DS.belongsTo('motif', { async: true }),
    owner: DS.belongsTo('user', { async: true }),
    children: DS.hasMany('motif', { inverse: 'parent', async: true }),
    video_motifs: DS.hasMany('video-motif', { inverse: 'motif', async: true }),
    related_motifs: DS.hasMany('related-motif', { inverse: 'motif1', async: false })
});
