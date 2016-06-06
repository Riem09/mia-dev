import Ember from 'ember';

export default Ember.Service.extend({
    errorMessage: null,
    infoMessage: null,
    error(msg) {
        this.set('errorMessage', msg);
        this.notifyPropertyChange('errorMessage');
    },
    info(msg) {
        this.set('infoMessage', msg);
        this.notifyPropertyChange('infoMessage');
    }
});
