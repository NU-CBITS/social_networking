;(function() {
  'use strict';

  var ErrorClass = "alert-danger";

  function alertService() {
    return {
      alerts: [],
      addError: function(message) {
        this.alerts.push({
          cssClass: ErrorClass,
          message: message
        });
      },
      removeAlert: function(alert) {
        var index;

        index = this.alerts.indexOf(alert);
        this.alerts.splice(index, 1);
      }
    };
  }

  angular.module('socialNetworking.services')
    .factory('alertService', [alertService]);
})();
