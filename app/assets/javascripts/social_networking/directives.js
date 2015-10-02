;(function() {
  "use strict";

  // Displays pertinent information about a profile.
  function profileStatus() {
    return {
      template: '<h2>{{ profile.username }}</h2>' +
                '<h3 ng-class="profile.isAdmin ? \'transparent\' : \'\'">' +
                  'Last seen: {{ profile.latestAction | timeFromNow }}' +
                '</h3>'
    };
  }

  // Listen for 'focusOn' event and focus on the input.
  function focusOn() {
    return function(scope, elem, attr) {
      return scope.$on('focusOn', function(e, name) {
        if (name === attr.focusOn) {
          return elem[0].focus();
        }
      });
    };
  }

  // Create a module and register the directives.
  angular.module('socialNetworking.directives', [])
    .directive('profileStatus', profileStatus)
    .directive('focusOn', focusOn);
})();
