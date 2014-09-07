describe('GoalCtrl', function() {
  var controller,
      goalService,
      focusService,
      scope,
      q,
      getAllDeferred,
      createDeferred;

  beforeEach(function() {
    module('socialNetworking.controllers');

    goalService = {
      getAll: function() {
                getAllDeferred = q.defer();

                return getAllDeferred.promise;
              },
      create: function(attributes) {
                createDeferred = q.defer();

                return createDeferred.promise;
              }
    };
    focusService = function(name) {};
  });

  beforeEach(inject(function($rootScope, $q, $controller) {
    scope = $rootScope;
    q = $q;
    controller = $controller('GoalCtrl', {
      Goals: goalService,
      focus: focusService
    });
  }));

  it('should initialize the attributes and mode', function() {
    expect(controller.description).toBe('');
    expect(controller.inBrowseMode()).toBeTruthy();
  });

  it('should fetch the goals', function() {
    getAllDeferred.resolve([{ name: 'goal1' }, { name: 'goal2' }]);
    scope.$digest();

    expect(controller.participantGoals.length).toBe(2);
  });

  describe('#new', function() {
    it('should put the controller into entry mode', function() {
      controller.new();

      expect(controller.inEntryMode()).toBeTruthy();
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
