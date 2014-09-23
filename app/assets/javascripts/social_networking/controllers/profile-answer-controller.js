;(function() {
    "use strict";

    // Provide interaction with a participant's profile answers to profile questions.
    function ProfileAnswerCtrl(profileAnswerId, answerTool, ProfileAnswers) {
        var self = this;

        this._answers = ProfileAnswers;
        this._answerTool = answerTool;
        this.answerModel = this._answerTool.getModel();

        ProfileAnswers.getOne(profileAnswerId)
            .then(function(profileAnswer) {
                self.id = profileAnswer.id;
            })
            .catch(function(error) {
                window.console.log(error);
            });
        this.responses = [{ question: 'foo?', text: 'bar' }];
    }

    // Initiate profile editor interface.
    ProfileAnswerCtrl.prototype.edit = function() {
        window.console.log("edit");
    };

    // Is this only available for goal browsing?
    ProfileAnswerCtrl.prototype.inBrowseMode = function() {
        return this._answerTool.getMode() === this._answerTool.MODES.BROWSE;
    };

    // Is this available for answer entry?
    ProfileAnswerCtrl.prototype.inEntryMode = function() {
        return this._answerTool.getMode() === this._answerTool.MODES.ENTRY;
    };

    // Open a form.
    ProfileAnswerCtrl.prototype.new = function() {
        this._answerTool.edit();
    };

    ProfileAnswerCtrl.prototype.edit = function(answer) {
        this._answerTool.edit(answer);
    };

    // Create a module and register the controllers.
    angular.module('socialNetworking.controllers')
        .controller('ProfileAnswerCtrl', ['profileAnswerId', 'answerTool', 'ProfileAnswers', ProfileAnswerCtrl]);
})();
