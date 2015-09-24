//= require jquery
//= require shared/new_shareable_form

'use strict';

describe('addSharingToNewShareableForm', function() {
  var ACTION_TYPE,
      ITEM_TYPE;

  ITEM_TYPE = 'activity';
  ACTION_TYPE = 'planned';

  function getFixture() {
    return $('#jasmine_content');
  };

  function getPage() {
    return getFixture()
           .find('.new-shareable-form-after-form-groups');
  };

  function initListener(listener) {
    $(document).trigger(listener);
  };

  function setPage() {
    return getFixture()
           .append('<span class="new-shareable-form-after-form-groups" data-item-type="' + ITEM_TYPE + '" data-action-type="' + ACTION_TYPE + '"></span>');
  };

  function setOtherPage() {
    return getFixture();
  };

  afterEach(function() {
    $('#jasmine_content').empty();
  });

  describe('when page does not have shareable field', function() {
    describe('addSharingToNewShareableForm', function() {
      describe('on page change', function() {
        it('doesn\'t throw an error', function() {
          setOtherPage();

          expect(function() {
            initListener('page:change')
          }).not.toThrowError(TypeError);
        });
      });
    });
  });

  describe('when page has shareable field', function() {
    beforeEach(function() {
      setPage();
    });

    describe('addSharingToNewShareableForm', function() {
      describe('on page change', function() {
        beforeEach(function() {
          initListener('page:change');
        });

        it('formats label for attribute', function() {
          expect(getPage().find('label[for=' + ITEM_TYPE + '_shared_item]').length)
            .toEqual(1);
        });

        it('formats label content', function() {
          expect(getPage().find('label[for=' + ITEM_TYPE + '_shared_item]').text())
            .toMatch('Share the content of this ' + ITEM_TYPE);
        });

        it('formats "yes" radio input', function() {
          expect(getPage().find('input#' + ITEM_TYPE + '_shared_item_1[value=1]').length)
            .toEqual(1);
        });

        it('formats "no" radio input', function() {
          expect(getPage().find('input#' + ITEM_TYPE + '_shared_item_2[value=0]').length)
            .toEqual(1);
        });

        it('formats hidden inputs', function() {
          expect(getPage().find('[type="hidden"][value=' + ACTION_TYPE + ']').length)
            .toEqual(1);
        });
      });
    });
  });
});
