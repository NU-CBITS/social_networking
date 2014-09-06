describe('ProfileCtrl', function() {
  var controller,
      participantService,
      nudgeService,
      scope,
      q,
      deferred;
  
  beforeEach(function() {
    // load the module with the controller to test
    module('socialNetworking.controllers');

    participantService = {
      getOne: function(id) {
                deferred = q.defer();

                return deferred.promise;
              }
    };
    nudgeService = {};
  });

  beforeEach(inject(function($rootScope, $q, $controller) {
    scope = $rootScope;
    q = $q;
    controller = $controller('ProfileCtrl', {
      participantId: 123,
      Participants: participantService,
      Nudges: nudgeService
    });
  }));

  it('should set the username', function() {
    deferred.resolve({ username: 'Billy' });
    scope.$digest();

    expect(controller.username).toBe('Billy');
  });

  it('should set the last login', function() {
    deferred.resolve({ lastLogin: '2014-08-12T16:55:29Z' });
    scope.$digest();

    expect(controller.lastLogin).toBe('2014-08-12T16:55:29Z');
  });
});
