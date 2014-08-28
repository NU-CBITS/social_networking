;(function() {
  "use strict";

  function Likes($resource) {
    var LikeResource = $resource('/social_networking/likes/:id',
      { id: '@id' });

    function Like() {}

    Like.create = function(attributes) {
      var like = new LikeResource(attributes);
      like.$save();
    };

    return Like;
  }

  angular.module('socialNetworking.services')
    .service('Likes', ['$resource', Likes]);
})();
