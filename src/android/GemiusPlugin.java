package com.devapps.gemius.GemiusPlugin;

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
import java.util.Iterator;
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
        if (args == null || args.length() == 0) {
            callbackContext.error("{\"status\":\"error\", \"message\": \"Please provide the event type.\"}");
        }

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    int eventTypePassed = args.getInt(0);
                    BaseEvent.EventType eventType = getEventType(eventTypePassed);

                    AudienceEvent event = new AudienceEvent(mContext);
                    event.setScriptIdentifier(scriptIdentifier);
                    event.setEventType(eventType);

                    if (args.get(1) != null) {
                        JSONObject extraParams = args.getJSONObject(1);
                        Iterator<String> keys = extraParams.keys();
                        while (keys.hasNext()) {
                            String key = keys.next();
                            event.addExtraParameter(key, extraParams.getString(key));
                        }
                    }

                    event.sendEvent();
                    callbackContext.success();
                } catch (Exception e) {
                    callbackContext.error("{\"status\":\"error\", \"message\": \"" + e.getMessage() + "\"}");
                }
            }
        });
    }

    private int getAppResource(String name, String type) {
        return mCurrentActivity.getResources().getIdentifier(name, type, cordova.getActivity().getPackageName());
    }

    private BaseEvent.EventType getEventType(int eventTypePassed) throws Exception {
        if (eventTypePassed == 0) {
            return BaseEvent.EventType.FULL_PAGEVIEW;
        } else if (eventTypePassed == 1) {
            return BaseEvent.EventType.PARTIAL_PAGEVIEW;
        } else if (eventTypePassed == 2) {
            return BaseEvent.EventType.SONAR;
        } else if (eventTypePassed == 3) {
            return BaseEvent.EventType.ACTION;
        } else if (eventTypePassed == 4) {
            return BaseEvent.EventType.STREAM;
        } else if (eventTypePassed == 5) {
            return BaseEvent.EventType.DATA;
        }

        throw new Exception("Invalid Event Type");
    }
}
