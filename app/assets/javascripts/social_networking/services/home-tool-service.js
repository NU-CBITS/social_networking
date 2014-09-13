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

    HomeTool.prototype.getOnYourMindStatementModel = function() {
      return this._onYourMindStatementModel;
    };

    HomeTool.prototype._setOnYourMindStatementModel = function() {
      this._copyOnYourMindStatement(onYourMindStatementDefaults,
                                    this._onYourMindStatementModel);
    };

    HomeTool.prototype._copyOnYourMindStatement = function(src, dst) {
      dst.description = src.description;
    };

    return new HomeTool();
  }

  angular.module('socialNetworking.services')
    .service('homeTool', HomeToolService);
})();
