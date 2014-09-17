;(function() {
  "use strict";

  // Provide interaction with a participant's profile.
  function ProfileCtrl(profileId, Profiles, Nudges) {
    var self = this;

    this._nudges = Nudges;

    Profiles.getOne(profileId)
      .then(function(profile) {
        self.id = profile.id;
      })
      .catch(function(error) {
        window.console.log(error);
      });
    this.responses = [{ question: 'foo?', text: 'bar' }];
  }

  // Send a nudge from one participant to another.
  ProfileCtrl.prototype.nudge = function() {
    this._nudges.create({ recipient: this });
  };

  // Initiate profile editor interface.
  ProfileCtrl.prototype.edit = function() {
    window.console.log("edit");
  };

  // Create a module and register the controllers.
  angular.module('socialNetworking.controllers')
    .controller('ProfileCtrl', ['profileId', 'Profiles', 'Nudges', ProfileCtrl]);
})();
