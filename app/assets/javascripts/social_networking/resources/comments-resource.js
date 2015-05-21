;(function() {
  "use strict";

  // Service for managing remote Comments
  function Comments($resource) {
    var CommentResource = $resource('/social_networking/comments/:id',
      { id: '@id' });

    function Comment() {}

    // Persist a Comment to the server.
    Comment.create = function(attributes) {
      var comment = new CommentResource({
        text: attributes.text,
        itemType: attributes.itemType,
        itemId: attributes.itemId
      });
      return comment.$save();
    };

    return Comment;
  }

  angular.module('socialNetworking.services')
    .service('CommentResource', ['$resource', Comments]);
})();
