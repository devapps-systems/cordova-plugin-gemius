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
    }

    @objc private func didFinishLaunchingWithOptions(notification: NSNotification){
        initGemiusSDK()
    }
    
    @objc private func didEnterBackground(notification: NSNotification){
        GEMAudienceEvent.flushBuffer(withForce: true)
    }
    
    func initGemiusSDK() {
        let gemiusConfig = Bundle.main.object(forInfoDictionaryKey: "GemiusPluginConfig") as! [String: String]
        let appName = gemiusConfig["gemius_app_name"]
        let appVersion = gemiusConfig["gemius_app_version"]
        let hitCollectorHost = gemiusConfig["gemius_hitcollector_host"]
        let scriptIdentifier = gemiusConfig["gemius_script_identifier"]
        
        let loggingEnabled = Bool(gemiusConfig["gemius_logging_enabled"]!)
        let idfaEnabled = Bool(gemiusConfig["gemius_idfa_enabled"]!)
        let bufferedMode = Bool(gemiusConfig["gemius_buffered_mode"]!)
        let powerSavingMode = Bool(gemiusConfig["gemius_power_saving_mode"]!)
     
        GEMConfig.sharedInstance()?.setAppInfo(appName!, version: appVersion!)
        GEMConfig.sharedInstance().loggingEnabled = loggingEnabled!
        GEMConfig.sharedInstance().idfaCollectionEnabled = idfaEnabled!
        
        GEMAudienceConfig.sharedInstance().hitcollectorHost = hitCollectorHost!
        GEMAudienceConfig.sharedInstance().scriptIdentifier = scriptIdentifier!
        GEMAudienceConfig.sharedInstance().bufferedMode = bufferedMode!
        GEMAudienceConfig.sharedInstance().powerSavingMode = powerSavingMode!
    }
    
    @objc(logEvent:)
    func logEvent(command: CDVInvokedUrlCommand) {
        do {
            if(command.arguments == nil || command.arguments.count == 0) {
                throw GemiusPluginError("Please provide the event type.")
            }
            
            let eventTypePassed = command.arguments[0] as! String
            let eventType = GEMEventType.init(rawValue: Int(eventTypePassed)!)!

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
