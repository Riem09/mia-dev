import Ember from 'ember';

export default Ember.Controller.extend({
    queryParams: ['motif_ids', 'keywords', 'refresh'],
    motif_ids: null,
    keywords: null
});
