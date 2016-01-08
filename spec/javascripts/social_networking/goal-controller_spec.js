describe('GoalCtrl', function() {
  var controller,
      goalService,
      scope,
      q,
      createDeferred,
      updateDeferred;

  beforeEach(function() {
    module('socialNetworking.controllers');
    module('socialNetworking.services');

    goalService = {
      create: function(attributes) {
                createDeferred = q.defer();

                return createDeferred.promise;
              },
      update: function(attributes) {
                updateDeferred = q.defer();

                return updateDeferred.promise;
              }
    };
  });

  beforeEach(inject(function($rootScope, $q, $controller, goalTool) {
    scope = $rootScope;
    q = $q;
    controller = $controller('GoalCtrl', {
      Goals: goalService,
      goalTool: goalTool,
      currentGoals: [],
      participantStudyEndDate: '2014-01-01',
      noticesEnabled: false,
      noticeUtility: Notice
    });
  }));

  beforeEach(function() {
    jasmine.clock().install();
  });

  afterEach(function() {
    jasmine.clock().uninstall();
  });

  it('should initialize the mode', function() {
    expect(controller.inBrowseMode()).toBeTruthy();
  });

  describe('#new', function() {
    it('should put the controller into entry mode', function() {
      controller.new();

      expect(controller.inEntryMode()).toBeTruthy();
    });
  });

  describe('#toggleComplete', function() {
    describe('when unsuccessful', function() {
      it('should reset the isCompleted attribute', function() {
        window.confirm = function(msg){
          //return true to simulate the OK button having been clicked
          return true;
        };
        var goal = { isCompleted: true };
        controller.toggleComplete(goal);
        updateDeferred.reject({ isCompleted: false });
        scope.$apply();

        expect(goal.isCompleted).toBeFalsy();
      });
    });
  });

  describe('#toggleDeleted', function() {
    describe('when unsuccessful', function() {
      it('should reset the isDeleted attribute', function() {
        var goal = { isDeleted: true };
        controller.toggleDeleted(goal);
        updateDeferred.reject({ isDeleted: false });
        scope.$apply();

        expect(goal.isDeleted).toBeFalsy();
      });
    });
  });

  describe('#save', function() {
    describe('when successful', function() {
      it('should reset and add the goal to the collection', function() {
        controller.new();
        controller.save();
        createDeferred.resolve({ description: 'goal1' });
        scope.$apply();

        expect(controller.inBrowseMode()).toBeTruthy();
        expect(controller.participantGoals.length).toBe(1);
        expect(controller.participantGoals[0].description).toBe('goal1');
      });
    });

    describe('when unsuccessful', function() {
      it('should set the error', function() {
        controller.new();
        controller.save();
        createDeferred.reject({ error: 'baz' });
        scope.$apply();

        expect(controller.inEntryMode()).toBeTruthy();
        expect(controller.participantGoals.length).toBe(0);
        expect(controller.error).toBe('baz');
      });
    });
  });

  describe('.dateInNWeeks', function() {
    describe('when week number is defined', function() {
      it('returns formatted date of one week in the future', function() {
        var today = moment('2015-12-22').toDate();
        jasmine.clock().mockDate(today);

        expect(controller.dateInNWeeks(1)).toBe('Dec 29 2015');
      });
    })

    describe('when week number is undefined', function() {
      it('returns `null`', function() {
        expect(controller.dateInNWeeks()).toBeNull();
      });
    })
  });

  describe('.dateAtEndOfTrial', function() {
    describe('when studyEndDate is defined', function() {
      describe('when sudy end date is in the past', function() {
        it('returns `null`', function() {
          controller.studyEndDate = new Date(1451423241949);

          expect(controller.dateAtEndOfTrial()).toBeNull();
        });
      });

      describe('when sudy end date is in the future', function() {
        it('returns formatted date of one week in the future', function() {
          var today = moment('2015-12-22').toDate();
          jasmine.clock().mockDate(today);
          controller.studyEndDate = new Date(1451423241949);

          expect(controller.dateAtEndOfTrial()).toBe('Dec 29 2015');
        });
      });
    })

    describe('when studyEndDate is `null`', function() {
      it('returns formatted date of the end of trial', function() {
        controller.studyEndDate = null;

        expect(controller.dateAtEndOfTrial()).toBeNull();
      });
    })
  });

  describe('.atLeastNWeeksLeftInTrial', function() {
    describe('study end date is 2 weeks in the future', function() {
      beforeEach(function() {
        controller.studyEndDate = moment().add(2, 'weeks');
      });

      describe('when week number is before the end date', function() {
        it('returns `true`', function() {
          expect(controller.atLeastNWeeksLeftInTrial(1)).toBe(true);
        });
      });

      describe('when week number is after the end date', function() {
        it('returns `false`', function() {
          expect(controller.atLeastNWeeksLeftInTrial(3)).toBe(false);
        });
      });

      describe('when week number is undefined', function() {
        it('defaults to 0th week', function() {
          expect(controller.atLeastNWeeksLeftInTrial())
            .toBe(controller.atLeastNWeeksLeftInTrial(0));
        });
      });
    });
  });
});
