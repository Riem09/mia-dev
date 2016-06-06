import Ember from 'ember';

export default Ember.Service.extend(Ember.Evented, {
    inFlight: false,
    inFlightFieldName: null,
    inFlightFileName: null,
    inFlightDisabledAttr: function () {
        if (this.get('inFlight')) {
            return "disabled";
        } else {
            return '';
        }
    }.property('inFlight'),
    selectFile(fieldName) {
        if (this.get('inFlight')) {
            return false;
        }
        this.set('inFlightFieldName', fieldName);
        this.trigger("openSelectFileDialog");
        return true;
    },
    uploadStarted(filename) {
//        console.debug('DirectUpload uploadStarted');
        this.set('inFlight', true);
        this.set('inFlightFileName', filename);
        this.trigger("uploadStarted", this.get('inFlightFieldName'), filename);
    },
    uploadSucceeded(data, filename) {
        this.trigger("uploadSucceeded", this.get('inFlightFieldName'), data, filename);
        this.complete();
    },
    uploadFailed() {
        this.trigger("uploadFailed", this.get('inFlightFieldName'));
        this.complete();
    },
    windowMessage(data) {
        this.trigger("windowMessage", data);
    },
    complete() {
        this.set('inFlight', false);
        this.set('inFlightFieldName', null);
    }
});