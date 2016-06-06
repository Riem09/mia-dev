import AjaxService from 'ember-ajax/services/ajax';
import ENV from 'mia-frontend/config/environment';

export default AjaxService.extend({
  namespace: ENV.V1_API_URL + ''
});
