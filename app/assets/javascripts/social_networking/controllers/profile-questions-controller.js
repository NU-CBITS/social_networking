;(function() {
    "use strict";

    // Provide access to all profile questions.
    function ProfileQuestionsCtrl(ProfileQuestions) {
        var self = this;

        ProfileQuestions.getAll().then(function(profileQuestions) {
            self.members = profileQuestions;
        });
    }

    // Create a module and register the controllers.
    angular.module('socialNetworking.controllers')
        .controller('ProfileQuestionsCtrl', ['ProfileQuestions', ProfileQuestionsCtrl]);
})();

