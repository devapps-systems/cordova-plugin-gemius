# cordova-plugin-gemius

## Installation

To install the plugin into a Cordova project, execute the below command:

```
cordova plugin add https://github.com/devapps-systems/cordova-plugin-gemius --variable GEMIUS_APP_NAME=value --variable GEMIUS_APP_VERSION=value --variable GEMIUS_HITCOLLECTOR_HOST=value --variable GEMIUS_SCRIPT_IDENTIFIER=value
```

Once the plugin has been installed, execute the below commands to prepare the Android & iOS projects:

```
cordova build ios
cordova build android
```

## Usage

The Gemius Corova Plugin exposes the `logEvent` method in the `gemius` window object. A sample usage of the function call is as below:

```
var successCallback = function(response) {
    alert("Success")
};

var errorCallback = function(error) {
    alert("Failure");
};

gemius.logEvent(successCallback, errorCallback, gemius.eventType.FULL_PAGEVIEW, { "ct": "nw/fineco"});
```

Paramter details:
1. successCallback: The success callback function
2. errorCallback: The failure callback function
3. eventType: The Gemius Event type. The possible values are: 
- `gemius.eventType.FULL_PAGEVIEW` 
- `gemius.eventType.PARTIAL_PAGEVIEW`
- `gemius.eventType.SONAR`
- `gemius.eventType.ACTION` 
- `gemius.eventType.STREAM`
- `gemius.eventType.DATA`
4. extraParams: The additional parameters for the event to log, can be null