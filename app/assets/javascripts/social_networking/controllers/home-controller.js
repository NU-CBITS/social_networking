;(function() {
  "use strict";

  // Provides access to the feed and its items.
  function HomeCtrl(OnYourMindResource, homeTool, feedItems, memberProfiles) {
    this._onYourMindResource = OnYourMindResource;
    this.feedItems = feedItems;
    this.memberProfiles = memberProfiles;
    this._homeTool = homeTool;
    this.onYourMindModel = this._homeTool.getOnYourMindStatementModel();
  }

  // Prepare to add a new On Your Mind Statement.
  HomeCtrl.prototype.newOnYourMindStatement = function() {
    this._homeTool.editOnYourMindStatement();
  };

  // Persist a new 'On Your Mind' object.
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

  // Leave On Your Mind Entry Mode.
  HomeCtrl.prototype.cancelOnYourMindEntryMode = function() {
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
    .controller('HomeCtrl', ['OnYourMindResource', 'homeTool', 'feedItems',
                'memberProfiles', HomeCtrl]);
})();
