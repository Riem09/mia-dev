import DS from 'ember-data';

export default DS.JSONAPISerializer.extend({
    /**
     @method keyForAttribute
     @param {String} key
     @param {String} method
     @return {String} normalized key
     */
    keyForAttribute: function (key) {
        return Ember.String.underscore(key);
    },

    /**
     @method keyForRelationship
     @param {String} key
     @param {String} typeClass
     @param {String} method
     @return {String} normalized key
     */
    keyForRelationship: function (key) {
        return Ember.String.underscore(key);
    }
});
