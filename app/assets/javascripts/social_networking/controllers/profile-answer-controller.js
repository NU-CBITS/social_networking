;(function() {
    "use strict";

    // Provide interaction with a participant's profile answers to profile questions.
    function ProfileAnswerCtrl(profileAnswerId, ProfileAnswer) {
        var self = this;

        ProfileAnswers.getOne(profileAnswerId)
            .then(function(profileAnswer) {
                self.id = profileAnswer.id;
            })
            .catch(function(error) {
                window.console.log(error);
            });
        this.responses = [{ question: 'foo?', text: 'bar' }];
    }

    // Initiate profile editor interface.
    ProfileAnswerCtrl.prototype.edit = function() {
        window.console.log("edit");
    };

    // Create a module and register the controllers.
    angular.module('socialNetworking.controllers')
        .controller('ProfileAnswerCtrl', ['profileAnswerId', 'ProfileAnswer', ProfileAnswerCtrl]);
})();