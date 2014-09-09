// Create the socialNetworking module and specify its required submodules.
angular.module('socialNetworking', [
  'ngResource',
  'socialNetworking.controllers',
  'socialNetworking.filters',
  'socialNetworking.directives',
  'socialNetworking.services',
  'socialNetworking.values'
]);

// Define submodules.
angular.module('socialNetworking.controllers', []);
angular.module('socialNetworking.services', []);
angular.module('socialNetworking.values', []);
