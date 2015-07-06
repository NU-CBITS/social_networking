;(function() {
  'use strict';

  // Returns an object that stores the state of the Home Tool.
  function HomeToolService() {
    // The default values for an 'On Your Mind Statement'.
    var onYourMindStatementDefaults = {
      description: ''
    };

    // Stores the state of the Home Tool.
    function HomeTool() {
      this._mode = HomeTool.MODES.FEED;
      this._onYourMindStatementModel = {};
      this._commentModel = {};
      this._selectedItem = null;
    }

    // Tool modes triggered by user actions.
    HomeTool.MODES = {
      PROFILES: 0,
      FEED: 1,
      ON_YOUR_MIND_ENTRY: 2
    };
    HomeTool.prototype.MODES = HomeTool.MODES;

    HomeTool.prototype.getMode = function() { return this._mode; };

    HomeTool.prototype.setMode = function(mode) { this._mode = mode; };

    // Prepare to edit an 'On Your Mind Statement'.
    HomeTool.prototype.editOnYourMindStatement = function() {
      this._setOnYourMindStatementModel();
      this.setMode(this.MODES.ON_YOUR_MIND_ENTRY);
    };

    HomeTool.prototype.newCommentOn = function(item) {
      this._setCommentModel({
        text: '',
        itemType: item.className,
        itemId: item.id
      });
    };

    HomeTool.prototype.getOnYourMindStatementModel = function() {
      return this._onYourMindStatementModel;
    };

    HomeTool.prototype.getCommentModel = function() {
      return this._commentModel;
    };

    HomeTool.prototype.setSelectedItem = function(item) {
      this._selectedItem = item;
    };

    HomeTool.prototype.getSelectedItem = function() {
      return this._selectedItem;
    };

    // Reset On Your Mind Statement properties to defaults.
    HomeTool.prototype._setOnYourMindStatementModel = function() {
      this._copyOnYourMindStatement(onYourMindStatementDefaults,
                                    this._onYourMindStatementModel);
    };

    // Copy On Your Mind Statement properties.
    HomeTool.prototype._copyOnYourMindStatement = function(src, dst) {
      dst.description = src.description;
    };

    // Reset Comment properties to defaults.
    HomeTool.prototype._setCommentModel = function(attributes) {
      this._copyComment(attributes, this._commentModel);
    };

    // Copy Comment properties.
    HomeTool.prototype._copyComment = function(src, dst) {
      dst.text = src.text;
      dst.itemId = src.itemId;
      dst.itemType = src.itemType;
    };

    return new HomeTool();
  }

  angular.module('socialNetworking.services')
    .service('homeTool', HomeToolService);
})();
