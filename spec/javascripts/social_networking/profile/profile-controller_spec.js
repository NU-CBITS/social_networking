describe('ProfileCtrl', function() {
  var controller,
      participantService,
      nudgeService,
      scope,
      q,
      deferred;
  
  beforeEach(function() {
    module('socialNetworking.profile.controllers');
    participantService = {
      getOne: function(id) {
                deferred = q.defer();

                return deferred.promise;
              }
    };
    nudgeService = {};
  });

  beforeEach(inject(function($rootScope, $controller, $q) {
    scope = $rootScope.$new();
    q = $q;
    controller = $controller('ProfileCtrl', {
      Participants: participantService,
      Nudges: nudgeService
    });
  }));

  it('should set the username', function() {
    deferred.resolve({ username: 'Billy' });
    scope.$root.$digest();

    expect(controller.username).toBe('Billy');
  });

  it('should set the last login', function() {
    deferred.resolve({ lastLogin: '2014-08-12T16:55:29Z' });
    scope.$root.$digest();

    expect(controller.lastLogin).toBe('2014-08-12T16:55:29Z');
  });
});
