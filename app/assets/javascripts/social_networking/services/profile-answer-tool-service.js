;(function() {
    'use strict';

    function ProfileAnswerToolService(focus) {

        function ProfileAnswerTool() {}

        ProfileAnswerTool.prototype.MODES = {
            BROWSE: 0,
            ENTRY: 1
        };

        ProfileAnswerTool.prototype.edit = function(answer) {
            this.setModel(answer);
            this.setMode(this.MODES.ENTRY);
            focus('new-answer');
        };

        ProfileAnswerTool.prototype.getMode = function() { return this._mode; };

        ProfileAnswerTool.prototype.setMode = function(mode) { this._mode = mode; };

        ProfileAnswerTool.prototype.setModel = function(answer) {
            var a = answer;
            this._answerModel.id = a.id;
        };

        ProfileAnswerTool.prototype.getModel = function() { return this._answerModel; };

        ProfileAnswerTool.prototype.setTab = function(name) { this._tab = name; };

        ProfileAnswerTool.prototype.getTab = function() { return this._tab; };

        ProfileAnswerTool.prototype._mode = ProfileAnswerTool.prototype.MODES.BROWSE;

        ProfileAnswerTool.prototype._currentFilter = {};

        ProfileAnswerTool.prototype._answerModel = {};

        ProfileAnswerTool.prototype._tab = 'all';

        return new ProfileAnswerTool();
    }

    angular.module('socialNetworking.services')
        .service('answerTool', ['focus', ProfileAnswerToolService]);
})();
