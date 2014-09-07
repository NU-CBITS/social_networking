;(function() {
  'use strict';

  // Service to broadcast a 'focusOn' event to facilitate form input autofocus
  function focus($rootScope, $timeout) {
    return function(name) {
      return $timeout(function() {
        return $rootScope.$broadcast('focusOn', name);
      });
    };
  }

  angular.module('socialNetworking.services')
    .factory('focus', ['$rootScope', '$timeout', focus]);
})();
