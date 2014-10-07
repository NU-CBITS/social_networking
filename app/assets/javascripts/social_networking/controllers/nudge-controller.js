;(function() {
  "use strict";

  // Provide access to all group profiles.
  function NudgeCtrl(Nudges) {
    var self = this;

    Nudges.search(self.recipientId).then(function(nudges) { self.members = nudges; });
  }

  NudgeCtrl.prototype.setRecipient = function(recipientId, controller) {
      controller.recipient_id = recipientId;
  };

  // Create a module and register the controllers.
  angular.module('socialNetworking.controllers')
    .controller('NudgeCtrl', ['Nudges', NudgeCtrl]);
})();

