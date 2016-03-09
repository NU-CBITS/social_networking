// Create the socialNetworking module and specify its required submodules.
angular.module('socialNetworking', [
  'ngResource',
  'infinite-scroll',
  'socialNetworking.controllers',
  'socialNetworking.filters',
  'socialNetworking.directives',
  'socialNetworking.services',
  'socialNetworking.values'
]).constant("SN_CONSTANTS", {
  TEXT_MAX_LENGTH: 1000,
  INPUT_CLASS: '.form-control'
});

// Define submodules.
angular.module('socialNetworking.controllers', []);
angular.module('socialNetworking.services', []);
angular.module('socialNetworking.values', []);
