;(function() {
  "use strict";

  // Provides management of goals.
  function GoalCtrl(GoalService, focus) {
    var self = this;

    this.resetForm();
    this.resetTabs();
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
    //currentGoal.isCompleted = !currentGoal.isCompleted;
    this._goals.update(currentGoal)
      .catch(function(goal) {
        currentGoal.isCompleted = goal.isCompleted;
      });
  };

  // Persist a goal from the form.
  GoalCtrl.prototype.save = function() {
    var self = this;

    this._goals.create(this)
      .then(function(goal) {
        self.resetForm();
        self.participantGoals.push(goal);
      })
      .catch(function(message) {
        self.error = message.error;
      });
  };

  // Undo any changes.
  GoalCtrl.prototype.resetForm = function() {
    this.description = "";
    this.isCompleted = false;
    this.mode = GoalCtrl.BROWSE_MODE;
  };

  GoalCtrl.prototype.resetTabs = function() {
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
        this.currentFilter = { isCompleted: true };
    }
  };

  GoalCtrl.prototype.selectTab = function(name) {
    this.selectedTab = name;
  };

  // Create a module and register the controller.
  angular.module('socialNetworking.controllers')
    .controller('GoalCtrl', ['Goals', 'focus', GoalCtrl]);
})();
