;(function() {
  "use strict";

  // Provides management of goals.
  function GoalCtrl(GoalService) {
    var self = this;

    this.reset();
    this.participantGoals = [];
    this._goals = GoalService;
    this._goals.getAll()
      .then(function(goals) {
        self.participantGoals = goals;
      });
  }

  // Persist a goal.
  GoalCtrl.prototype.save = function() {
    var self = this;

    this._goals.create({ description: this.description })
      .then(function(goal) {
        self.reset();
        self.participantGoals.push(goal);
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
