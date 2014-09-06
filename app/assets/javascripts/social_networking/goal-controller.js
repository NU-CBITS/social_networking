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

  GoalCtrl.BROWSE_MODE = 1;
  GoalCtrl.ENTRY_MODE = 2;

  GoalCtrl.prototype.inBrowseMode = function() {
    return this.mode === GoalCtrl.BROWSE_MODE;
  };

  GoalCtrl.prototype.inEntryMode = function() {
    return this.mode === GoalCtrl.ENTRY_MODE;
  };

  // Open a form.
  GoalCtrl.prototype.new = function() {
    this.mode = GoalCtrl.ENTRY_MODE;
  };

  // Persist a goal.
  GoalCtrl.prototype.save = function() {
    var self = this;

    this._goals.create({ description: this.description })
      .then(function(goal) {
        self.reset();
        self.participantGoals.push(goal);
      })
      .catch(function(message) {
        self.error = message.error;
      });
  };

  // Undo any changes.
  GoalCtrl.prototype.reset = function() {
    this.description = "";
    this.mode = GoalCtrl.BROWSE_MODE;
  };

  // Create a module and register the controller.
  angular.module('socialNetworking.controllers')
    .controller('GoalCtrl', ['Goals', GoalCtrl]);
})();
