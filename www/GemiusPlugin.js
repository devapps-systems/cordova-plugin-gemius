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

    /**
     * Updates the user's avatar image.
     * @param {Function} success - the success callback for the plugin call
     * @param {Function} error - the failure callback for the plugin call
     * @param {eventType} eventType - The event type for the call
     * @param {Object} params - The optional additional parameters to be passed
     */
    logEvent: function(success, error, eventType, params) {
        console.log("GemiusPlugin JS: eventType --> ", eventType);
        console.log("GemiusPlugin JS: params --> ", JSON.stringify(params));
        exec(success, error, 'GemiusPlugin', 'logEvent', [eventType, params]);
    }
};

exports = GemiusPlugin;

window.gemius = GemiusPlugin;
