;(function() {
  'use strict';

  function GoalTool(focus) {
    var goalTool = {
      BROWSE_MODE: 1,
      ENTRY_MODE: 2,
      mode: this.BROWSE_MODE,
      currentFilter: {},
      goalModel: {
        description: '',
        isCompleted: false,
        dueOn: ''
      },
      _tab: 'all',
      new: function() {
             this.mode = this.ENTRY_MODE;
             focus('new-goal');
           },
      getMode: function() {
                 return this.mode;
               },
      setMode: function(mode) {
                 this.mode = mode;
               },
      resetForm: function() {
                   this.goalModel.description = '';
                   this.goalModel.isCompleted = false;
                   this.goalModel.dueOn = '';
                 },
      setFilter: function(type) {
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
                 },
      getFilter: function() {
                   return this.currentFilter;
                 },
      setTab: function(name) {
                this._tab = name;
              },
      getTab: function() {
                return this._tab;
              }
    };

    return goalTool;
  }

  angular.module('socialNetworking.services')
    .service('goalTool', ['focus', GoalTool]);
})();
