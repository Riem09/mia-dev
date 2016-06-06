import DS from 'ember-data';

export default DS.Model.extend({
    motif1: DS.belongsTo('motif'),
    motif2: DS.belongsTo('motif', { async: true })
});
