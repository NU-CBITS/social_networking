;(function() {
  "use strict";

  // Displays pertinent information about a participant.
  function profileStatus() {
    return {
      template: '<h2>{{ profile.participant.username }}</h2>' +
                '<h3>{{ profile.lastLogin | timeFromNow }}</h3>'
    };
  }

  // Summarizes an item to be displayed in a feed.
   function feedItem() {
    return {
      template: '<p>{{ item.creator }}</p>' +
                '<p>{{ item.createdAt | timeFromNow }}</p>'
    };
  }

  // Create a module and register the directives.
  angular.module('socialNetworking.directives', [])
    .directive('profileStatus', profileStatus)
    .directive('feedItem', feedItem);
})();
