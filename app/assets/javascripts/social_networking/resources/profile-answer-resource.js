;(function() {
    'use strict';

    function ProfileAnswers($resource) {
        var ProfileAnswerResource = $resource('/social_networking/profile_answers/:id', { id: '@id' });

        function ProfileAnswer() {}

        ProfileAnswer.getAll = function() { return ProfileAnswerResource.query().$promise; };

        ProfileAnswer.getOne = function(profile_id, profile_question_id) {
            return ProfileAnswerResource.get({ profile_id: profile_id, profile_question_id: profile_question_id }).$promise;
        };


        // Persist a Goal to the server.
        ProfileAnswer.create = function(attributes) {
            var answer = new ProfileAnswerResource({
                profile_id: attributes.profile_id,
                profile_question_id: attributes.profile_question_id,
                answer_text: attributes.answer_text || ""
            });

            return answer.$save();
        };

        // Update a Goal on the server.
        ProfileAnswer.update = function(attributes) {
            var answer = new ProfileAnswerResource({
                id: attributes.id,
                profile_id: attributes.profile_id,
                profile_question_id: attributes.profile_question_id,
                answer_text: attributes.answer_text || ""
            });

            return answer.$save();
        };

        return ProfileAnswer;
    }

    angular.module('socialNetworking.services')
        .service('ProfileAnswers', ['$resource', ProfileAnswers]);
})();
