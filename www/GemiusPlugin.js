var exec = require('cordova/exec');

var GemiusPlugin = {
    eventType: {
        FULL_PAGEVIEW: 0,
        PARTIAL_PAGEVIEW: 1,
        SONAR: 2,
        ACTION: 3,
        STREAM: 4,
        DATA: 5,
    },
    coolMethod: function (arg0, success, error) {
        exec(success, error, 'GemiusPlugin', 'coolMethod', [arg0]);
    },
    logEvent: function(success, error, eventType, params) {
        exec(success, error, 'GemiusPlugin', 'logEvent', [eventType, params]);
    }
};

exports = GemiusPlugin;

window.gemius = GemiusPlugin;