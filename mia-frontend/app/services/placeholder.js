import Ember from 'ember';
import ENV from 'mia-frontend/config/environment';

export default Ember.Service.extend({
  input: null,
  lockTime: 50,
  waitTime: 1000,
  states: {
    ACTIVE: 'active',
    STOPPED: 'stopped'
  },
  currentState: 'stopped',
  getRandomMotif() {
    let self = this;
    return new Promise((resolve, reject) => {
      self.ajax.doGet({
        url: ENV.V1_API_URL + '/motifs/random'
      }).then(
        (data) => resolve(data.name),
        (error) => reject(error)
      );
    });
  },

  getPlaceholder() {
    return this.get('input').attr('placeholder');
  },
  setPlaceholder(text) {
    return this.get('input').attr('placeholder', text);
  },

  beginWriting(input) {
    this.set('input', input);
    if(arguments[1]) {
      this.set('waitTime', arguments[1]);
    }

    setTimeout(() => {
      this.set('currentState', this.get('states').ACTIVE);
      this.popAndLock(this.getPlaceholder().split(''));
    }, this.get('waitTime'));
  },

  getMotifAndAnimate() {
    let self = this;
    this.getRandomMotif().then(
      (name) => {
        self.addAndLock(name.split(''));
      }
    );
  },

  popAndLock(text) {
    let self = this;

    if(this.get('currentState') === this.get('states').ACTIVE) {
      setTimeout(() => {
        text.pop();
        self.setPlaceholder(text.join(''));
        if(text.length === 0) {
          self.getMotifAndAnimate();
        } else {
          self.popAndLock(text);
        }
      }, self.get('lockTime'));
    }
  },
  addAndLock(originalText) {
    let self = this;

    if(this.get('currentState') === this.get('states').ACTIVE) {
      let limit = originalText.length;
      let text = arguments[1] || [];
      let i = arguments[2] || 0;

      setTimeout(() => {
        if(i < limit) {
          text.push(originalText[i]);
          self.setPlaceholder(text.join(''));
          i++;
          self.addAndLock(originalText, text, i);
        } else {
          setTimeout(() => { self.popAndLock(originalText)}, this.get('waitTime'));
        }
      }, self.get('lockTime'));
    }
  },
  stop() {
    this.set('currentState', this.get('states').STOPPED);
  }
});
