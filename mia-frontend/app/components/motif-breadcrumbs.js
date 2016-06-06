import Ember from 'ember';

export default Ember.Component.extend({
    classNames: ['motif-breadcrumbs'],
    motif: null,
    willDestroyElement() {
      this._super();
      this.set('motif', null);
    }
});
