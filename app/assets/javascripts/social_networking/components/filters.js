;(function() {
  "use strict";

  // Display an ISO8601-formatted timestamp string as a human-readable length
  // of time, e.g. '10 minutes ago'
  function timeFromNow() {
    return function(timestamp) {
      return moment(timestamp).fromNow();
    };
  }

  // Create a module and register the filter.
  angular.module('socialNetworking.filters', [])
    .filter('timeFromNow', timeFromNow);
})();
