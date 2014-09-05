;(function() {
  "use strict";

  // Provides management of goals.
  function GoalCtrl(Goals) {
    this._goals = Goals;
    this.description = "";
  }

  // Persist a goal.
  GoalCtrl.prototype.save = function() {
    this._goals.create({ description: this.description });
  };

  // Create a module and register the controller.
  angular.module('socialNetworking.controllers')
    .controller('GoalCtrl', ['Goals', GoalCtrl]);
})();
