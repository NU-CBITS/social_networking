## 0.4.6 - 2015-07-14
 * Merge pull request #44 from cbitstech/cl_98682348_implement_mobile_feed_layout_change

## 0.4.5 - 2015-07-10
 * Merge pull request #43 from cbitstech/msw_97469748_remove_partial_calls
 * Remove Partial Calls
 * Merge pull request #42 from cbitstech/msw_93446774_notification_redirect
 * Merge pull request #41 from cbitstech/cl_98660544_implement_home_page_layout_change
 * Update Email Redirect
 * Implement Mockup Design On Home Page
 * Merge pull request #40 from cbitstech/msw_bug_add_in_necessary_comment_form
 * Add Comment Form Partial
 * Merge pull request #39 from cbitstech/msw_97469224_comment_form
 * Add Inline Commenting
 * Merge pull request #38 from cbitstech/msw_97540736_action_item_alert
 * Add Action Item Alert

## 0.4.4 - 2015-06-26
 * Merge pull request #37 from cbitstech/msw_96292678_unique_constraint_error
 * Add Model Unique Constraint

## 0.4.3 - 2015-06-03
 * Fix off by one error in feed items returned.
 * Merge pull request #36 from cbitstech/msw_95983632_goal_bug
 * Fix Due On Nil Bug

## 0.4.2 - 2015-06-01
 * Merge pull request #35 from cbitstech/msw_92231126_goal_description
 * Update Goal Action

## 0.4.1 - 2015-05-27
 * Merge pull request #34 from cbitstech/ems_92231126_goal_text
 * Change goal status text.

## 0.4.0 - 2015-05-22
 * Merge pull request #33 from cbitstech/ems-95080280
 * Add use strict into function container.
 * Add specs for notice Ajax calls.
 * Fixed scoping issue with exposure of Notice functions.
 * Inject notice utility into angular controllers.
 * Fix various js test issues an lint issues.
 * Add js dependencies, update controller sigs.
 * fix instruction for running JS specs
 * Move comment notice logic into home controller.
 * Migrate changes for notice creation.

## 0.3.4 - 2015-05-01
 * Merge pull request #31 from cbitstech/ecf_cleanup
 * Merge pull request #30 from cbitstech/ecf_90707872_sn_reports
 * update to Ruby 2.2.2, bump spec coverage minimum
 * enforce iso8601 for Like report timestamp

## 0.3.3 - 2015-04-01
 * Merge pull request #29 from cbitstech/ems-91283378-update-goals-spec
 * Merge pull request #28 from cbitstech/ems-91283446-hide-terminated-profiles
 * Fixed logic problem with goal spec update.
 * Refactor goals spec.
 * Remove terminated profiles from social dash.
 * Merge pull request #27 from cbitstech/ems-91283378-limit-goal-shared-item-notifications
 * Final update to goal spec.
 * Change time in spec for Travis testing.
 * Further update specs.
 * Fix spec issue.
 * Update spec descriptions.
 * Update spec for goal incomplete scope.
 * Update scope for incomplete goals.

## 0.3.2 - 2015-03-30
 * Merge pull request #26 from cbitstech/ems-feed-optimization
 * Update feed paging logic.
 * Further optimizations.

## 0.3.1 - 2015-03-26
 * Merge pull request #25 from cbitstech/ems-90191168
 * Add test cases for shared item controller.

## 0.3.0 - 2015-03-26
 * Merge pull request #24 from cbitstech/ems-90191168-infinite-scroll
 * Fixed several Javascript style issues.
 * Update jasmine test cases.
 * Add infinite scroll to social feed.

## 0.2.8 - 2015-03-24
 * Merge pull request #23 from cbitstech/gs-update-sprockets
 * rubocop
 * Update sprockets-rails to 2.2.2
 * Merge pull request #21 from cbitstech/gs-remove-home-nav-link
 * Remove extra home link from social ham nav

## 0.2.7 - 2015-03-23
 * Merge pull request #20 from cbitstech/ems-90711482
 * Update jasmine test for goal.
 * Update goal coompletion and deletion.
 * Merge pull request #19 from cbitstech/ems-90727968-goal-deletes
 * Fixed broken goal delete logic.

