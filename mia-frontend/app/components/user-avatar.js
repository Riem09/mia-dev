import Ember from 'ember';

export default Ember.Component.extend({
    classNames: ['user-avatar'],
    user: null,
    style: function () {
        var avatar = this.get('user.avatar_url') || "https://cdn0.vox-cdn.com/images/verge/default-avatar.v9899025.gif"
        return new Ember.Handlebars.SafeString("background-image: url('"+avatar+"');");
    }.property('user.avatar_url')
});
