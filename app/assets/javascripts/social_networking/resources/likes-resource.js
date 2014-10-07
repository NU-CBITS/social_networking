;(function() {
  "use strict";

  // Service for managing remote Likes.
  function Likes($resource) {
    var LikeResource = $resource('/social_networking/likes/:id',
      { id: '@id' });

    function Like() {}

    // Persist a Like to the server.
    Like.create = function(attributes) {
      var like = new LikeResource({
        itemType: attributes.itemType,
        itemId: attributes.itemId
      });

      return like.$save();
    };

    return Like;
  }

  angular.module('socialNetworking.services')
    .service('LikeResource', ['$resource', Likes]);
})();
