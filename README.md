# uikitview_with_backdrop_filter

A Flutter project demonstrating UIKitView with backdrop filter effects.

the whole project created by flutter 3.29.0. 

## Screenshots

| pic1 | pic2 | pic3 |
|:---:|:---:|:---:|
| <img src="git/IMG_4758.PNG" width="250"> | <img src="git/IMG_4759.PNG" width="250"> | <img src="git/IMG_4761.PNG" width="250"> |

## Environment

- Flutter 3.29.0

## Main dart code
```dart
class _MyHomePageState extends State<MyHomePage> {
  bool _isNativeButtonVisible = false;
  static const platform = MethodChannel('native_button_channel');

  Future<void> _toggleNativeButton() async {
    try {
      await platform.invokeMethod(
          _isNativeButtonVisible ? 'hideNativeButton' : 'showNativeButton');
      setState(() {
        _isNativeButtonVisible = !_isNativeButtonVisible;
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to toggle native button: ${e.message}");
    }
  }

  Widget _buildNativeView() {
    if (!_isNativeButtonVisible) {
      return const SizedBox.shrink();
    }

    return const SizedBox(
      height: 100,
      width: 100,
      child: UiKitView(
        viewType: 'native_button_view',
        creationParams: <String, dynamic>{},
        creationParamsCodec: StandardMessageCodec(),
        hitTestBehavior: PlatformViewHitTestBehavior.transparent,
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
      ),
    );
  }

  void _showBackdropDialog() {
    /// Display the native button when the dialog is shown.
    if (!_isNativeButtonVisible) {
      _toggleNativeButton();
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(120),
              ),
              color: Colors.red.withOpacity(0.3),
            ),
            clipBehavior: Clip.hardEdge,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Dialog with Backdrop',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _toggleNativeButton();
                      },
                      child: Text(_isNativeButtonVisible
                          ? 'Hide Native Button'
                          : 'Show Native Button'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(backgroundColor: Colors.black, title: Text(widget.title)),
      body: Stack(
        children: [
          ListView.builder(itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: _showBackdropDialog,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
              ),
              child: const Text(
                  'ShowDialogShowDialogShowDialogShowDialogShowDialog'),
            );
          }),
          Positioned(bottom: 420, left: 0, child: _buildNativeView()),
        ],
      ),
    );
  }
}
```

## Main ios-swift code
```swift
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
```

## Features

- Dark theme UI
- Native iOS button integration using UIKitView
- Backdrop filter effect with blur
- Modal bottom sheet with transparency

# Flutter doctor
```
q1@q1deMacBook-Pro  ~  flutter doctor -v
[✓] Flutter (Channel stable, 3.29.0, on macOS 14.6 23G5061b darwin-x64, locale
    en-CN) [876ms]
    • Flutter version 3.29.0 on channel stable at /Users/q1/fvm/versions/3.29.0
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 35c388afb5 (5 weeks ago), 2025-02-10 12:48:41 -0800
    • Engine revision f73bfc4522
    • Dart version 3.7.0
    • DevTools version 2.42.2
    • Pub download mirror https://pub-web.flutter-io.cn
    • Flutter download mirror https://storage.flutter-io.cn

[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
    [4.0s]
    • Android SDK at /Users/q1/android-sdk-macosx
    • Platform android-35, build-tools 34.0.0
    • Java binary at:
      /Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home/bin/java
      This JDK is specified in your Flutter configuration.
      To change the current JDK, run: `flutter config --jdk-dir="path/to/jdk"`.
    • Java version Java(TM) SE Runtime Environment (build 17.0.10+11-LTS-240)
    • All Android licenses accepted.

[!] Xcode - develop for iOS and macOS (Xcode 16.2) [2.3s]
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 16C5032a
    ! CocoaPods 1.15.2 out of date (1.16.2 is recommended).
        CocoaPods is a package manager for iOS or macOS platform code.
        Without CocoaPods, plugins will not work on iOS or macOS.
        For more info, see https://flutter.dev/to/platform-plugins
      To update CocoaPods, see
      https://guides.cocoapods.org/using/getting-started.html#updating-cocoapods

[✓] Chrome - develop for the web [38ms]
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2024.2) [36ms]
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 21.0.4+-12422083-b607.1)

[✓] Connected device (3 available) [8.1s]
    • qqqqqqq1iPhone (mobile) • 00008030-000171CE1168802E • ios            • iOS
      18.2 22C152
    • macOS (desktop)         • macos                     • darwin-x64     •
      macOS 14.6 23G5061b darwin-x64
    • Chrome (web)            • chrome                    • web-javascript •
      Google Chrome 134.0.6998.89

[✓] Network resources [788ms]
    • All expected network resources are available.

! Doctor found issues in 1 category.
```