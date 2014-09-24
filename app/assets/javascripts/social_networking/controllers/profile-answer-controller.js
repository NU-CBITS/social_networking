;(function() {
    "use strict";

    // Provide interaction with a participant's profile answers to profile questions.
    function ProfileAnswerCtrl(answerTool, ProfileAnswers) {
      var self = this;

      this._answersResource = ProfileAnswers;
      this._answerTool = answerTool;
      this.answerModel = this._answerTool.getModel();

      this._answersResource.getOne(this.profileId, this.questionId)
        .then(function(profileAnswer) {
          self.id = profileAnswer.id;
        })
        .catch(function(error) {
          window.console.log(error);
        });
    }

    // Initiate profile editor interface.
    ProfileAnswerCtrl.prototype.edit = function() {
      window.console.log("edit");
    };

    // Is this only available for profile browsing?
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

    // Persist a profile from the form.
    ProfileAnswerCtrl.save = function() {
      window.console.log('blarg')
      var self = this;

      if (this._answerTool.getModel().id === null) {
        this._answersResource.create(this._answerTool.getModel())
            .then(function() {
        self.resetForm();
        self.resetTabs();
        }).catch(function(message) {
          self.error = message.error;
        });
      } else {
        this._answersResource.update(this._answerTool.getModel())
          .then(function() {
            self.resetForm();
            self.resetTabs();
          }).catch(function(message) {
            self.error = message.error;
          });
        }
    };

    // Create a module and register the controllers.
    angular.module('socialNetworking.controllers')
        .controller('ProfileAnswerCtrl', ['answerTool', 'ProfileAnswers', ProfileAnswerCtrl]);
})();
