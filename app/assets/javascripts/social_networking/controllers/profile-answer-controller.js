;(function() {
    "use strict";

    // Provide interaction with a participant's profile answers to profile questions.
    function ProfileAnswerCtrl(answerTool, ProfileAnswers) {
      var self = this;
      self._answerResource = ProfileAnswers;
      self._answerTool = answerTool;
      self.answerModel = self._answerTool.getModel();
      self.answerModel.id = this.getAnswerId();
      window.console.log(self.answerModel);
    }

    ProfileAnswerCtrl.prototype.init = function(profileId, questionId) {
      this._answerResource.getOne(profileId, questionId)
        .then(function(profileAnswer) {
            this.setAnswerId(profileAnswer.id);
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
    ProfileAnswerCtrl.prototype.save = function() {
      var self = this;

      if (this._answerTool.getModel().id === undefined) {
        this._answerModel['profile_id'] = self.profileId;
        this._answerModel['profile_question_id'] = self.questionId;

        window.console.log('blarg1');

        this._answerResource.create(this._answerTool.getModel())
            .then(function() {
        self.resetForm();
        self.resetTabs();
        }).catch(function(message) {
          self.error = message.error;
        });
      } else {
        this._answerModel.id = self.id
        window.console.log(this._answerTool.getModel())
        this._answerResource.update(this._answerTool.getModel())
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
