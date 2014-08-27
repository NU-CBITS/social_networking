;(function() {
  // Provides access to the feed and its items.
  function FeedCtrl() {
    this.items = [
      {
        creator: 'Sam',
        createdAt: '2014-08-13T16:23:29Z'
      },
      {
        creator: 'Merry',
        createdAt: '2014-08-12T16:23:29Z'
      }
    ];
  }

  // Create a module and register the controller.
  angular.module('socialNetworking.feed.controllers', [])
    .controller('FeedCtrl', FeedCtrl);
})();
