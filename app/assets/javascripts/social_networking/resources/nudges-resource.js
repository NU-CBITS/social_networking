;(function() {
  "use strict";

  function Nudges($resource) {
    var NudgeResource = $resource('/social_networking/nudges/:id',
      { id: '@id' });

    function Nudge() {}

    Nudge.create = function(recipient_id) {
      var nudge = new NudgeResource({
        recipientId: recipient_id
      });

      return nudge.$save();
    };

    Nudge.search = function() {
        return NudgeResource.query.$promise;
    };

    return Nudge;
  }

  angular.module('socialNetworking.services')
    .service('Nudges', ['$resource', Nudges]);
})();
