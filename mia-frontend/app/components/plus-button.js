import Ember from 'ember';

export default Ember.Component.extend({
    classNames: ['plus-button'],
    classNameBindings: ['class'],
    tagName: 'a',
    click() {
//        console.debug('click');
        this.sendAction('onClick');
    }
});
