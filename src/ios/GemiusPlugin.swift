import UIKit
import Foundation
import GemiusSDK

struct GemiusPluginError: Error, LocalizedError {
    let errorDescription: String?

    init(_ description: String) {
        errorDescription = description
    }
}

@objc(GemiusPlugin) class GemiusPlugin : CDVPlugin {
    var _callbackId: String?

    @objc(pluginInitialize)
    override func pluginInitialize() {
        super.pluginInitialize();
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didFinishLaunchingWithOptions),
            name: UIApplication.didFinishLaunchingNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        
        initGemiusSDK()
    }

    @objc private func didFinishLaunchingWithOptions(notification: NSNotification){
        initGemiusSDK()
    }
    
    @objc private func didEnterBackground(notification: NSNotification){
        GEMAudienceEvent.flushBuffer(withForce: true)
    }
    
    func initGemiusSDK() {
        let gemiusConfig = Bundle.main.object(forInfoDictionaryKey: "GemiusPluginConfig") as! [String: String]
        let appName = gemiusConfig["GEMIUS_APP_NAME"]
        let appVersion = gemiusConfig["GEMIUS_APP_VERSION"]
        let hitCollectorHost = gemiusConfig["GEMIUS_HITCOLLECTOR_HOST"]
        let scriptIdentifier = gemiusConfig["GEMIUS_SCRIPT_IDENTIFIER"]
        
        let loggingEnabled = (gemiusConfig["GEMIUS_LOGGING_ENABLED"]?.lowercased() == "true") ? true : false
        let idfaEnabled = (gemiusConfig["GEMIUS_IDFA_ENABLED"] == "true") ? true : false
        let bufferedMode = (gemiusConfig["GEMIUS_BUFFERED_MODE"] == "true") ? true : false
        let powerSavingMode = (gemiusConfig["GEMIUS_POWER_SAVING_MODE"] == "true") ? true : false
     
        GEMConfig.sharedInstance()?.setAppInfo(appName!, version: appVersion!)
        GEMConfig.sharedInstance().loggingEnabled = loggingEnabled
        GEMConfig.sharedInstance().idfaCollectionEnabled = idfaEnabled
        
        GEMAudienceConfig.sharedInstance().hitcollectorHost = hitCollectorHost!
        GEMAudienceConfig.sharedInstance().scriptIdentifier = scriptIdentifier!
        GEMAudienceConfig.sharedInstance().bufferedMode = bufferedMode
        GEMAudienceConfig.sharedInstance().powerSavingMode = powerSavingMode
    }
    
    @objc(logEvent:)
    func logEvent(command: CDVInvokedUrlCommand) {
        do {
            if(command.arguments == nil || command.arguments.count == 0) {
                throw GemiusPluginError("Please provide the event type.")
            }
            
            let eventTypePassed = command.arguments[0] as! Int
            let eventType = GEMEventType.init(rawValue: eventTypePassed)!

            let event = GEMAudienceEvent()
            event.eventType = eventType
            
            let extraParams = command.arguments[1] as? Dictionary<String, String>
            if(extraParams != nil) {
                event.setExtraParameters(extraParams)
            }
            
            event.send()
            
            let pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK
            )
            
            self.commandDelegate!.send(
                pluginResult,
                callbackId: command.callbackId
            )
        } catch let error {
            let pluginResult = CDVPluginResult(
                status: CDVCommandStatus_ERROR,
                messageAs: error.localizedDescription
            )

            self.commandDelegate!.send(
                pluginResult,
                callbackId: command.callbackId
            )
        }
    }
}
