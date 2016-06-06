import Ember from 'ember';
const {
  Controller,
  inject
} = Ember;

export default Controller.extend({
  auth: inject.service(),
  username: null,
  password: null,

  submit() {
    this.set('errors', null);
    this.get('auth').authenticate(this.get('username'), this.get('password')).then( ()=> {
      this.transitionToRoute('search');

    }).catch( (xhr)=> {
      this.set('error', xhr.responseJSON.error);
    });
  }
});
