import Ember from 'ember';

export default Ember.Component.extend({
    directUpload: Ember.inject.service('direct-upload'),
    inFlight: Ember.computed.alias('directUpload.inFlight'),
    value: 'Submit'
});
