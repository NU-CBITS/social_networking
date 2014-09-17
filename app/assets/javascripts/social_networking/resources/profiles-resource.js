;(function() {
    'use strict';

    function Profiles($resource) {
        var ProfileResource = $resource('/social_networking/profiles/:id',
            { id: '@id' });

        var ProfilesResource = $resource('/social_networking/profiles');

        function Profile() {}

        Profile.getAll = function() {
            return ProfilesResource.query().$promise;
        };

        Profile.getOne = function(id) {
            return ProfileResource.get({ id: id }).$promise;
        };

        return Profile;
    }

    angular.module('socialNetworking.services')
        .service('Profiles', ['$resource', Profiles]);
})();
