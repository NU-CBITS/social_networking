;(function() {
  "use strict";

  // Displays pertinent information about a participant.
  var profileStatus = function() {
    return {
      template: '<h2>{{ profile.username }}</h2>' +
                '<h3>{{ profile.lastLogin | timeFromNow }}</h3>'
    };
  };

  // Summarizes an item to be displayed in a feed.
  var feedItem = function() {
    return {
      template: '<p>{{ item.creator }}</p>' +
                '<p>{{ item.createdAt | timeFromNow }}</p>'
    };
  };

  // Create a module and register the directives.
  angular.module('socialNetworking.directives', [])
    .directive('profileStatus', profileStatus)
    .directive('feedItem', feedItem);
})();
