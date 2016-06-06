import DS from 'ember-data';
import Ember from 'ember';
const {
  attr,
  hasMany,
  Model
} = DS;
const { computed } = Ember;

export default Model.extend({
  api_key:           attr('string'),
  avatar_url:        attr('string'),
  confirmed_at:      attr('date'),
  first_name:        attr('string'),
  email:             attr('string'),
  last_name:         attr('string'),
  unconfirmed_email: attr('string'),

  isConfirmed: computed('confirmed_at', function() {
    return this.get('confirmed_at');
  }),

  videos: hasMany('videos', {
    async: true
  })
});
