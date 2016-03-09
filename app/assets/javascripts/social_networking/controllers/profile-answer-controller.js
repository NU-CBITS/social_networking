;(function() {
    "use strict";

    // Provide interaction with a participant's profile answers to profile questions.
    function ProfileAnswerCtrl($window, ProfileAnswers, charLimitService) {
      this._answerResource = ProfileAnswers;
      this.answerModels = {};
      this._answerStates = {};
      this.showCharLimit = charLimitService.showCharLimit
      this.textMaxLength = charLimitService.textMaxLength;
      this.$window = $window;
    }

    ProfileAnswerCtrl.prototype.storeAnswer = function(profileId, questionId) {
      var self = this;
      this
        ._answerResource.getOne(profileId, questionId)
        .then(function(profileAnswer) {
          self.answerModels[questionId] = profileAnswer;
          self.setModel(profileAnswer);
          self._answerStates[questionId] = {};
          self._answerStates[questionId].editable = false;
        })
        .catch(function(error) {
          self.answerModels[questionId] = {};
          var answerModel = {};
          answerModel.profile_id = profileId;
          answerModel.profile_question_id = questionId;
          self.answerModels[questionId] = answerModel;
          self._answerStates[questionId] = {};
          self._answerStates[questionId].editable = true;
        });
    };

    ProfileAnswerCtrl.prototype.ifAnswered = function(questions) {
      var self, states = [];

      self = this;
      angular.forEach(questions, function(value) {
        var reponse = self.answerModels[value.id];
        states.push(reponse && !!reponse.answer_text);
      });
      return states.indexOf(true) !== -1;
    };

    ProfileAnswerCtrl.prototype.setModel = function(answer) {
      var answerModel = {};

      answerModel.id = answer.id;
      answerModel.profile_id = answer.profile_id;
      answerModel.profile_question_id = answer.profile_question_id;
      answerModel.answer_text = answer.answer_text;
      this.answerModels[answer.profile_question_id] = answerModel;
    };

    ProfileAnswerCtrl.prototype.getModel = function(question_id) {
      return this.answerModels[question_id];
    };

    // Initiate answer editor interface.
    ProfileAnswerCtrl.prototype.edit = function(question_id) {
      this._answerStates[question_id].editable = true;
    };

    // Exit answer editor interface.
    ProfileAnswerCtrl.prototype.cancelEdit = function(question_id) {
      this._answerStates[question_id].editable = false;
    };

    // Persist a profile from the form.
    ProfileAnswerCtrl.prototype.save = function(profileId, questionId) {
      var answerModel, self = this;

      answerModel = this.getModel(questionId);
      if (answerModel.id === undefined) {
        answerModel.profile_id = profileId;
        answerModel.profile_question_id = questionId;
        this._answerResource.create(answerModel).then(function() {
          self.storeAnswer(profileId, questionId);
        }).catch(function(message) {
          self.$window.confirm("There was an error: " + ((message || {}).data || {}).error + ".");
          self._answerResource.getOne(profileId, questionId)
            .then(function(profileAnswer) {
              answerModel.answer_text = profileAnswer.answer_text;
            })
            .finally(function(error) {
              self._answerStates[questionId].editable = false;
            });
        });
      } else {
        answerModel.profile_id = profileId;
        answerModel.profile_question_id = questionId;
        this._answerResource
        .update(answerModel)
        .then(function() {
          self._answerStates[questionId].editable = false;
        }).catch(function(message) {
          self.$window.confirm("There was an error: " + ((message || {}).data || {}).error + ".");
        });
      }
    };

    // Create a module and register the controllers.
    angular.module('socialNetworking.controllers')
      .controller('ProfileAnswerCtrl', ['$window', 'ProfileAnswers', 'charLimitService', ProfileAnswerCtrl]);
})();
