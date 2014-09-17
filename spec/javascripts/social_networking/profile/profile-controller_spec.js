describe('ProfileCtrl', function() {
  var controller,
      profileService,
      nudgeService,
      scope,
      q,
      deferred;
  
  beforeEach(function() {
    // load the module with the controller to test
    module('socialNetworking.controllers');

    profileService = {
      getOne: function(profileId) {
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
      profileId: 1,
      participantId: 123,
      Profiles: profileService,
      Nudges: nudgeService
    });
  }));

  it('should set the id', function() {
    deferred.resolve({ id: '1' });
    scope.$digest();

    expect(controller.id).toBe('1');
  });

});
