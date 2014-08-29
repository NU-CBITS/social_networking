;(function() {
  "use strict";

  // Provides management of goals.
  function GoalCtrl() {
    this.description = "";
  }

  // Persist a goal.
  GoalCtrl.prototype.save = function() {
    window.console.log("saving");
  };

  // Create a module and register the controller.
  angular.module('socialNetworking.controllers')
    .controller('GoalCtrl', GoalCtrl);
})();
