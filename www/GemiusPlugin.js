var exec = require('cordova/exec');

var GemiusPlugin = {
    coolMethod: function (arg0, success, error) {
        exec(success, error, 'GemiusPlugin', 'coolMethod', [arg0]);
    }
};

exports = GemiusPlugin;

window.gemius = GemiusPlugin;