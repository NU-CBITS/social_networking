;(function() {
  'use strict';

  function Goals($resource) {
    var GoalResource = $resource('/social_networking/goals/:id',
      { id: '@id' });

    function Goal() {}

    Goal.create = function(attributes) {
      var goal = new GoalResource({
        description: attributes.description
      });
      goal.$save();
    };

    return Goal;
  }

  angular.module('socialNetworking.services')
    .service('Goals', ['$resource', Goals]);
})();
