;(function() {
  "use strict";

  // Displays pertinent information about a participant.
  function profileStatus() {
    return {
      template: '<h2>{{ profile.username }}</h2>' +
                '<h3>{{ profile.lastLogin | timeFromNow }}</h3>'
    };
  }

  // Summarizes an item to be displayed in a feed.
  function feedItem() {
    return {
      template: '<p>{{ item.creator }}</p>' +
                '<p>{{ item.createdAt | timeFromNow }}</p>'
    };
  }

  // Summarizes an individual goal.
  function goal() {
    return {
      template: '<p><input type="checkbox" ng-model="participantGoal.isCompleted" ng-change="goal.toggleComplete(participantGoal)"> {{ participantGoal.description }}</p>'
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
    .directive('feedItem', feedItem)
    .directive('goal', goal)
    .directive('focusOn', focusOn);
})();
