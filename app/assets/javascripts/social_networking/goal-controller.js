;(function() {
  "use strict";

  // Provides management of goals.
  function GoalCtrl(GoalService) {
    var self = this;

    this._goals = GoalService;
    this.reset();
    this._goals.getAll()
      .then(function(goals) {
        self.members = goals;
      });
  }

  // Persist a goal.
  GoalCtrl.prototype.save = function() {
    var self = this;

    this._goals.create({ description: this.description })
      .then(function() {
        self.reset();
      });
  };

  // Undo any changes.
  GoalCtrl.prototype.reset = function() {
    this.description = "";
  };

  // Create a module and register the controller.
  angular.module('socialNetworking.controllers')
    .controller('GoalCtrl', ['Goals', GoalCtrl]);
})();
