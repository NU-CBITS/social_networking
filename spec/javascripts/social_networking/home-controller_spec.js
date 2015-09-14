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
      },
      get: function() {
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

  describe('#timeAgoInWords', function() {
    var foo;

    beforeEach(function() {
      foo = {
        calendar: function() {
          return "foo";
        }
      };
      window.moment = function() {
        return foo;
      };

      spyOn(foo, 'calendar');
    });

    it('runs .calendar to display the time in words of an event', function() {
      controller.timeAgoInWords();

      expect(foo.calendar).toHaveBeenCalled();
    });
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
      expect(controller.inFeedBrowseMode()).toBeFalsy();
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

  describe('#getMore', function() {
    describe('when feed is disabled', function() {
      it('remains disabled', function() {
        controller.feedDisabled = true;
        controller.getMore();

        expect(controller.feedDisabled).toBe(true);
      });
    });

    describe('when feed is enabled', function() {
      it('is set to disabled', function() {
        controller.feedDisabled = false;
        controller.getMore();

        expect(controller.feedDisabled).toBe(true);
      });

      describe('when promise resolves', function() {
        function getMore(items) {
          items = items || [];
          controller.getMore();
          deferred.resolve({data: {feedItems: items}});
          scope.$digest();
        }

        describe('when feed items exist', function() {
          var items = ['foo'];

          it('sets concatenated feed items', function() {
            controller.feedItems = ['bar']
            getMore(items);

            expect(controller.feedItems).toEqual(['bar', 'foo']);
          });

          it('disables feed', function() {
            controller.feedDisabled = false;
            getMore(items);

            expect(controller.feedDisabled).toBe(false);
          });

          it('increments the page number', function() {
            controller.page = 1;
            getMore(items);

            expect(controller.page).toBe(2);
          });
        });

        describe('when no feed items exist', function() {
          function getFixture() {
            return $('#jasmine_content');
          }

          function getFeed() {
            return getFixture()
                   .append('<div id="infinite-feed" infinite-scroll-disabled="false" />')
                   .find('#infinite-feed');
          }

          it('disables infinite scroll', function() {
            var feed = getFeed();
            
            expect(feed.attr('infinite-scroll-disabled')).toBe('false');

            getMore();

            expect(feed.attr('infinite-scroll-disabled')).toBe('true');
          });
        });
      });
    });
  });

  describe('#canAddLikeTo', function() {
    var item;

    beforeEach(function() {
      item = {};
      expect(controller._currentParticipantId)
        .toEqual(123);
    });

    it('returns false if the item is a nudge', function() {
      expect(controller.canAddLikeTo({ description: "nudge" }))
        .toEqual(false);
    });

    it('returns false if the item is has already been liked by the participant', function() {
      item.likes = [{ participantId: 123 }];

      expect(controller.canAddLikeTo(item))
        .toEqual(false);
    });

    it('returns true if the item is has not been liked by the current participant and the item is not a nudge', function() {
      item.description = "foo";
      item.likes = [{ participantId: 1 }];

      expect(controller.canAddLikeTo(item))
        .toEqual(true);
    });
  });

  describe('#isLikeable', function() {
    it('returns true if the item is not a nudge', function() {
      expect(controller.isLikeable({ description: "foo" }))
        .toEqual(true);
    });

    it('returns false if the item is not a nudge', function() {
      expect(controller.isLikeable({ description: "nudge" }))
        .toEqual(false);
    });
  });

  describe('#associationCount', function() {
    var item;

    beforeEach(function() {
      item = {};
    });

    it('returns the number of associations', function() {
      item.likes = [{ participantId: 1 }];

      expect(controller.associationCount(item.likes))
        .toEqual(1);
    });

    it('returns the 0 if no associations exist', function() {
      expect(controller.associationCount(item.likes))
        .toEqual(0);
    });
  });
});
