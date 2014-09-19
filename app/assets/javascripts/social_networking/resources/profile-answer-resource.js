;(function() {
    'use strict';

    function ProfileAnswers($resource) {
        var ProfileAnswerResource = $resource('/social_networking/profile_answers/:id',
            { id: '@profile_answer_id' });

        function ProfileAnswer() {}

        ProfileAnswer.getAll = function() {
            return ProfileAnswerResource.query().$promise;
        };

        ProfileAnswer.getOne = function(profile_answer_id) {
            return ProfileAnswerResource.get({ id: profile_answer_id }).$promise;
        };

        return ProfileAnswer;
    }

    angular.module('socialNetworking.services')
        .service('ProfileAnswers', ['$resource', ProfileAnswers]);
})();
