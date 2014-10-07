;(function() {
  "use strict";

  // Provides access to the feed and its items.
  function HomeCtrl(OnYourMindResource, CommentResource, LikeResource,
                    homeTool, currentParticipantId, actionItems, feedItems,
                    memberProfiles, $filter) {
    this.actionItems = actionItems;
    this.feedItems = feedItems;
    this.memberProfiles = memberProfiles;
    this._homeTool = homeTool;
    this._currentParticipantId = currentParticipantId;
    this.onYourMindModel = this._homeTool.getOnYourMindStatementModel();
    this.commentModel = this._homeTool.getCommentModel();
    this._onYourMindResource = OnYourMindResource;
    this._commentResource = CommentResource;
    this._likeResource = LikeResource;

    this._findFeedItem = function(filter) {
      return $filter('filter')(this.feedItems, filter)[0];
    };

    this._findLikes = function(likes, filter) {
      return $filter('filter')(likes, filter);
    };
  }

  HomeCtrl.prototype.setSelectedItem = function(item) {
    this._homeTool.setSelectedItem(item);
  };

  HomeCtrl.prototype.getSelectedItem = function() {
    return this._homeTool.getSelectedItem();
  };

  HomeCtrl.prototype.hasSummary = function(item) {
    return !!item.isPublic && !angular.equals(item.data, {});
  };

  // Prepare to add a new On Your Mind Statement.
  HomeCtrl.prototype.newOnYourMindStatement = function() {
    this._homeTool.editOnYourMindStatement();
  };

  // Persist a new On Your Mind statement.
  HomeCtrl.prototype.saveOnYourMind = function() {
    var self = this;
    var model = this._homeTool.getOnYourMindStatementModel();

    this._onYourMindResource.create(model)
      .then(function(onYourMind) {
        self.feedItems.push(onYourMind);
        self.cancelOnYourMindEntryMode();
      })
      .catch(function(message) {
        self.error = message.error;
      });
  };

  // Persist a new Comment.
  HomeCtrl.prototype.saveComment = function() {
    var self = this;
    var model = this._homeTool.getCommentModel();

    this._commentResource.create(model)
      .then(function(comment) {
        var item = self._findFeedItem({
          className: comment.itemType,
          id: comment.itemId
        });
        if (item !== void 0) {
          item.comments.push(comment);
        }
        self.cancelOnYourMindEntryMode();
      })
      .catch(function(message) {
        self.error = message.error;
      });
  };

  // Prepare to comment on a feed item.
  HomeCtrl.prototype.commentOn = function(item) {
    this.setSelectedItem(item);
    this._homeTool.newCommentOn(item);
  };

  // A Participant may only like a feed item once.
  HomeCtrl.prototype.canAddLikeTo = function(item) {
    return (this._findLikes(item.likes, {
      participantId: this._currentParticipantId
    }) || []).length === 0;
  };

  // "Like" a feed item.
  HomeCtrl.prototype.addLikeTo = function(item) {
    var self = this;

    this._likeResource.create({ itemType: item.className, itemId: item.id })
      .then(function(like) {
        item.likes.push(like);
      })
      .catch(function(message) {
        self.error = message.error;
      });
  };

  // Is the tool in Feed Browse Mode?
  HomeCtrl.prototype.inFeedBrowseMode = function() {
    return this._homeTool.getMode() === this._homeTool.MODES.FEED;
  };

  // Is the tool in Profiles Browse Mode?
  HomeCtrl.prototype.inProfilesBrowseMode = function() {
    return this._homeTool.getMode() === this._homeTool.MODES.PROFILES;
  };

  // Is the tool in On Your Mind Entry Mode?
  HomeCtrl.prototype.inOnYourMindEntryMode = function() {
    return this._homeTool.getMode() ===
           this._homeTool.MODES.ON_YOUR_MIND_ENTRY;
  };

  // Is the tool in Comment On Mode?
  HomeCtrl.prototype.inCommentOnMode = function() {
    return this._homeTool.getMode() === this._homeTool.MODES.COMMENT_ON;
  };

  // Leave On Your Mind Entry Mode.
  HomeCtrl.prototype.cancelOnYourMindEntryMode = function() {
    this._homeTool.setMode(this._homeTool.MODES.FEED);
  };

  // Leave Comment On Mode.
  HomeCtrl.prototype.cancelCommentOnMode = function() {
    this._homeTool.setMode(this._homeTool.MODES.FEED);
  };

  // Switch tool modes.
  HomeCtrl.prototype.show = function(view) {
    switch (view) {
      case 'feed':
        this._homeTool.setMode(this._homeTool.MODES.FEED);
        break;
      case 'profiles':
        this._homeTool.setMode(this._homeTool.MODES.PROFILES);
    }
  };

  // Create a module and register the controller.
  angular.module('socialNetworking.controllers')
    .controller('HomeCtrl', ['OnYourMindResource', 'CommentResource',
        'LikeResource', 'homeTool', 'currentParticipantId', 'actionItems',
        'feedItems', 'memberProfiles', '$filter', HomeCtrl]);
})();
