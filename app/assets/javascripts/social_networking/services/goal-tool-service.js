;(function() {
  'use strict';

  function GoalToolService(focus) {
    var goalDefaults = {
      id: null,
      description: '',
      isCompleted: false,
      dueOn: ''
    };

    function GoalTool() {}

    GoalTool.prototype.MODES = {
      BROWSE: 0,
      ENTRY: 1
    };

    GoalTool.prototype.edit = function(goal) {
      this.setModel(goal);
      this.setMode(this.MODES.ENTRY);
      focus('new-goal');
    };

    GoalTool.prototype.getMode = function() { return this._mode; };

    GoalTool.prototype.setMode = function(mode) { this._mode = mode; };

    GoalTool.prototype.copy = function(srcGoal, dstGoal) {
      dstGoal.description = srcGoal.description;
      dstGoal.isCompleted = srcGoal.isCompleted;
      dstGoal.dueOn = srcGoal.dueOn;
    };

    GoalTool.prototype.setModel = function(goal) {
      var g = typeof goal === 'undefined' ? goalDefaults : goal;
      this._goalModel.id = g.id;
      this.copy(g, this._goalModel);
    };

    GoalTool.prototype.getModel = function() { return this._goalModel; };

    GoalTool.prototype.setFilter = function(type) {
      switch(type) {
        case 'all':
          this._currentFilter = { isDeleted: false };
          break;
        case 'completed':
          this._currentFilter = { isDeleted: false, isCompleted: true };
          break;
        case 'deleted':
          this._currentFilter = { isDeleted: true };
      }
    };

    GoalTool.prototype.getFilter = function() { return this._currentFilter; };

    GoalTool.prototype.setTab = function(name) { this._tab = name; };

    GoalTool.prototype.getTab = function() { return this._tab; };

    GoalTool.prototype._mode = GoalTool.prototype.MODES.BROWSE;

    GoalTool.prototype._currentFilter = {};

    GoalTool.prototype._goalModel = {};

    GoalTool.prototype._tab = 'all';

    return new GoalTool();
  }

  angular.module('socialNetworking.services')
    .service('goalTool', ['focus', GoalToolService]);
})();
