;(function() {
  'use strict';

  function Participants($resource) {
    var ParticipantResource = $resource('/social_networking/participants/:id',
      { id: '@participant_id' });

    function Participant() {}

    Participant.getAll = function() {
      return ParticipantResource.query().$promise;
    };

    Participant.getOne = function(participant_id) {
      return ParticipantResource.get({ id: participant_id }).$promise;
    };

    return Participant;
  }

  angular.module('socialNetworking.services')
    .service('Participants', ['$resource', Participants]);
})();
