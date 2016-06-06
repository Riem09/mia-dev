import DS from 'ember-data';
import $ from 'jquery';
const { JSONAPIAdapter } = DS;
import Ember from 'ember';
const {
  computed,
  inject
} = Ember;

export default JSONAPIAdapter.extend({
  namespace: 'api',
  auth: inject.service(),

  headers: computed('auth.user.api_key', function(){
    return {
      "X-CSRF-Token": $('meta[name="csrf-token"]').attr('content'),
      "X-API-Key": this.get('auth.user.api_key')
    };
  }),

  pathForType(typeName) {
    switch (typeName) {
      case "uploaded-video":
        return "videos";
      case "video-motif":
        return 'video_motifs';
      case "related-motif":
        return 'related_motifs';
      case "motif-ancestor":
        return 'motif_ancestor';
      default:
        return this._super(typeName);
    }
  },

  shouldBackgroundReloadRecord() {
    return true;
  }
});
