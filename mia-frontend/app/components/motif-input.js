import Ember from 'ember';
import ENV from 'mia-frontend/config/environment';

export default Ember.Component.extend({
  value: null,
  classNames: ['motif-input'],
  name: 'motif-input',
  addMotifId: function(motif) {},
  addKeyword: function(keyword) {},
  placeholder: 'Enter a motif',
  placeholderService: Ember.inject.service('placeholder'),

  full: false,
  autoWriting: false,

  _store: Ember.inject.service('store'),
  _engine: null,
  _templates: {
    suggestion: null
  },

  actions: {
    keyDown(val, event) {
      //            console.debug("keyDown: ", val, event);
      if (event.keyCode == 13) {
        var keyword = this.get('value');
        if (keyword && keyword !== '') {
          event.preventDefault();
          this.sendAction('addKeyword', keyword);
          this.set('value', '');
        }
      }
    }
  },
  init() {
    this._super();
    this._templates.suggestion = Handlebars.compile($('script.template-suggestion').html());
  },
  selectMotif: function(event, motif) {
    event.stopPropagation();
    event.preventDefault();
    this.sendAction('addMotifId', motif.id);
    this.set('value', '');
  },
  willDestroyElement() {
    this._super();
    this.$().find('input').unbind('typeahead:select');
    if(this.get('autoWriting')) {
      this.get('placeholderService').stop();
    }
  },
  didInsertElement() {
    this._super();
    var _this = this;
    this.$().find('input').bind('typeahead:select', function(event, motif) {
      Em.run.schedule('actions', _this, function() {
        _this.selectMotif(event, motif);
      });
    });
    this._engine = new Bloodhound({
      initialize: false,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      datumTokenizer: Bloodhound.tokenizers.whitespace,
      identify: function(datum) {
        return data.attributes.id;
      },
      remote: {
        url: ENV.V1_API_URL + '/motifs/typeahead',
        prepare: function(query, settings) {
          return $.extend(settings, {
            data: {
              q: query
            }
          });
        },
        transform: function(response) {
          return response;
        }
      }
    });
    new Ember.RSVP.Promise(function(resolve, reject) {
      _this._engine.initialize().done(resolve).fail(reject);
    }).then(function() {
      _this.input().typeahead({
        minLength: 2,
        highlight: true
      }, {
        name: 'motifs',
        source: _this._engine,
        limit: 10,
        display: function(obj) {
          if (obj.length > 0) {
            return obj[0].attributes.name;
          }
          return null;
        },
        templates: {
          suggestion: function(obj) {
            return _this._templates.suggestion(obj);
          },
          notFound: [
            '<div class="empty-message">',
            'No motifs that match your search.',
            '</div>'
          ].join('\n'),
        }
      });
      _this.$().find('input.tt-input').focus();
    }, function(err) {
      console.debug(err);
    });

    if (this.get('full')) {
      this.classNames.push('full');
    }

    if(this.get('autoWriting')) {
      console.log(this.input());
      this.get('placeholderService').beginWriting(this.input(), 2000)
    }
  },
  input() {
    return this.$().find('input');
  }
});
