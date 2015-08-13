describe('Alert', function() {
  var alertService;

  beforeEach(module('socialNetworking.services'));

  beforeEach(function() {
    inject(function($injector) {
      alertService = $injector.get('alertService');
    });
  });

  describe('#addError', function() {
    it('adds an error alert to the alerts array', function() {
      expect(alertService.alerts).toEqual([]);

      alertService.addError("Big Peanut");

      expect(alertService.alerts).toEqual([{
        cssClass: "alert-danger",
        message: "Big Peanut"
      }])
    });
  });
});
