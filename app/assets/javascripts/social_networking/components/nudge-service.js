;(function() {
  "use strict";

  function Nudges($resource) {
    var NudgeResource = $resource('/social_networking/nudges/:id',
      { id: '@id' });

    function Nudge() {}

    Nudge.create = function(attributes) {
      var nudge = new NudgeResource({
        recipientId: attributes.recipient.id
      });
      nudge.$save();
    };

    return Nudge;
  }

  angular.module('socialNetworking.services')
    .service('Nudges', ['$resource', Nudges]);
})();
