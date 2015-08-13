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
      }
    };
  }

  angular.module('socialNetworking.services')
    .factory('alertService', [alertService]);
})();
