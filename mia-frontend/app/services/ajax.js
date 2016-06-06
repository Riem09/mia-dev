import Ember from 'ember';

export default Ember.Service.extend({
    messaging: Ember.inject.service('messages'),
    post: function (hash) {
        return this.ajax($.extend(hash, { method: 'POST' }));
    },
    put: function (hash) {
        return this.ajax($.extend(hash, { method: 'PUT' }));
    },
    patch: function (hash) {
        return this.ajax($.extend(hash, { method: 'PATCH' }));
    },
    destroy: function (hash) {
        return this.ajax($.extend(hash, { method: 'DELETE' }));
    },
    doGet: function (hash) {
        return this.ajax($.extend(hash, { method: 'GET' }));
    },
    ajax: function (hash) {
        var _this = this;
        return new Ember.RSVP.Promise(function (resolve, reject) {
            $.ajax($.extend(hash, {
                success: resolve,
                error: function (xhr, status, errorThrown) {
                    switch(xhr.status) {
                        case 401:
                        case 403:
                            _this.get('messaging').error(xhr.responseText);
                            break;
                    }
//                    console.error(xhr, status, errorThrown);
                    reject(xhr, status, errorThrown);
                }
            }));
        });
    }
});
