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

    Nudge.search = function(recipient_id) { return NudgeResource.query({recipient_id:recipient_id}).$promise; };
    console.log(Nudge)

    return Nudge;
  }

  angular.module('socialNetworking.services')
    .service('Nudges', ['$resource', Nudges]);
})();
