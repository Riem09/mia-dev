import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
Router.map(function () {
    this.route('videos', { path: '/videos' }, function () {
      this.route('new', { path: '/new' });
      this.route('show', { path: '/:id' }, function () {
        this.route('motifs', function () {
          this.route('new');
          this.route('show', { path: '/:id' }, function () {
            this.route('edit');
          });
        });
        this.route('edit');
      });
    });
    this.route('motifs', { path: '/motifs' }, function () {
      this.route('show', { path: '/:id' }, function () {
        this.route('edit', { path: '/edit' });
        this.route('related-motifs', { path: '/related-motifs' }, function () {
          this.route('new', { path: '/new' });
        });
      });
      this.route('new', { path: '/new/:parent_id' });
    });
    this.route('sign-in', { path: '/signin' });
    this.route('sign-up', { path: '/signup' });
    this.route('confirm', { path: '/confirm' });

    this.route('users', function () {
      this.route('show', { path: '/:id' });
      this.route('edit');
      this.route('password', function () {
        this.route('edit');
      });
    });
    this.route('search');
    this.route('discover');
    this.route('forgot-password');
  });

});

export default Router;
