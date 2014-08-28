;(function() {
  "use strict";

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

  angular.module('socialNetworking.services')
    .service('Comments', ['$resource', Comments]);
})();
