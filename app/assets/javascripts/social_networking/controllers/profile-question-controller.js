;(function() {
    "use strict";

    // Provide interaction with a profile question.
    function ProfileQuestionCtrl(profileQuestionId, ProfileQuestion) {
        var self = this;

        ProfileQuestion.getOne(profileQuestionId)
            .then(function(profileQuestion) {
                self.id = profileQuestion.id;
            })
            .catch(function(error) {
                window.console.log(error);
            });
        this.responses = [{ question: 'foo?', text: 'bar' }];
    }

    // Create a module and register the controllers.
    angular.module('socialNetworking.controllers')
        .controller('ProfileQuestionCtrl', ['profileQuestionId', 'ProfileQuestion', ProfileQuestionCtrl]);
})();
