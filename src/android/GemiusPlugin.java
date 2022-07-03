package com.devapps.gemius;

import android.app.Activity;
import android.content.Context;

import com.gemius.sdk.Config;
import com.gemius.sdk.audience.AudienceConfig;
import com.gemius.sdk.audience.AudienceEvent;
import com.gemius.sdk.audience.BaseEvent;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class GemiusPlugin extends CordovaPlugin {

    private Context mContext;
    private Activity mCurrentActivity;
    private String scriptIdentifier;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        mCurrentActivity = this.cordova.getActivity();
        mContext = this.cordova.getActivity().getApplicationContext();

        initializeGemiusSDK();
    }


    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("logEvent")) {
            this.logEvent(args, callbackContext);
            return true;
        }
        return false;
    }

    private void initializeGemiusSDK() {
        String appName = mCurrentActivity.getResources().getString(getAppResource("gemius_app_name", "string"));
        String appVersion = mCurrentActivity.getResources().getString(getAppResource("gemius_app_version", "string"));
        String loggingEnabled = mCurrentActivity.getResources().getString(getAppResource("gemius_logging_enabled", "string"));

        Config.setAppInfo(appName, appVersion);
        Config.setLoggingEnabled(Boolean.parseBoolean(loggingEnabled));

        // String idfaEnabled = mCurrentActivity.getResources().getString(getAppResource("gemius_idfa_enabled", "string"));
        String hitCollectorHost = mCurrentActivity.getResources().getString(getAppResource("gemius_hitcollector_host", "string"));
        String scriptIdentifier = mCurrentActivity.getResources().getString(getAppResource("gemius_script_identifier", "string"));
        String bufferedMode = mCurrentActivity.getResources().getString(getAppResource("gemius_buffered_mode", "string"));
        String powerSavingMode = mCurrentActivity.getResources().getString(getAppResource("gemius_power_saving_mode", "string"));

        AudienceConfig.getSingleton().setHitCollectorHost(hitCollectorHost);
        AudienceConfig.getSingleton().setScriptIdentifier(scriptIdentifier);
        AudienceConfig.getSingleton().setBufferedMode(Boolean.parseBoolean(bufferedMode));
        AudienceConfig.getSingleton().setPowerSavingMode(Boolean.parseBoolean(powerSavingMode));

        this.scriptIdentifier = scriptIdentifier;
    }

    private void logEvent(JSONArray args, CallbackContext callbackContext) {
        if(args == null || args.length() == 0) {
            callbackContext.error("{\"status\":\"error\", \"message\": \"Please provide the event type.\"}");
        }

        try {
            String eventTypePassed = args.get(0).toString();
            HashMap<String, String> extraParams = null;
            BaseEvent.EventType eventType = BaseEvent.EventType.valueOf(eventTypePassed);

            if(args.get(1) != null) {
                extraParams = (HashMap<String, String>) args.get(1);
            }

            AudienceEvent event = new AudienceEvent(mContext);
            event.setScriptIdentifier(this.scriptIdentifier);
            event.setEventType(eventType);

            if(extraParams != null) {
                for (Map.Entry<String, String> entry : extraParams.entrySet()) {
                    String key = entry.getKey();
                    String value = entry.getValue();
                    event.addExtraParameter(key, value);
                }
            }

            event.sendEvent();
        } catch (JSONException e) {
            callbackContext.error("{\"status\":\"error\", \"message\": \"" + e.getMessage() +"\"}");
        }
    }

    private int getAppResource(String name, String type) {
        return mCurrentActivity.getResources().getIdentifier(name, type, cordova.getActivity().getPackageName());
    }
}
