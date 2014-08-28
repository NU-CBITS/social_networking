;(function() {
  'use strict';

  function Participants($resource) {
    var ParticipantResource = $resource('/social_networking/participants/:id',
      { id: '@id' });

    function Participant() {}

    Participant.getAll = function() {
      return ParticipantResource.query(function(participants) {
      }).$promise;
    };

    return Participant;
  }

  angular.module('socialNetworking.services')
    .service('Participants', ['$resource', Participants]);
})();
