var Notice = (function() {
  var toastTimeout = 7000;

  this.actionNotice = function(actionType, description, participantId) {
    behaviorPostNotice(actionType, description, participantId);
    setTimeout(
      function () {
        incentivePostNotice(actionType, description, participantId);
      }, 3000);
  }

  this.incentivePostNotice = function(actionType, description, participantId) {
    $.ajax({
      type: "POST",
      url: "/participant_incentives/complete",
      data: {
        "participant_id": participantId,
        "action_type": actionType
      },
      success: function (data, status) {
        if ('success' === status) {
          incentive_real_time_toast(description);
        }
      }
    });
  }

  this.behaviorPostNotice = function(actionType, description, participantId) {
    $.ajax({
      type: "POST",
      url: "/participant_behaviors/complete",
      data: {
        "participant_id": participantId,
        "action_type": actionType
      },
      success: function (data, status) {
        if ('success' === status) {
          behavior_real_time_toast(description);
        }
      }
    });
  }

  this.incentiveToastView = function(incentiveId, description) {
    real_time_toast("incentive", description);
    setTimeout(
      function () {
        $.ajax({
          type: "PATCH",
          url: "/participant_incentives/" + incentiveId + "/complete"
        });
      }, toastTimeout);
  }

  this.behaviorToastView = function(behaviorId, description) {
    real_time_toast("behavior", description);
    setTimeout(
      function () {
        $.ajax({
          type: "PATCH",
          url: "/participant_behaviors/" + behaviorId + "/complete"
        });
      }, toastTimeout);
  }

  this.incentive_real_time_toast = function(description) {
    real_time_toast('incentive', description);
  }

  this.behavior_real_time_toast = function(description) {
    real_time_toast('behavior', description);
  }

  this.real_time_toast = function(type, description) {
    $.toaster(
      {
        title: 'Congratulations',
        priority: 'success',
        message: 'you completed the ' + type + ': ' + description,
        settings: {timeout: toastTimeout}
      })
  }

  return this;
}());
