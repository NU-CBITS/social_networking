;(function() {
  'use strict';

  function GoalTool(focus) {
    var goalDefaults = {
      id: null,
      description: '',
      isCompleted: false,
      dueOn: ''
    };

    var goalTool = {
      BROWSE_MODE: 1,
      ENTRY_MODE: 2,
      edit: function(goal) {
              this.setModel(goal);
              this.setMode(this.ENTRY_MODE);
              focus('new-goal');
            },
      getMode: function() { return this._mode; },
      setMode: function(mode) { this._mode = mode; },
      copy: function(srcGoal, dstGoal) {
              dstGoal.description = srcGoal.description;
              dstGoal.isCompleted = srcGoal.isCompleted;
              dstGoal.dueOn = srcGoal.dueOn;
            },
      setModel: function(goal) {
                  var g = typeof goal === 'undefined' ? goalDefaults : goal;
                  this._goalModel.id = g.id;
                  this.copy(g, this._goalModel);
                },
      getModel: function() { return this._goalModel; },
      setFilter: function(type) {
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
                 },
      getFilter: function() { return this._currentFilter; },
      setTab: function(name) { this._tab = name; },
      getTab: function() { return this._tab; },
      _mode: this.BROWSE_MODE,
      _currentFilter: {},
      _goalModel: {},
      _tab: 'all'
    };

    return goalTool;
  }

  angular.module('socialNetworking.services')
    .service('goalTool', ['focus', GoalTool]);
})();
