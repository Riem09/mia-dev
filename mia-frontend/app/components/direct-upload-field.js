import Ember from 'ember';

export default Ember.Component.extend({
    classNames: ['direct-upload-field'],
    directUpload: Ember.inject.service('direct-upload'),
    uploadedFilename: null,
    uploadFailed: false,
    s3_key: null,
    label: 'Select File',
    name: 'uploadField',
    init() {
        this._super();
        this.get('directUpload').on('uploadStarted', this.uploadStarted.bind(this));
        this.get('directUpload').on('uploadSucceeded', this.uploadSucceeded.bind(this));
        this.get('directUpload').on('uploadFailed', this.uploadFailed.bind(this));
    },
    uploadStarted(fieldName, filename) {
        if (fieldName == this.get('name')) {
            this.set('uploadedFilename', filename);
            this.set('inFlight', true);
        }
    },
    uploadSucceeded(fieldName, data, filename) {
        if (fieldName == this.get('name')) {
            this.set('uploadedFilename', filename);
            this.set('s3_key', data.s3_key);
            this.set('inFlight', false);
    //        console.debug('AddVideo uploadSucceeded: ', data);
        }
    },
    uploadFailed(fieldName) {
        if (fieldName == this.get('name')) {
            this.set('uploadFailed', true);
            this.set('inFlight', false);
        }
    },
    actions: {
        selectFile() {
            this.get('directUpload').selectFile( this.get('name') );
        }
    }
});
