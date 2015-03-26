describe('HomeCtrl', function() {
  var controller,
      onYourMindResource,
      commentResource,
      likeResource,
      scope,
      q,
      deferred,
      sharedResource;

  beforeEach(function() {
    module('socialNetworking.controllers');
    module('socialNetworking.services');

    onYourMindResource = {
      create: function(attributes) {
                deferred = q.defer();

                return deferred.promise;
              }
    };
    commentResource = {
      create: function() {
                deferred = q.defer();

                return deferred.promise;
              }
    };
    likeResource = {
      create: function() {
                deferred = q.defer();

                return deferred.promise;
              }
    };
    sharedResource = {
      create: function() {
        deferred = q.defer();

        return deferred.promise;
      }
    }
  });

  beforeEach(inject(function($rootScope, $q, $controller, $filter, homeTool) {
    scope = $rootScope;
    q = $q;
    controller = $controller('HomeCtrl', {
      OnYourMindResource: onYourMindResource,
      CommentResource: commentResource,
      LikeResource: likeResource,
      homeTool: homeTool,
      participantId: 123,
      actionItems: [],
      feedItems: [],
      memberProfiles: [],
      $filter: $filter,
      $http: sharedResource,
      $location: {},
      $scope: scope
    });
  }));

  it('should initialize the mode', function() {
    expect(controller.inFeedBrowseMode()).toBeTruthy();
  });

  describe('#show', function() {
    it('should set the appropriate mode', function() {
      controller.show('profiles');
      expect(controller.inProfilesBrowseMode()).toBeTruthy();
      controller.show('feed');
      expect(controller.inFeedBrowseMode()).toBeTruthy();
    });
  });

  describe('#saveOnYourMind', function() {
    describe('when successful', function() {
      it('should return to feed mode and add the statement to the feed', function() {
        controller.saveOnYourMind();
        deferred.resolve({ feedItems: 'feed item' });
        controller.resetFeed = function() { return true; }
        scope.$apply();

        expect(controller.inFeedBrowseMode()).toBeTruthy();
        expect(controller.feedItems.length).toBe(1);
      });
    });

    describe('when unsuccessful', function() {
      it('should set the error', function() {
        controller.newOnYourMindStatement();
        controller.saveOnYourMind();
        deferred.reject({ error: 'baz' });
        scope.$apply();

        expect(controller.inOnYourMindEntryMode()).toBeTruthy();
        expect(controller.feedItems.length).toBe(0);
        expect(controller.error).toBe('baz');
      });
    });
  });
});
