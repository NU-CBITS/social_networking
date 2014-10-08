;(function() {
    "use strict";

    // Provide interaction with a participant's profile.
    function ParticipantCtrl(participantId, Participants, Nudges) {
        var self = this;

        this._nudges = Nudges;
        Participants.getOne(participantId)
            .then(function(participant) {
                self.id = participant.id;
                self.username = participant.username;
                self.latestAction = participant.latestAction;
            })
            .catch(function(error) {
                window.console.log(error);
            });
        this.responses = [{ question: 'foo?', text: 'bar' }];
    }

    // Send a nudge from one participant to another.
    ParticipantCtrl.prototype.nudge = function() {
        this._nudges.create({ recipient: this });
    };

    // Initiate profile editor interface.
    ParticipantCtrl.prototype.edit = function() {
        window.console.log("edit");
    };

    // Create a module and register the controllers.
    angular.module('socialNetworking.controllers')
        .controller('ParticipantCtrl', ['participantId', 'Participants', 'Nudges', ParticipantCtrl]);
})();
