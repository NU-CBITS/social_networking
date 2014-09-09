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
      participantStudyEndDate: '2014-01-01'
    });
  }));

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
});