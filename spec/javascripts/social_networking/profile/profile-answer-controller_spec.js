describe('ProfileAnswerCtrl', function() {
  var $q, $rootScope, $window, answerId, answerText, controller,
      newAnswer, profileId, profileAnswers, questionId, questions;

  beforeEach(module('socialNetworking.controllers'));

  beforeEach(inject(function($controller, _$rootScope_, _$q_, _$window_) {
    $rootScope = _$rootScope_;
    $q = _$q_;
    $window = _$window_;
    answerId = 'foo';
    answerText = 'I love it!';
    controller = $controller;
    profileId = 'bar';
    questionId = 'alas';
    questions = [
      {
        id: questionId,
        question_text: 'What are your hobbies?'
      }
    ];
    savedAnswer = {
      id: answerId,
      answer_text: answerText,
      profile_id: profileId,
      profile_question_id: questionId
    }
  }));

  describe('#ifAnswered', function() {
    beforeEach(function() {
      controller = controller('ProfileAnswerCtrl', {
        ProfileAnswers: function() {},
        SN_CONSTANTS: {}
      });
    });

    it('returns `true` if the participant has answered at least one profile question', function() {
      controller.answerModels = {}
      controller.answerModels[questionId] = savedAnswer;

      expect(controller.ifAnswered(questions)).toBe(true);
    });

    it('returns `false` if the participant has not answered at least one profile question', function() {
      controller.answerModels = {};

      expect(controller.ifAnswered(questions)).toBe(false);
    });
  });

  describe('#save', function() {
    beforeEach(function() {
      newAnswer = {
        answer_text: answerText,
        profile_id: profileId,
        profile_question_id: questionId
      };

      profileAnswers = jasmine.createSpyObj('profileAnswers', ['create', 'getOne']);

      profileAnswers.getOne.and.callFake(function() {
        var deferred, promise;

        deferred = $q.defer();
        promise = deferred.promise;
        deferred.resolve(savedAnswer);
        return promise;
      });

      profileAnswers.create();
    });

    describe('when saving succeeds', function() {
      beforeEach(function() {
        profileAnswers.create.and.callFake(function() {
          var deferred, promise;

          deferred = $q.defer();
          promise = deferred.promise;
          deferred.resolve();
          return promise;
        });

        controller = controller('ProfileAnswerCtrl', {
          ProfileAnswers: profileAnswers,
          SN_CONSTANTS: {}
        });

        controller.setModel(newAnswer);
      });

      it('adds the newly created answer to the collection of answers', function() {
        expect(controller.answerModels[questionId].id).toBe(undefined);

        controller.save(profileId, questionId);
        $rootScope.$apply();

        expect(controller.answerModels[questionId]).toEqual(savedAnswer);
      });

      it('updates the collection of answer states', function() {
        expect(controller._answerStates[questionId]).toBe(undefined);

        controller.save(profileId, questionId);
        $rootScope.$apply();

        expect(controller._answerStates[questionId].editable).toBe(false);
      });
    });

    describe('answer model is a new object', function() {
      var callProfileAnswersRejectCreate = function(messageObject) {
        profileAnswers.create.and.callFake(function() {
          var deferred, promise;

          deferred = $q.defer();
          promise = deferred.promise;
          deferred.reject(messageObject);
          return promise;
        });
      };

      describe('when saving fails with an error message', function() {
        beforeEach(function() {
          callProfileAnswersRejectCreate({ data: { error: 'Holy guacamole!' } });
          controller = controller('ProfileAnswerCtrl', {
            ProfileAnswers: profileAnswers,
            SN_CONSTANTS: {}
          });
          controller.setModel(newAnswer);
        });

        it('displays a confirm message to the user', function() {
          spyOn($window, 'confirm');

          expect($window.confirm).not.toHaveBeenCalled();

          controller.save(profileId, questionId);
          $rootScope.$apply();

          expect($window.confirm).toHaveBeenCalled();
        });

        it('does not save the answer to the collection of answers', function() {
          expect(controller.answerModels[questionId].id).toBe(undefined);

          controller.save(profileId, questionId);
          $rootScope.$apply();

          expect(controller.answerModels[questionId].id).toBe(undefined);
        });
      });

      describe('when saving fails without an error message', function() {
        beforeEach(function() {
          callProfileAnswersRejectCreate();
          controller = controller('ProfileAnswerCtrl', {
            ProfileAnswers: profileAnswers,
            SN_CONSTANTS: {}
          });
          controller.setModel(newAnswer);
        });

        it('displays a confirm dialog to the user', function() {
          spyOn($window, 'confirm');

          expect($window.confirm).not.toHaveBeenCalled();

          controller.save(profileId, questionId);
          $rootScope.$apply();

          expect($window.confirm).toHaveBeenCalled();
        });
      });
    });
  });

  describe('.showCharLimit', function() {
    var $content = $('#jasmine_content');

    beforeEach(function() {
      $content
        .append('<input id="foo">');
        controller = controller('ProfileAnswerCtrl', {
          ProfileAnswers: function() {},
          SN_CONSTANTS: {
            TEXT_MAX_LENGTH: 1
          }
        });
    });

    afterEach(function() {
      $content.empty();
    });

    it('returns char count status of the text field', function() {
      controller.showCharLimit('#foo');

      expect($content.find('#foo__status').text())
        .toBe('1 character left');
    });
  });
});
