document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady() {
    console.log('Running cordova-' + cordova.platformId + '@' + cordova.version);
    document.getElementById('deviceready').classList.add('ready');

    var logEventButton = document.getElementById("logEvent");
    logEventButton.addEventListener("click", logEvent);
}

function logEvent() {
    var successCallback = function(response) {
        alert("Success")
    };

    var errorCallback = function(error) {
        alert("Failure");
    };

    gemius.logEvent(successCallback, errorCallback, gemius.eventType.FULL_PAGEVIEW, { "ct": "nw/fineco"});
}