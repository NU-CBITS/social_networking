;(function() {
    'use strict';

    function Profiles($resource) {
        var ProfileResource = $resource('/social_networking/profiles/:id', {
            id: '@id' }, {
            'update': {method: 'PUT'}
        });
        var ProfilesResource = $resource('/social_networking/profiles');

        function Profile() {}

        Profile.getAll = function() {
            return ProfilesResource.query().$promise;
        };

        Profile.getOne = function(id) {
            return ProfileResource.get({ id: id }).$promise;
        };

        // Update a Goal on the server.
        Profile.update = function(attributes) {
            var profile = new ProfileResource();
            return profile.$update({
                id: attributes.profile.id,
                icon_name: attributes.iconSrc
            });
        };

        return Profile;
    }

    angular.module('socialNetworking.services')
        .service('Profiles', ['$resource', Profiles]);
})();
