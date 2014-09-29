;(function() {
    "use strict";

    // Provide interaction with a participant's profile answers to profile questions.
    function ProfileAnswerCtrl(answerTool, ProfileAnswers) {
      var self = this;
      self._answerResource = ProfileAnswers;
      self._answerTool = answerTool;
      self.answerModel = self._answerTool.getModel();
      self.answerModel.id = self.getAnswerId();
    }

    ProfileAnswerCtrl.prototype.init = function(profileId, questionId, controller) {
      this._answerResource.getOne(profileId, questionId)
        .then(function(profileAnswer) {
            window.console.log(profileAnswer)
            controller.setAnswerId(profileAnswer.id);
            controller._answerTool.setModel(profileAnswer);
            window.console.log(controller._answerTool.getModel());
          })
          .catch(function(error) {
            window.console.log(error);
          });
    };

    ProfileAnswerCtrl.prototype.setAnswerId = function(id) {
      this.id = id;
    }

    ProfileAnswerCtrl.prototype.getAnswerId = function() {
      return this.id;
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
    ProfileAnswerCtrl.prototype.save = function(profileId, questionId, controller) {

      if (controller._answerTool.getModel().id === undefined) {
        controller.answerModel.profile_id = profileId;
        controller.answerModel.profile_question_id = questionId;
        controller._answerResource.create(controller._answerTool.getModel()).then(function() {
          controller.resetForm();
          controller.resetTabs();
        }).catch(function(message) {
        controller.error = message.error;
      });
      } else {
        controller.answerModel.profile_id = profileId;
        controller.answerModel.profile_question_id = questionId;
        controller._answerResource.update(controller._answerTool.getModel()).then(function() {
          controller.resetForm();
          controller.resetTabs();
        }).catch(function(message) {
          controller.error = message.error;
        });
      }
    };

    // Create a module and register the controllers.
    angular.module('socialNetworking.controllers')
        .controller('ProfileAnswerCtrl', ['answerTool', 'ProfileAnswers', ProfileAnswerCtrl]);



})();
