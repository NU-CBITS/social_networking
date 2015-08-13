;(function() {
  'use strict';

  var ErrorClass = "alert-danger";

  function alertService() {
    return {
      alerts: [],
      addError: function(message) {
        this.getAlerts().push({
          cssClass: ErrorClass,
          message: message
        });
      },
      getAlerts: function() {
        return this.alerts;
      },
      removeAlert: function(alert) {
        var index;

        index = this.getAlerts().indexOf(alert);
        this.getAlerts().splice(index, 1);
      }
    };
  }

  angular.module('socialNetworking.services')
    .factory('alertService', [alertService]);
})();
