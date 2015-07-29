;(function() {
  "use strict";

  // Provide interaction with a participant's profile.
  function ProfileCtrl(profileId, Profiles, Nudges) {
      var self = this;
      self._profiles = Profiles;
      self._nudges = Nudges;
      self.profile = {};
      self._profiles.getOne(profileId)
      .then(function(profile) {
          self.id = profile.id;
          self.profile = profile;
          self.iconSrc = '';
      }).catch(function(error) {
          window.console.log(error);
      });
  }

  // Send a nudge from one participant to another.
  ProfileCtrl.prototype.nudge = function(recipient_id) {
    var self = this;

    this._nudges.create(recipient_id)
      .then(function(response) {
        self.nudgeAlert = response.message;
      })
      .catch(function(response) {
        self.nudgeAlert = response.data.error;
      });
  };

  // Update the profile icon
  ProfileCtrl.prototype.update_profile_icon = function(icon_name, controller) {
    controller.iconSrc = icon_name;
    controller._profiles.update(controller).then(function(profile) {
        controller.profile.iconSrc = profile.iconSrc;
    });
    $('#icon-selection-button').click();
  };

  ProfileCtrl.prototype.getIconSrc = function(controller) {
    return controller.profile.iconSrc;
  };

  // Create a module and register the controllers.
  angular.module('socialNetworking.controllers')
    .controller('ProfileCtrl', ['profileId', 'Profiles', 'Nudges', ProfileCtrl]);
})();
