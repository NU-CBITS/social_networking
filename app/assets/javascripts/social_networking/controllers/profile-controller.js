;(function() {
  "use strict";

  // Provide interaction with a participant's profile.
  function ProfileCtrl(alertService, profileId, Profiles, Nudges) {
      var self = this;
      this._profiles = Profiles;
      this._nudges = Nudges;
      this.alertService = alertService;
      this.profile = {};
      this._profiles.getOne(profileId).then(function(profile) {
        self.id = profile.id;
        self.profile = profile;
        self.iconSrc = '';
      }).catch(function(error) {
        self.alertService.addError(error);
      });
  }

  // Send a nudge from one participant to another.
  ProfileCtrl.prototype.nudge = function(recipientId) {
    var self = this;

    this._nudges.create(recipientId)
      .then(function(response) {
        self.nudgeAlert = response.message;
      })
      .catch(function(response) {
        self.alertService.addError(response.data.error);
      });
  };

  ProfileCtrl.prototype.updateProfileIcon = function(iconName) {
    var self = this;
    this.iconSrc = iconName;
    this._profiles.update(this)
    .then(function(profile) {
      self.profile.iconSrc = profile.iconSrc;
    })
    .catch(function(response) {
      self.alertService.addError(response.data.error);
    });
    $('#icon-selection-button').click();
  };

  // Create a module and register the controllers.
  angular.module('socialNetworking.controllers')
    .controller('ProfileCtrl', ['alertService', 'profileId', 'Profiles', 'Nudges', ProfileCtrl]);
})();
