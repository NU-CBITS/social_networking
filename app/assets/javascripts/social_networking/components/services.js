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

  function Comments($resource) {
    var CommentResource = $resource('/social_networking/comments/:id',
      { id: '@id' });

    function Comment() {}

    Comment.create = function(attributes) {
      var comment = new CommentResource(attributes);
      comment.$save();
    };

    return Comment;
  }

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
    .service('Nudges', ['$resource', Nudges])
    .service('Comments', ['$resource', Comments])
    .service('Likes', ['$resource', Likes]);
})();
