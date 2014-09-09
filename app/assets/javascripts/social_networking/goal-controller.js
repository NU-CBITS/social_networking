;(function() {
  "use strict";

  // Provides management of goals.
  function GoalCtrl(GoalService, goalTool, currentGoals, studyEndDate) {
    this._goals = GoalService;
    this._goalTool = goalTool;
    this.goalModel = this._goalTool.goalModel;
    this.participantGoals = currentGoals;
    this.studyEndDate = studyEndDate;

    this.resetForm();
    this.resetTabs();
  }

  // Is this only available for goal browsing?
  GoalCtrl.prototype.inBrowseMode = function() {
    return this._goalTool.getMode() === this._goalTool.BROWSE_MODE;
  };

  // Is this available for goal entry?
  GoalCtrl.prototype.inEntryMode = function() {
    return this._goalTool.getMode() === this._goalTool.ENTRY_MODE;
  };

  // Open a form.
  GoalCtrl.prototype.new = function() {
    this._goalTool.new();
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

    this._goals.create(this._goalTool.goalModel)
      .then(function(goal) {
        self.resetForm();
        self.participantGoals.push(goal);
        self.resetTabs();
      })
      .catch(function(message) {
        self.error = message.error;
      });
  };

  // Undo any changes.
  GoalCtrl.prototype.resetForm = function() {
    this._goalTool.resetForm();
    this._goalTool.setMode(this._goalTool.BROWSE_MODE);
  };

  GoalCtrl.prototype.resetTabs = function() {
    this._goalTool.setFilter('all');
    this._goalTool.setTab('all');
  };

  GoalCtrl.prototype.setTab = function(name) {
    this._goalTool.setTab(name);
  };

  GoalCtrl.prototype.getTab = function() {
    return this._goalTool.getTab();
  };

  GoalCtrl.prototype.dateInNWeeks = function(n) {
    return moment().add(n, 'weeks').format('YYYY-MM-DD');
  };

  GoalCtrl.prototype.dateAtEndOfTrial = function() {
    return moment(this.studyEndDate).format('YYYY-MM-DD');
  };

  GoalCtrl.prototype.atLeastNWeeksLeftInTrial = function(n) {
    return moment().add(n, 'weeks').isBefore(moment(this.studyEndDate));
  };

  GoalCtrl.prototype.setFilter = function(type) {
    this._goalTool.setFilter(type);
  };

  GoalCtrl.prototype.getFilter = function() {
    return this._goalTool.getFilter();
  };

  // Create a module and register the controller.
  angular.module('socialNetworking.controllers')
    .controller('GoalCtrl', ['Goals', 'goalTool', 'currentGoals',
                'participantStudyEndDate', GoalCtrl]);
})();
