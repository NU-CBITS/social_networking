describe('Notice', function() {
  var server, noticeUtility, callback;
  var actionType, description, participantId;

  beforeEach(function() {
    actionType = "SocialNetworking::Goal";
    description = "Completed a goal."
    participantId = 1;

    server = sinon.fakeServer.create();
    callback = sinon.spy();
    noticeUtility = window.Notice
  });

  afterEach(function() {
    server.restore();
  });

  describe('#behaviorPostNotice', function() {
    it('should trigger #behaviorRealTimeToast upon success', function() {
      expect(noticeUtility.behaviorPostNotice).toBeTruthy();
      noticeUtility.behaviorRealTimeToast = callback;
      noticeUtility.behaviorPostNotice(actionType, description, participantId);

      expect(server.requests.length).toBe(1);
      expect(server.requests[0].url).toBe("/participant_behaviors/complete");
    });
  });

  describe('#incentivePostNotice', function() {
    it('should trigger #incentivRealTimeToast upon success', function() {
      expect(noticeUtility.incentivePostNotice).toBeTruthy();
      noticeUtility.incentivRealTimeToast = callback;
      noticeUtility.incentivePostNotice(actionType, description, participantId);

      expect(server.requests.length).toBe(1);
      expect(server.requests[0].url).toBe("/participant_incentives/complete");
    });
  });

  it('should offer a public incentive specific notification function (behaviorPostNotice)', function() {
    expect(noticeUtility.behaviorPostNotice).toBeTruthy();
  });
});