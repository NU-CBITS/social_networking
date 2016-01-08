;(function() {
  "use strict";

  // Provides management of goals.
  function GoalCtrl(GoalService, goalTool, currentGoals,
                    studyEndDate, noticesEnabled, noticeUtility) {
    this._goals = GoalService;
    this._goalTool = goalTool;
    this.goalModel = this._goalTool.getModel();
    this.participantGoals = currentGoals;
    this.studyEndDate = studyEndDate;
    this.noticesEnabled = noticesEnabled;
    this.noticeUtility = noticeUtility;

    this.resetForm();
    this.resetTabs();
    if (typeof $ !== 'undefined') {
      $("#help-pop").popover({
        html: true
      });
    }
  }

  // Is this only available for goal browsing?
  GoalCtrl.prototype.inBrowseMode = function() {
    return this._goalTool.getMode() === this._goalTool.MODES.BROWSE;
  };

  // Is this available for goal entry?
  GoalCtrl.prototype.inEntryMode = function() {
    return this._goalTool.getMode() === this._goalTool.MODES.ENTRY;
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
    if (window.confirm("Are you sure you would like to mark this goal as complete? This action cannot be undone.")) {
      currentGoal.isCompleted = !currentGoal.isCompleted;
      this._goals.update(currentGoal)
        .catch(function(goal) {
          currentGoal.isCompleted = goal.isCompleted;
        });
      if(this.noticesEnabled && this.noticeUtility) {
        this.noticeUtility.actionNotice("SocialNetworking::Goal",
                            "Complete a goal.",
                            currentGoal.participantId);
      }
    }
  };

  // Persist the isDeleted attribute to the server.
  GoalCtrl.prototype.toggleDeleted = function(currentGoal) {
    if (window.confirm("Are you sure you would like to delete this goal? This action cannot be undone.")) {
      currentGoal.isDeleted = !currentGoal.isDeleted;
      this._goals.update(currentGoal)
        .catch(function (goal) {
          currentGoal.isDeleted = goal.isDeleted;
        });
    }
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
          if(self.noticesEnabled && self.noticeUtility) {
            self.noticeUtility.actionNotice("SocialNetworking::Goal",
                                "Create a goal.",
                                goal.participantId);
          }
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
    this._goalTool.setMode(this._goalTool.MODES.BROWSE);
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

  GoalCtrl.prototype.dateInNWeeks = function(week_number) {
    if (week_number) {
      return moment().add(week_number, 'weeks').format('MMM DD YYYY');
    } else {
      return null;
    }
  };

  GoalCtrl.prototype.dateAtEndOfTrial = function() {
    if (this.studyEndDate && moment(this.studyEndDate) > moment()) {
      return moment(this.studyEndDate).format("MMM DD YYYY");
    } else {
      return null;
    }
  };

  GoalCtrl.prototype.atLeastNWeeksLeftInTrial = function(week_number) {
    week_number = week_number || 0;

    return moment().add(week_number, 'weeks')
      .isBefore(moment(this.studyEndDate));
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
                'participantStudyEndDate', 'noticesEnabled',
                'noticeUtility', GoalCtrl]);
})();
