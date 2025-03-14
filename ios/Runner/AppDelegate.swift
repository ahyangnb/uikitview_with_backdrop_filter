import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var nativeButton: UIButton?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let buttonChannel = FlutterMethodChannel(
      name: "native_button_channel",
      binaryMessenger: controller.binaryMessenger)
    
    // Register native view factory
    let factory = NativeButtonViewFactory()
    registrar(forPlugin: "native_button_view")?.register(
      factory,
      withId: "native_button_view"
    )
    
    buttonChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "showNativeButton":
        self?.showNativeButton()
        result(nil)
      case "hideNativeButton":
        self?.hideNativeButton()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func showNativeButton() {
    DispatchQueue.main.async { [weak self] in
      self?.nativeButton?.isHidden = false
    }
  }
  
  private func hideNativeButton() {
    DispatchQueue.main.async { [weak self] in
      self?.nativeButton?.isHidden = true
    }
  }
}

class NativeButtonViewFactory: NSObject, FlutterPlatformViewFactory {
  override init() {
    super.init()
  }
  
  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    return NativeButtonView(frame: frame, viewId: viewId, args: args)
  }
  
  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

class NativeButtonView: NSObject, FlutterPlatformView {
  private let button: UIButton
  
  init(frame: CGRect, viewId: Int64, args: Any?) {
    button = UIButton(frame: frame)
    super.init()
    
    button.backgroundColor = .systemBlue
    button.setTitle("Native iOS Button", for: .normal)
    button.layer.cornerRadius = 10
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }
  
  func view() -> UIView {
    return button
  }
  
  @objc private func buttonTapped() {
    print("Native button tapped")
  }
}
