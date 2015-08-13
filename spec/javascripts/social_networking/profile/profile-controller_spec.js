describe('ProfileCtrl', function() {
  var controller,
      mockAlertService,
      profileService,
      nudgeService,
      scope,
      q,
      deferred,
      deferredNudgeCreate,
      deferredProfileUpdate;
  
  beforeEach(function() {
    // load the module with the controller to test
    module('socialNetworking.controllers');

    mockAlertService = {
      addError: function() {}
    };
    profileService = {
      getOne: function(profileId) {
        deferred = q.defer();
        return deferred.promise;
      },
      update: function() {
        deferredProfileUpdate = q.defer();
        return deferredProfileUpdate.promise;
      }
    };
    nudgeService = {
      create: function() {
        deferredNudgeCreate = q.defer();
        return deferredNudgeCreate.promise;
      }
    };
  });

  beforeEach(inject(function($rootScope, $q, $controller) {
    scope = $rootScope;
    q = $q;
    controller = $controller('ProfileCtrl', {
      alertService: mockAlertService,
      profileId: 1,
      Profiles: profileService,
      Nudges: nudgeService
    });
  }));

  it('should set the id', function() {
    deferred.resolve({ id: '1' });
    scope.$digest();

    expect(controller.id).toBe('1');
  });

  it('displays alert message when nudge fails', function() {
    spyOn(mockAlertService, 'addError');
    controller.nudge();
    deferredNudgeCreate.reject({ data: { error: '' } });
    scope.$digest();

    expect(mockAlertService.addError).toHaveBeenCalled();
  });

  it('displays alert message when profile icon is not found', function() {
    spyOn(mockAlertService, 'addError');
    deferred.reject({ data: { error: '' } });
    scope.$digest();

    expect(mockAlertService.addError).toHaveBeenCalled();
  });

  it('displays alert message when profile updating fails', function() {
    spyOn(mockAlertService, 'addError');
    controller.updateProfileIcon('');
    deferredProfileUpdate.reject({ data: { error: '' } });
    scope.$digest();

    expect(mockAlertService.addError).toHaveBeenCalled();
  });
});
