import Ember from 'ember';
import ENV from 'mia-frontend/config/environment';


export default Ember.Controller.extend({
    auth: Ember.inject.service('auth'),
    actions: {
        updateMotif: function(data) {
            var _this = this;
            if (this.get('auth').isAuthed()) {
                this.set('errors', null);
                this.ajax.put({
                    url: ENV.V1_API_URL + '/motifs/' + _this.get('motif.id'),
                    data: data
                }).then(function(model) {
                    _this.get('store').pushPayload(model);
                    _this.replaceRoute('motifs.show', _this.get('motif.id'));
                }, function(xhr) {
                    if (xhr.status == 422) {
                        _this.set('errors', xhr.responseJSON);
                    }
                });
            }
        },
        deleteMotif(motif) {
            var _this = this;
            if (this.get('auth').isAuthed()) {
                if (window.confirm("Are you sure you want to delete the motif '" + motif.get('name') + "'?")) {
                    new Ember.RSVP.Promise(function(resolve, reject) {
                        $.ajax({
                            url: ENV.V1_API_URL + '/motifs/' + motif.id,
                            method: 'DELETE',
                            success: resolve,
                            error: reject
                        });
                    }).then(function() {
                        motif.deleteRecord();
                        if (motif.get('parent')) {
                            _this.transitionToRoute('motifs.show', motif.get('parent.id'));
                        } else {
                            _this.transitionToRoute('motifs');
                        }
                    });
                }
            }
        }
    }
});
