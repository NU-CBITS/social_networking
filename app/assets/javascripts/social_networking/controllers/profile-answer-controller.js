;(function() {
    "use strict";

    // Provide interaction with a participant's profile answers to profile questions.
    function ProfileAnswerCtrl(ProfileAnswers) {
      var self = this;
      self._answerResource = ProfileAnswers;
      self.answerModels = {};
      self._answerStates = {};
    }

    ProfileAnswerCtrl.prototype.storeAnswer = function(profileId, questionId, controller) {
      this._answerResource.getOne(profileId, questionId)
        .then(function(profileAnswer) {
            window.console.log('entering storeAnswer, answer response: ' + profileAnswer);
            controller.answerModels[questionId] = profileAnswer;
            controller.setModel(profileAnswer, controller);
            controller._answerStates[questionId] = {};
            controller._answerStates[questionId].editable = false;
            window.console.log('editable: ' + controller._answerStates[questionId]);
            window.console.log('exiting storeAnswer, stored model: ' + controller.getModel(questionId, controller));
          })
          .catch(function(error) {
            window.console.log(error);
          });
    };

    ProfileAnswerCtrl.prototype.setModel = function(answer, controller) {
        var answerModel = {};
        answerModel.id = answer.id;
        answerModel.profile_id = answer.profile_id;
        answerModel.profile_question_id = answer.profile_question_id;
        answerModel.answer_text = answer.answer_text;
        controller.answerModels[answer.profile_question_id] = answerModel;
    };

    ProfileAnswerCtrl.prototype.getModel = function(question_id, controller) { return controller.answerModels[question_id]; };

    // Initiate answer editor interface.
    ProfileAnswerCtrl.prototype.edit = function(question_id, controller) {
      window.console.log("entering edit mode...");
      controller._answerStates[question_id].editable = true;
    };

    // Exit answer editor interface.
    ProfileAnswerCtrl.prototype.cancelEdit = function(question_id, controller) {
        window.console.log("exiting edit mode...");
        controller._answerStates[question_id].editable = false;
    };

    // Persist a profile from the form.
    ProfileAnswerCtrl.prototype.save = function(profileId, questionId, controller) {

      var answerModel = controller.getModel(questionId, controller);
      if (answerModel.id === undefined) {
        window.console.log('start save process...')
        answerModel.profile_id = profileId;
        answerModel.profile_question_id = questionId;
        controller._answerResource.create(answerModel).then(function() {
          window.console.log('save success.')
          controller._answerStates[questionId].editable = false;
        }).catch(function(message) {
        controller.error = message.error;
      });
      } else {
        window.console.log('start update process...')
        answerModel.profile_id = profileId;
        answerModel.profile_question_id = questionId;
        controller._answerResource.update(answerModel).then(function() {
          window.console.log('update success.')
          controller._answerStates[questionId].editable = false;
        }).catch(function(message) {
          controller.error = message.error;
        });
      }
    };

    // Create a module and register the controllers.
    angular.module('socialNetworking.controllers')
        .controller('ProfileAnswerCtrl', ['ProfileAnswers', ProfileAnswerCtrl]);
})();