## 0.2.6 - 2015-03-18
 * Merge pull request #18 from cbitstech/ems-90425842-modify-deleted-in-goals
 * Update Goal delete flag.

## 0.2.5 - 2015-03-18
 * Merge pull request #16 from cbitstech/ems-90425788-change-is-completed-to-completed-at
 * Merge pull request #17 from cbitstech/msw_90543322_membership_concern
 * Move Membership Scopes into SN
 * Remove spec.
 * Update spec issue.
 * Replace goal is_completed with completed_at.

## 0.2.4 - 2015-03-17
 * Merge pull request #15 from cbitstech/msw_90191388_participant_concern
 * Create Concern with Participant Associations
 * Merge pull request #14 from cbitstech/msw_90308406_item_participantId_error
 * Remove Error from Home Controller

## 0.2.2 - 2015-03-13
 * Merge pull request #12 from cbitstech/ems-90296008-fix-group-dash
 * Merge pull request #11 from cbitstech/gs-add-social-report-spec
 * Fix rubocop issues.
 * add iso8601 timestamps to date outputs
 * Update like item description.
 * adding social report specs

## 0.2.1 - 2015-03-12
 * Merge pull request #10 from cbitstech/ems-89648754-add-icon-for-comment-item-summary
 * Add image to comment item summary.
 * Merge pull request #9 from cbitstech/ems-90054316-add-like-table-to-group-dash
 * Fix rubocop.
 * Add spec to sharable.
 * Refactor like description.
 * Update item_description output for likes.
 * Fix Rubocop issues.
 * Fix like #item_description specs.
 * Update like.

## 0.2.0 - 2015-03-11
 * Merge pull request #8 from cbitstech/JAH_90052522_update_tagger
 * Update git tagger gem
 * Merge pull request #5 from cbitstech/msw_action_type
 * Set Action Type on Save for Shared Items
 * Merge pull request #6 from cbitstech/JAH-batch_reports
 * refactored report code for rubocop
 * Move social reports to social networking

## 0.1.7 - 2015-03-09
 * Bug fix for mailer, add git tagger gem

## 0.1.5 - 2015-03-02
 * minor fix to ensure mail delivery in Rails 4.2.0

## 0.1.4 - 2015-03-02
 * configure with SimpleCov
 * update to Rails 4.2.0

## 0.1.3 - 2015-02-19
 * Add ng-cloak directive to Angular template
 * configure Travis Slack integration
 * Remove trailing period from email templates

## 0.1.2 - 2015-02-05
 * further configure Feed Tool

## 0.1.1 - 2015-02-05
 * refactored Feed Tool to accommodate installation as a normal Bit Core Tool
 * minor cleanup, fixed deprecation warnings, updated Brakeman

## 0.1.0 - 2015-02-05
 * refactored Goals Tool to accommodate installation as normal BitCore::Tool
 * use Ruby 2.2.0 in Travis and RVM

## 0.0.37 - 2015-01-27
 * refactored inline styles and stylesheets

## 0.0.36 - 2015-01-23
 * Added due date for goals

## 0.0.35 - 2015-01-21
 * removed message view

## 0.0.34 - 2015-01-20
 * modified Goal scope

## 0.0.33 - 2015-01-20
 * augmented Goal to simplify finding and sharing past due Goals

## 0.0.32
  * refactored and improved robustness of Shared Item query

## 0.0.31
  * modified urls sent in the message bodies for likes, comments and nudge notifications to point to the home of social networking

## 0.0.30
  * added email subjects for likes, comments and nudge notifications

## 0.0.29
  * refactored notifications when commenting or liking your own feed item

## 0.0.28
  * removed notifications when commenting or liking your own feed item

## 0.0.27
  * updated RuboCop gem
  * fixed RuboCop offense

## 0.0.26
  * fix To Do link to Profile page (turn off Turbolinks)

## 0.0.25
  * feed item nil check added to solve staging bugs due to malformed data

## 0.0.24
  * fixes issue with feed item bleed from external groups

## 0.0.23

### bug fix
  * fix navigation away from comment form by reloading page

## 0.0.21

### enhancments
  * removed cancel button from profile questions

## 0.0.20

### enhancments
  * added back partial that was inadvertently removed in profile page

## 0.0.19

### bug fix
  * modified position of edit icon on profile page
