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

  // Is this only available for goal browsing?
  GoalCtrl.prototype.inBrowseMode = function() {
    return this.mode === GoalCtrl.BROWSE_MODE;
  };

  // Is this available for goal entry?
  GoalCtrl.prototype.inEntryMode = function() {
    return this.mode === GoalCtrl.ENTRY_MODE;
  };

  // Open a form.
  GoalCtrl.prototype.new = function() {
    this.mode = GoalCtrl.ENTRY_MODE;
    this._focus('new-goal');
  };

  // Persist the isCompleted attribute to the server.
  GoalCtrl.prototype.toggleComplete = function(currentGoal) {
    this._goals.update(currentGoal)
      .catch(function(goal) {
        currentGoal.isCompleted = goal.isCompleted;
      });
  };

  // Persist the isDeleted attribute to the server.
  GoalCtrl.prototype.toggleDeleted = function(currentGoal) {
    currentGoal.isDeleted = !currentGoal.isDeleted;
    this._goals.update(currentGoal)
      .catch(function(goal) {
        currentGoal.isDeleted = goal.isDeleted;
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
        this.currentFilter = { isDeleted: false };
        break;
      case 'completed':
        this.currentFilter = { isDeleted: false, isCompleted: true };
        break;
      case 'deleted':
        this.currentFilter = { isDeleted: true };
    }
  };

  // Specify a tab to display.
  GoalCtrl.prototype.selectTab = function(name) {
    this.selectedTab = name;
  };

  GoalCtrl.prototype.dateInNWeeks = function(n) {
    return moment().add(n, 'weeks').format('YYYY-MM-DD');
  };

  GoalCtrl.prototype.dateAtEndOfTrial = function() {
    return moment().format('YYYY-MM-DD');
  };

  // Create a module and register the controller.
  angular.module('socialNetworking.controllers')
    .controller('GoalCtrl', ['Goals', 'focus', GoalCtrl]);
})();
