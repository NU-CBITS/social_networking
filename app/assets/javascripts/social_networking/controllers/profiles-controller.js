;(function() {
  "use strict";

  // Provide access to all group profiles.
  function ProfilesCtrl(Profiles) {
    var self = this;

    Profiles.getAll().then(function(profiles) {
      self.members = profiles;
    });
  }

  // Create a module and register the controllers.
  angular.module('socialNetworking.controllers')
    .controller('ProfilesCtrl', ['Profiles', ProfilesCtrl]);
})();

