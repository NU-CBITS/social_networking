;(function() {
  // Provides management of goals.
  function GoalCtrl() {
    this.description = "";
  }

  // Persist a goal.
  GoalCtrl.prototype.save = function() {
    alert(this.description);
  };

  // Create a module and register the controller.
  angular.module('socialNetworking.goals.controllers', [])
    .controller('GoalCtrl', GoalCtrl);
})();
