;(function() {
  "use strict";

  // Provide interaction with a participant's profile.
  function ProfileCtrl(Nudges) {
    this._nudges = Nudges;
    this.username = 'Billy';
    this.lastLogin = '2014-08-12T16:55:29Z';
    this.responses = [{ question: 'foo?', text: 'bar' }];
  }

  // Send a nudge from one participant to another.
  ProfileCtrl.prototype.nudge = function() {
    this._nudges.create();
  };

  // Initiate profile editor interface.
  ProfileCtrl.prototype.edit = function() {
    window.console.log("edit");
  };
  
  // Provide access to all group profiles.
  function ProfilesCtrl() {
    this.members = [
      {
        username: 'Alice',
        lastLogin: '2014-08-13T16:23:29Z'
      },
      {
        username: 'Benji',
        lastLogin: '2014-08-12T16:23:29Z'
      }
    ];
  }

  // Create a module and register the controllers.
  angular.module('socialNetworking.profile.controllers', [])
    .controller('ProfileCtrl', ['Nudges', ProfileCtrl])
    .controller('ProfilesCtrl', ProfilesCtrl);
})();
