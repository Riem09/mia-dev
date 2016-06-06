import Ember from 'ember';

export default Ember.Component.extend({
    classNames: ['motif-form-fields'],
    store: Ember.inject.service('store'),
    motif: null,
    parent: null,
    motifName: Ember.computed.oneWay('motif.name'),
    init() {
        this._super();
        if (this.get('motif') == null) {
            this.set('motif', this.get('store').createRecord('motif'));
        }

        //get parent things
        if(this.get('parent') !== null) {
          this.set('motif.parent', this.get('parent'));
        }
    },
    actions: {
        setParentMotif(motifId) {
            var _this = this;
            this.get('store').find('motif', motifId).then(function (parentMotif) {
                _this.set('motif.parent', parentMotif);
            });
        },
        removeParent() {
            this.set('motif.parent', null);
        }
    }
});
