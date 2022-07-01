import UIKit
import Foundation
import GemiusSDK

enum Season {
  case FULL_PAGEVIEW, PARTIAL_PAGEVIEW, SONAR, ACTION, STREAM, DATA
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

    @objc(coolMethod:)
    func coolMethod(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR
        )

        let msg = command.arguments[0] as? String ?? ""
        if msg.count > 0 {
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: msg
            )
        }

        self.commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }
    
    @objc(logEvent:)
    func logEvent(command: CDVInvokedUrlCommand) {
        let firstString = command.arguments[0] as? String;
        
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR
        )

        let msg = command.arguments[0] as? String ?? ""
        if msg.count > 0 {
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: msg
            )
        }

        self.commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }
}
