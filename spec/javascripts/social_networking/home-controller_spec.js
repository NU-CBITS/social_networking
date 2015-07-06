describe('HomeCtrl', function() {
  var controller,
      onYourMindResource,
      commentResource,
      homeTool,
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

  beforeEach(inject(function($rootScope, $q, $controller, $filter, _homeTool_) {
    homeTool = _homeTool_;
    scope = $rootScope;
    q = $q;
    controller = $controller('HomeCtrl', {
      OnYourMindResource: onYourMindResource,
      CommentResource: commentResource,
      LikeResource: likeResource,
      homeTool: _homeTool_,
      participantId: 123,
      actionItems: [],
      feedItems: [],
      memberProfiles: [],
      $filter: $filter,
      $http: sharedResource,
      $location: {},
      $scope: scope,
      noticesEnabled: false,
      noticeUtility: Notice
    });
  }));

  it('should initialize the mode', function() {
    expect(controller.inFeedBrowseMode()).toBeTruthy();
  });

  describe('Commenting', function() {
    describe('#commentOn', function() {
      beforeEach(function() {
        spyOn(controller, 'setSelectedItem');
        spyOn(homeTool, 'newCommentOn');
      });

      it('builds and sets the item', function() {
        controller.commentOn();

        expect(controller.setSelectedItem).toHaveBeenCalled();
        expect(homeTool.newCommentOn).toHaveBeenCalled();
      });
    });

    describe('#closeCommentForm', function() {
      it('removes the selected item from being commented on', function() {
        var item = {};
        controller.setSelectedItem(item);

        expect(controller.isCommentingOn(item)).toEqual(true);

        controller.closeCommentForm();

        expect(controller.isCommentingOn(item)).toEqual(false);
      });
    });

    describe('#isCommentingOn', function() {
      it('returns whether the selected item is currently selected for commenting', function() {
        var item = {};

        expect(controller.isCommentingOn(item)).toEqual(false);

        controller.setSelectedItem(item);

        expect(controller.isCommentingOn(item)).toEqual(true);
      });
    });

    describe('#saveComment', function() {
      beforeEach(function() {
        spyOn(controller, 'closeCommentForm');
      });

      describe('when the input field is empty', function() {
        beforeEach(function() {
          spyOn(homeTool, 'getCommentModel').and.callFake(function() {
            return { text: '' };
          });
        });

        it('closes the commenting form', function() {
          controller.saveComment();

          expect(controller.closeCommentForm).toHaveBeenCalled();
        });
      });

      describe('when the input field is populated', function() {
        beforeEach(function() {
          spyOn(homeTool, 'getCommentModel').and.callFake(function() {
            return { text: 'Great thought!' };
          });
        });

        it('closes the commenting form', function() {
          controller.saveComment();
          deferred.resolve({});
          scope.$apply();

          expect(controller.closeCommentForm).toHaveBeenCalled();
        });
      });
    });
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
