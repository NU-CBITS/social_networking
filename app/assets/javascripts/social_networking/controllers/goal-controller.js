;(function() {
  "use strict";

  // Provides management of goals.
  function GoalCtrl(GoalService, goalTool, currentGoals, studyEndDate) {
    this._goals = GoalService;
    this._goalTool = goalTool;
    this.goalModel = this._goalTool.getModel();
    this.participantGoals = currentGoals;
    this.studyEndDate = studyEndDate;

    this.resetForm();
    this.resetTabs();
    if (typeof $ !== 'undefined') {
      $("#help-pop").popover();
    }
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
    this._goalTool.edit();
  };

  GoalCtrl.prototype.edit = function(goal) {
    this._goalTool.edit(goal);
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

    if (this._goalTool.getModel().id === null) {
      this._goals.create(this._goalTool.getModel())
        .then(function(goal) {
          self.resetForm();
          self.participantGoals.push(goal);
          self.resetTabs();
        })
        .catch(function(message) {
          self.error = message.error;
        });
    } else {
      this._goals.update(this._goalTool.getModel())
        .then(function(goal) {
          // Update the model in the collection.
          self.participantGoals.some(function(g, i, array) {
            if (g.id === goal.id) {
              self._goalTool.copy(goal, g);

              return true;
            }

            return false;
          });
          self.resetForm();
          self.resetTabs();
        })
        .catch(function(message) {
          self.error = message.error;
        });
    }
  };

  // Undo any changes.
  GoalCtrl.prototype.resetForm = function() {
    this._goalTool.setModel();
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
