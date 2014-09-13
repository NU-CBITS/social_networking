;(function() {
  'use strict';

  // Communicates with the 'on_the_mind_statements' server API.
  function OnYourMindStatements($resource) {
    var OnYourMindResource = $resource(
        '/social_networking/on_the_mind_statements/:id',
        { id: '@id' }
      );

    function OnYourMind() {}

    // Create a new 'On the Mind Statement' on the server.
    //
    // returns {Promise} A promise of the request.
    OnYourMind.create = function(attributes) {
      var onYourMind = new OnYourMindResource({
        description: attributes.description
      });

      return onYourMind.$save();
    };

    return OnYourMind;
  }

  angular.module('socialNetworking.services')
    .service('OnYourMindResource', ['$resource', OnYourMindStatements]);
})();
