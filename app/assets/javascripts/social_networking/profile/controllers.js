;(function() {
  "use strict";

  // Provide interaction with a participant's profile.
  function ProfileCtrl(Nudges) {
    this._nudges = Nudges;
    this.participant = { id: 123, username: 'Billy' };
    this.lastLogin = '2014-08-12T16:55:29Z';
    this.responses = [{ question: 'foo?', text: 'bar' }];
  }

  // Send a nudge from one participant to another.
  ProfileCtrl.prototype.nudge = function() {
    this._nudges.create({ recipient: this.participant });
  };

  // Initiate profile editor interface.
  ProfileCtrl.prototype.edit = function() {
    window.console.log("edit");
  };
  
  // Provide access to all group profiles.
  function ProfilesCtrl(Participants) {
    var self = this;

    Participants.getAll().then(function(participants) {
      self.members = participants;
    });
  }

  // Create a module and register the controllers.
  angular.module('socialNetworking.profile.controllers', [])
    .controller('ProfileCtrl', ['Nudges', ProfileCtrl])
    .controller('ProfilesCtrl', ['Participants', ProfilesCtrl]);
})();
