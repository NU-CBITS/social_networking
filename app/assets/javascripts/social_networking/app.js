// Create the socialNetworking module and specify its required submodules.
angular.module('socialNetworking', [
  'ngResource',
  'socialNetworking.feed.controllers',
  'socialNetworking.goals.controllers',
  'socialNetworking.profile.controllers',
  'socialNetworking.filters',
  'socialNetworking.directives',
  'socialNetworking.services'
]);
