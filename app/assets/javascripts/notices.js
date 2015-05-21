var Notice = (function() {
  "use strict";
  var toastTimeout = 7000;

  var actionNotice = function(actionType, description, participantId) {
    behaviorPostNotice(actionType, description, participantId);
    setTimeout(
      function () {
        incentivePostNotice(actionType, description, participantId);
      }, 3000);
  };

  var incentivePostNotice = function(actionType, description, participantId) {
    $.ajax({
      type: "POST",
      url: "/participant_incentives/complete",
      data: {
        "participant_id": participantId,
        "action_type": actionType
      },
      success: function (data, status) {
        if ('success' === status) {
          incentivRealTimeToast(description);
        }
      }
    });
  };

  var behaviorPostNotice = function(actionType, description, participantId) {
    $.ajax({
      type: "POST",
      url: "/participant_behaviors/complete",
      data: {
        "participant_id": participantId,
        "action_type": actionType
      },
      success: function (data, status) {
        if ('success' === status) {
          behaviorRealTimeToast(description);
        }
      }
    });
  };

  var incentiveToastView = function(incentiveId, description) {
    realTimeToast("incentive", description);
    setTimeout(
      function () {
        $.ajax({
          type: "PATCH",
          url: "/participant_incentives/" + incentiveId + "/complete"
        });
      }, toastTimeout);
  };

  var behaviorToastView = function(behaviorId, description) {
    realTimeToast("behavior", description);
    setTimeout(
      function () {
        $.ajax({
          type: "PATCH",
          url: "/participant_behaviors/" + behaviorId + "/complete"
        });
      }, toastTimeout);
  };

  var incentivRealTimeToast = function(description) {
    realTimeToast('incentive', description);
  };

  var behaviorRealTimeToast = function(description) {
    realTimeToast('behavior', description);
  };

  var realTimeToast = function(type, description) {
    $.toaster(
      {
        title: 'Congratulations',
        priority: 'success',
        message: 'you completed the ' + type + ': ' + description,
        settings: {timeout: toastTimeout}
      });
  };

  return this;
}());
