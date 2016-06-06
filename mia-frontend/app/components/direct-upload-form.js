import Ember from 'ember';

export default Ember.Component.extend({

    _directUpload: Ember.inject.service('direct-upload'),
    _fieldName: Ember.computed.alias("_directUpload.inFlightFieldName"),

    init() {
        this._super();
        var di = this.get("_directUpload");
        var _this = this;
        di.on("openSelectFileDialog", function () {
            _this.openSelectFileDialog();
        });
    },

    iframe() {
        return this.$().find('iframe');
    },

    fileInput() {
        return this.$().find('[type="file"]');
    },

    form() {
        return this.$().find('form');
    },

    railsEnv() {
        return this.$().find('[data-rails-env]').data('rails-env');
    },

    openSelectFileDialog() {
        if (this.railsEnv() != "test") {
            this.fileInput().click();
        }
    },

    checkFailure() {
        if (this.get('inFlight')) {
            this.get('_directUpload').uploadFailed();
            this.completeUpload();
        }
    },

    completeUpload() {
        window.clearTimeout( this.get('_failTimeout') );
        this.fileInput().val('')
        this.set('_failTimeout', null);
        this.set("_fieldName",null);

    },

    filename() {
        return this.fileInput()[0].files[0].name;
    },

    didInsertElement() {

        var _this = this;
        this.iframe().on('load', function () {
            _this.set('_failTimeout', setTimeout(_this.checkFailure.bind(_this), 500) );
        });
        this.fileInput().on('change', function (e) {
            _this.form().submit();
//            console.debug('DirectUploadForm inputChanged');
            _this.get('_directUpload').uploadStarted( _this.filename() );
        });

        var _this = this;
        $(window).on("message.directUpload", function (e) {
            //console.debug("Received message: ", e);
            var url = document.location;
            if (window.location != window.parent.location) {
                url = document.referrer;
            }
            if (e.originalEvent.origin == url.origin) {
                var data = e.originalEvent.data;
                if (data && $.type(data) == 'string' && data.indexOf("s3_key") > -1) {
                    data = JSON.parse(data);
                    var filename = data.s3_key.split('/').pop();
                    _this.get('_directUpload').uploadSucceeded(data, filename);
                    _this.completeUpload();
                }
            }
        });
    },

    willDestroyElement() {
        $(window).off(".directUpload");
    }

});
