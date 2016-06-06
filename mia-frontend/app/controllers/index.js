import Ember from 'ember';

export default Ember.Controller.extend({
  store: Ember.inject.service('store'),
  auth: Ember.inject.service('auth'),
  messages: Ember.inject.service('messages'),
  user: Ember.computed.alias('auth.user'),
  placeHolder: Ember.inject.service('placeholder'),
  motifs: [],
  motifIds: Ember.computed.mapBy('motifs', 'id'),
  avatar_url: function() {
    return this.get('user.avatar_url') || "https://cdn0.vox-cdn.com/images/verge/default-avatar.v9899025.gif"
  }.property('user'),
  init: function() {
    setTimeout(() => {
      if(this.get('auth').isAuthed()) {
          $(".password-barrier").hide();
      }
    }, 0);
  },
  actions: {
    toggleHeaderShow() {
        let index = $('.index');
        if (index.hasClass('open')) {
          $('.index').removeClass('open');
        } else {
          $('.index').addClass('open');
        }
      },
      removeMotif(motif) {
        var motifs = this.get('motifs');
        motifs = motifs.filter(function(elem) {
          return elem.id != motif.id;
        });
        this.set('motifs', motifs);
      },
      doSearch() {
        this.transitionToRoute('search', {
          queryParams: {
            motif_ids: this.get('motifIds')
          }
        });
      },
      addMotif(motifId) {
        var _this = this;
        this.get('store').find('motif', motifId).then(function(motif) {
          _this.get('motifs').addObject(motif);
        });
      },
      signOut() {
          this.get('auth').signout().then(function () {
          }, function (status) {
              console.error(status);
          });
      }
  }
});
