# cordova-plugin-gemius

## Installation

To install the plugin into a Cordova project, execute the below command:

```
cordova plugin add https://github.com/devapps-systems/cordova-plugin-gemius --variable GEMIUS_APP_NAME=value --variable GEMIUS_APP_VERSION=value --variable GEMIUS_HITCOLLECTOR_HOST=value --variable GEMIUS_SCRIPT_IDENTIFIER=value
```

Additional variables which can be used in the above command:

| Variable | Default Value |
| ------ | ------ |
| GEMIUS_LOGGING_ENABLED | false |
| GEMIUS_IDFA_ENABLED | true |
| GEMIUS_BUFFERED_MODE | true |
| GEMIUS_POWER_SAVING_MODE | true |
| ANDROID_PLAY_SERVICES_CORE_VERSION | 17.3.0 |
| ANDROID_PLAY_SERVICES_ADS_VERSION | 19.1.0 |
| GSON_VERSION | 2.8.5 |


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

#### Paramter details
1. **successCallback:** The success callback function
2. **errorCallback:** The failure callback function
3. **eventType:** The Gemius Event type. The possible values are: 
- `gemius.eventType.FULL_PAGEVIEW` 
- `gemius.eventType.PARTIAL_PAGEVIEW`
- `gemius.eventType.SONAR`
- `gemius.eventType.ACTION` 
- `gemius.eventType.STREAM`
- `gemius.eventType.DATA`
4. **extraParams:** The additional parameters for the event to log, can be null
