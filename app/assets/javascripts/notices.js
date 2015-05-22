(function() {
  "use strict";
  
  function Notice() {
    var toastTimeout = 7000;

    this.actionNotice = function(actionType, description, participantId) {
      var self = this;
      this.behaviorPostNotice(actionType, description, participantId);
      setTimeout(
        function () {
          self.incentivePostNotice(actionType, description, participantId);
        }, 3000);
    };

    this.incentivePostNotice = function(actionType, description, participantId) {
      var self = this;
      $.ajax({
        type: "POST",
        url: "/participant_incentives/complete",
        data: {
          "participant_id": participantId,
          "action_type": actionType
        },
        success: function (data, status) {
          if ('success' === status) {
            self.incentivRealTimeToast(description);
          }
        }
      });
    };

    this.behaviorPostNotice = function(actionType, description, participantId) {
      var self = this;
      $.ajax({
        type: "POST",
        url: "/participant_behaviors/complete",
        data: {
          "participant_id": participantId,
          "action_type": actionType
        },
        success: function (data, status) {
          if ('success' === status) {
            self.behaviorRealTimeToast(description);
          }
        }
      });
    };

    this.incentiveToastView = function(incentiveId, description) {
      this.realTimeToast("incentive", description);
      setTimeout(
        function () {
          $.ajax({
            type: "PATCH",
            url: "/participant_incentives/" + incentiveId + "/complete"
          });
        }, toastTimeout);
    };

    this.behaviorToastView = function(behaviorId, description) {
      this.realTimeToast("behavior", description);
      setTimeout(
        function () {
          $.ajax({
            type: "PATCH",
            url: "/participant_behaviors/" + behaviorId + "/complete"
          });
        }, toastTimeout);
    };

    this.incentivRealTimeToast = function(description) {
      this.realTimeToast('incentive', description);
    };

    this.behaviorRealTimeToast = function(description) {
      this.realTimeToast('behavior', description);
    };

    this.realTimeToast = function(type, description) {
      $.toaster(
        {
          title: 'Congratulations',
          priority: 'success',
          message: 'you completed the ' + type + ': ' + description,
          settings: {timeout: toastTimeout}
        });
    };
  }

  window.Notice = new Notice();
}());
