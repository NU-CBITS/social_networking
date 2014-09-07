;(function() {
  "use strict";

  // Provides management of goals.
  function GoalCtrl(GoalService, focus) {
    var self = this;

    this.reset();
    this.participantGoals = [];
    this._goals = GoalService;
    this._focus = focus;
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
    this._focus('new-goal');
  };

  GoalCtrl.prototype.toggleComplete = function(currentGoal) {
    //currentGoal.isComplete = !currentGoal.isComplete;
    this._goals.update(currentGoal)
      .catch(function(goal) {
        currentGoal.isComplete = goal.isComplete;
      });
  };

  // Persist a goal.
  GoalCtrl.prototype.save = function() {
    var self = this;

    this._goals.create(this)
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
    this.isComplete = false;
    this.mode = GoalCtrl.BROWSE_MODE;
    this.filter('all');
    this.selectTab('all');
  };

  // Select the current subset of goals to display.
  GoalCtrl.prototype.filter = function(type) {
    switch(type) {
      case 'all':
        this.currentFilter = {};
        break;
      case 'completed':
        this.currentFilter = { isComplete: true };
    }
  };

  GoalCtrl.prototype.selectTab = function(name) {
    this.selectedTab = name;
  };

  // Create a module and register the controller.
  angular.module('socialNetworking.controllers')
    .controller('GoalCtrl', ['Goals', 'focus', GoalCtrl]);
})();
