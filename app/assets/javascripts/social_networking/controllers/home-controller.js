;(function() {
  'use strict';

  var NUDGE = 'nudge';

  // Provides access to the feed and its items.
  function HomeCtrl(OnYourMindResource, CommentResource, LikeResource,
                    homeTool, participantId, actionItems, feedItems,
                    memberProfiles, $filter, $http, $location, $scope,
                    noticesEnabled, noticeUtility, resource, SN_CONSTANTS) {
    this.actionItems = actionItems;
    this.feedItems = feedItems;
    this.textMaxLength = SN_CONSTANTS.TEXT_MAX_LENGTH;
    this.bootstrapInputClass = SN_CONSTANTS.INPUT_CLASS;
    this.page = 0;
    this.feedDisabled = false;
    this._memberProfiles = memberProfiles;
    this._homeTool = homeTool;
    this._participantId = participantId;
    this.onYourMindModel = this._homeTool.getOnYourMindStatementModel();
    this.commentModel = this._homeTool.getCommentModel();
    this._onYourMindResource = OnYourMindResource;
    this._commentResource = CommentResource;
    this._likeResource = LikeResource;
    this._sharedResource = $http;
    this._$location = $location;
    this.noticesEnabled = noticesEnabled;
    this.noticeUtility = noticeUtility;
    this._resource = resource;

    this._findFeedItem = function(filter) {
      return $filter('filter')(this.feedItems, filter)[0];
    };

    this._findLikes = function(likes, filter) {
      return $filter('filter')(likes, filter);
    };

    $scope.$on('$locationChangeStart', function(e, newUrl, oldUrl) {
      if (oldUrl.split('#')[1] === '/commentForm') {
        // force a refresh
        location.href = newUrl.split('#')[0];
      }
    });
  }

  HomeCtrl.prototype.associationCount = function(associationArray) {
    return associationArray ? associationArray.length : 0;
  };

  HomeCtrl.prototype.getMore = function() {
    if(!this.feedDisabled) {
      this.feedDisabled = true;
      this.retrieveFeed();
    }
  };

  HomeCtrl.prototype.resetFeed = function() {
    this.feedDisabled = false;
    this.feedItems = [];
    this.page = 0;
    $('#infinite-feed').attr('infinite-scroll-disabled', 'false');
    this.retrieveFeed();
  };

  HomeCtrl.prototype.retrieveFeed = function () {
    var responsePromise = this._sharedResource.get('/social_networking/' + this._resource + '/participant/' + this._participantId + '/page/' + this.page);
    var self = this;

    function successCallback(data, status, headers, config) {
      data = data.data;
      if (data && data.feedItems && 0 < data.feedItems.length) {
        self.feedItems = self.feedItems.concat(data.feedItems);
        self.feedDisabled = false;
        self.page += 1;
      } else {
        $('#infinite-feed').attr('infinite-scroll-disabled', 'true');
      }
    }

    responsePromise.then(successCallback);
  };

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
        self.resetFeed();
      })
      .catch(function(message) {
        self.error = message.error;
      });
  };

  // Persist a new Comment.
  HomeCtrl.prototype.saveComment = function() {
    var self = this;
    var model = this._homeTool.getCommentModel();
    self.closeCommentForm();

    if (model.text && model.text !== '') {
      this._commentResource.create(model)
        .then(function(comment) {
          var item = self._findFeedItem({
            className: comment.itemType,
            id: comment.itemId
          });
          if (item !== void 0) {
            item.comments.push(comment);
          }
          if (self.noticesEnabled && self.noticeUtility) {
            self.noticeUtility.actionNotice('SocialNetworking::Comment',
              'Comment on some shared content.',
              comment.participantId);
          }
        })
        .catch(function(message) {
          self.error = message.error;
        });
    }
  };

  // Prepare to comment on a feed item.
  HomeCtrl.prototype.commentOn = function(item) {
    this.setSelectedItem(item);
    this._homeTool.newCommentOn(item);
  };

  HomeCtrl.prototype.addLikeTo = function(item) {
    var self = this;

    this._likeResource.create({ itemType: item.className, itemId: item.id })
      .then(function(like) {
        item.likes.push(like);
        if(self.noticesEnabled && self.noticeUtility) {
          self.noticeUtility.actionNotice('SocialNetworking::Like',
                              'Like a person\'s shared content.',
                              item.participantId);
        }
      })
      .catch(function(message) {
        self.error = message.error;
      });
  };

  HomeCtrl.prototype.hasLikeableContent = function(item) {
    return !isNudge(item);
  };

  // Is the tool in Feed Browse Mode?
  HomeCtrl.prototype.inFeedBrowseMode = function() {
    return this._homeTool.getMode() === this._homeTool.MODES.FEED;
  };

  // Is the tool in On Your Mind Entry Mode?
  HomeCtrl.prototype.inOnYourMindEntryMode = function() {
    this.resetAllCharCountText(this.bootstrapInputClass);

    return this._homeTool.getMode() ===
           this._homeTool.MODES.ON_YOUR_MIND_ENTRY;
  };

  HomeCtrl.prototype.isCommentingOn = function(item) {
    return this._homeTool.getSelectedItem(item) === item;
  };

  HomeCtrl.prototype.isLikeable = function(item) {
    return !isNudge(item) && !participantHasLiked(this, item);
  };

  // Leave On Your Mind Entry Mode.
  HomeCtrl.prototype.cancelOnYourMindEntryMode = function() {
    this._homeTool.setMode(this._homeTool.MODES.FEED);
  };

  HomeCtrl.prototype.closeCommentForm = function() {
    this._homeTool.setSelectedItem({});
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

  HomeCtrl.prototype.profileIconSrcFor = function(item) {
    for (var i = 0; i < this._memberProfiles.length; i += 1) {
      if (item && (this._memberProfiles[i].participantId === item.participantId)) {
        return this._memberProfiles[i].iconSrc;
      }
    }
  };

  HomeCtrl.prototype.profileDisplayNameFor = function(item) {
    for (var i = 0; i < this._memberProfiles.length; i += 1) {
      if (item && (this._memberProfiles[i].participantId === item.participantId)) {
        return this._memberProfiles[i].username;
      }
    }
  };

  HomeCtrl.prototype.resetAllCharCountText = function(inputClass) {
    $(inputClass)
      .trigger('check.show-char-limit');
  };

  HomeCtrl.prototype.showCharLimit = function(inputTag) {
    this.resetAllCharCountText(this.bootstrapInputClass);

    $(inputTag)
      .showCharLimit({
        maxlength: this.textMaxLength
      });
  };

  HomeCtrl.prototype.taskVisited = function(item) {
    $.ajax({
      async: false,
      dataType: 'script',
      type: 'PUT',
      url: '/participants/task_status/' + item.task_id
    });
  };

  HomeCtrl.prototype.timeAgoInWords = function(createdAt) {
    return moment(createdAt).calendar();
  };

  function isNudge(item) {
    return itemDescription(item) === NUDGE;
  }

  function itemDescription(item) {
    return item.description;
  }

  function participantHasLiked(controller, item) {
    return (controller._findLikes(item.likes, {
      participantId: controller._participantId
    }) || []).length !== 0;
  }

  // Create a module and register the controller.
  angular.module('socialNetworking.controllers')
    .controller('HomeCtrl', ['OnYourMindResource', 'CommentResource',
        'LikeResource', 'homeTool', 'participantId', 'actionItems',
        'feedItems', 'memberProfiles', '$filter', '$http', '$location',
        '$scope', 'noticesEnabled', 'noticeUtility', 'resource', 'SN_CONSTANTS', HomeCtrl]);
})();
