import Ajax from '../services/ajax';

export function initialize(container, application) {
    application.register('ajax:main', Ajax);
    application.inject('controller', 'ajax', 'ajax:main');
    application.inject('service', 'ajax', 'ajax:main');
    application.inject('component', 'ajax', 'ajax:main');
    application.inject('route', 'ajax', 'ajax:main');
}

export default {
  name: 'ajax-initializer',
  initialize: initialize
};
