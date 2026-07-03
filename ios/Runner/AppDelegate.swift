import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      NotificationCenter.default.addObserver(self, selector: #selector(preventScreenRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
      
      // Check if screen is being captured by the start of the app
      let isCaptured = UIScreen.main.isCaptured
      print("isCaptured: \(isCaptured)")
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
          let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/screenRecording",
                                                    binaryMessenger: controller.binaryMessenger)
          batteryChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
              batteryChannel.setMethodCallHandler({
                [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
                // This method is invoked on the UI thread.
                guard call.method == "isScreenCaptured" else {
                  result(FlutterMethodNotImplemented)
                  return
                }
                self?.sendScreenCaptureState(result: result)
              })
          })
      
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    @objc func preventScreenRecording() {
        let isCaptured = UIScreen.main.isCaptured
        if isCaptured {
            print("isCaptured: \(isCaptured)")
        }
        else {
            print("isCaptured: \(isCaptured)")
    
        }
    }
    
    private func sendScreenCaptureState(result: FlutterResult) {
        let isCaptured = UIScreen.main.isCaptured
        result(Bool(isCaptured))
    }
    

//     override func applicationWillResignActive(
//       _ application: UIApplication
//     ) {
//       self.window.isHidden = true;
//     }
//     override func applicationDidBecomeActive(
//       _ application: UIApplication
//     ) {
//       self.window.isHidden = false;
//     }
}
