;(function() {
    "use strict";

    // Provide access to all profile questions.
    function ProfileQuestionsCtrl(ProfileQuestions) {
        var self = this;
        this.questions = ProfileQuestions;
    }

    // Create a module and register the controllers.
    angular.module('socialNetworking.controllers')
        .controller('ProfileQuestionsCtrl', ['ProfileQuestions', ProfileQuestionsCtrl]);
})();

