import Ember from 'ember';
import ENV from 'mia-frontend/config/environment';

const {
  inject,
  Service,
  RSVP
} = Ember;

export default Service.extend({
  emberAjax: inject.service(),
  store: inject.service(),
  messages: inject.service(),
  user: null,
  unconfirmedUser: null,

  signout() {
    return new RSVP.Promise((resolve, reject) => {
      this.ajax.destroy({
        url: ENV.V1_API_URL + '/users/sign_out'
      }).then((data, xhr) => {
        this.set('user', null);
        resolve(data, xhr);
      }, (xhr, status, message) => {
        reject(xhr, status, message);
      });
    });
  },

  confirm(data) {
    return new RSVP.Promise((resolve, reject) => {
      $.ajax({
        url: ENV.V1_API_URL + '/users/confirmation',
        data: data,
        success: (data, xhr, status)=> {
          this.get('messages').info('Your account has been confirmed.');
          resolve(data, xhr, status);
        },
        error: reject
      });
    });
  },

  signup(data) {
    return new RSVP.Promise((resolve, reject) => {
      $.ajax({
        url: ENV.V1_API_URL + '/users',
        method: 'POST',
        data: data,
        success: function(data, response) {
          const store = this.get('store');
          store.pushPayload(data);
          this.set('unconfirmedUser', store.peekRecord('user', data.data.id));
          resolve(data, response);
        },
        error: reject
      });
    });
  },

  requestNewPassword(email) {
    return this.ajax.post({
      url: ENV.V1_API_URL + '/users/password',
      data: {
        'user[email]': email
      }
    });
  },

  confirmNewPassword(token, password, passwordConfirmation) {
    return this.ajax.patch({
      url: ENV.V1_API_URL + '/users/password',
      data: {
        'user[reset_password_token]': token,
        'user[password]': password,
        'user[password_confirmation]': passwordConfirmation
      }
    })
  },

  authenticate(username, password) {
    //do an ajax call to the server
    return this.get('emberAjax').request(ENV.V1_API_URL + '/users/authenticate', {
      method: 'POST',
      data: {
        email: username,
        password: password,
      }

    }).then( (data)=> {
      const store = this.get('store');
      store.pushPayload(data);
      this.set('user', store.peekRecord('user', data.data.id));
    });
  },

  hasSession() {
    return !(!Cookies.get('CSRF-TOKEN'));
  },

  /**
   * isAuthed()
   * @author Jamie Spittal <jamie@skyrocket.is>
   * @desc returns true or false based on whether there is a user signed in.
   * @param {string} (optional) Error message to show when not logged in by default this is set to
   * "You must be signed in to continue"
   */
  isAuthed() {
    const message = arguments[0] || "You must be signed in to continue"
    const check = !!this.get('user');

    if (!check) {
      this.get('messages').error(message);
    }

    return check;
  }
});
