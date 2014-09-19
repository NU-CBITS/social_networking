;(function() {
    "use strict";

    // Provide access to all profile answers.
    function ProfileAnswerCtrl(ProfileAnswers) {
        var self = this;

        ProfileAnswers.getAll().then(function(profileAnswers) {
            self.members = profileAnswers;
        });
    }

    // Create a module and register the controllers.
    angular.module('socialNetworking.controllers')
        .controller('ProfileAnswerCtrl', ['ProfileAnswers', ProfileAnswerCtrl]);
})();

