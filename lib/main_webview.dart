import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isNativeButtonVisible = false;
  static const platform = MethodChannel('native_button_channel');

  WebViewController? controller;

  Future<void> _toggleNativeButton() async {
    try {
      initWebView();
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

    return SizedBox(
      height: 100,
      width: 100,
      child: controller == null
          ? Text('loading')
          : WebViewWidget(controller: controller!),
      // child: UiKitView(
      //   viewType: 'native_button_view',
      //   creationParams: <String, dynamic>{},
      //   creationParamsCodec: StandardMessageCodec(),
      //   hitTestBehavior: PlatformViewHitTestBehavior.transparent,
      //   gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
      // ),
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

  void initWebView() {
    controller ??= WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));
    setState(() {});
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
