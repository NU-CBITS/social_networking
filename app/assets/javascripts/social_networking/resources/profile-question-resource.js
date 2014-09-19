;(function() {
    'use strict';

    function ProfileQuestions($resource) {
        var ProfileQuestionResource = $resource('/social_networking/profile_questions/:id',
            { id: '@profile_question_id' });

        function ProfileQuestion() {}

        ProfileQuestion.getAll = function() {
            return ProfileQuestionResource.query().$promise;
        };

        ProfileQuestion.getOne = function(profile_question_id) {
            return ProfileQuestionResource.get({ id: profile_question_id }).$promise;
        };

        return ProfileQuestion;
    }

    angular.module('socialNetworking.services')
        .service('ProfileQuestions', ['$resource', ProfileQuestions]);
})();
