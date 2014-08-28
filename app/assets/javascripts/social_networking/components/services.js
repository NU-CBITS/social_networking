;(function() {
  "use strict";

  function Nudges($resource) {
    var NudgeResource = $resource('/nudges/:id', { id: '@id' });

    function Nudge() {}

    Nudge.create = function() {
      var nudge = new NudgeResource();
      nudge.$save();
    };

    return Nudge;
  }

  function Comments($resource) {
    var CommentResource = $resource('/comments/:id', { id: '@id' });

    function Comment() {}

    Comment.create = function() {
      var comment = new CommentResource();
      comment.$save();
    };

    return Comment;
  }

  function Likes($resource) {
    var LikeResource = $resource('/likes/:id', { id: '@id' });

    function Like() {}

    Like.create = function() {
      var like = new LikeResource();
      like.$save();
    };

    return Like;
  }

  angular.module('socialNetworking.services', [])
    .service('Nudges', ['$resource', Nudges])
    .service('Comments', ['$resource', Comments])
    .service('Likes', ['$resource', Likes]);
})();
