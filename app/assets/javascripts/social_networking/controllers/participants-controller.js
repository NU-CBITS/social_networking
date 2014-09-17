;(function() {
    "use strict";

    // Provide access to all group profiles.
    function ParticipantsCtrl(Participants) {
        var self = this;

        Participants.getAll().then(function(participants) {
            self.members = participants;
        });
    }

    // Create a module and register the controllers.
    angular.module('socialNetworking.controllers')
        .controller('ParticipantsCtrl', ['Participants', ParticipantsCtrl]);
})();

