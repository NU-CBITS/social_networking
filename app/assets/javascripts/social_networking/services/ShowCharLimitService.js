;(function() {
  'use strict';

  // Service to display the char count available for fields
  function charLimitService(SN_CONSTANTS) {
    var self = this;

    this.textMaxLength = SN_CONSTANTS.TEXT_MAX_LENGTH;
      
    this.resetAllCharCountText = function() {
      $(SN_CONSTANTS.INPUT_CLASS)
        .trigger('check.show-char-limit');
    };

    this.showCharLimit = function(inputTag) {
      self.resetAllCharCountText();
      $(inputTag)
        .showCharLimit({
          maxlength: self.textMaxLength
        });
    };

    return this;
  };

  angular.module('socialNetworking.services')
    .factory('charLimitService', ['SN_CONSTANTS', charLimitService]);
})();
