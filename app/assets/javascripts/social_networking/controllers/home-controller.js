;(function() {
  "use strict";

  // Provides access to the feed and its items.
  function HomeCtrl(OnYourMindResource, CommentResource, homeTool, actionItems,
                    feedItems, memberProfiles, $filter) {
    this.actionItems = actionItems;
    this.feedItems = feedItems;
    this.memberProfiles = memberProfiles;
    this._homeTool = homeTool;
    this.onYourMindModel = this._homeTool.getOnYourMindStatementModel();
    this.commentModel = this._homeTool.getCommentModel();
    this._onYourMindResource = OnYourMindResource;
    this._commentResource = CommentResource;
    this._findFeedItem = function(filter) {
      return $filter('filter')(this.feedItems, filter)[0];
    };
  }

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
        if (typeof item !== 'undefined') {
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
    this._homeTool.newCommentOn(item);
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
        'homeTool', 'actionItems', 'feedItems', 'memberProfiles', '$filter',
        HomeCtrl]);
})();
