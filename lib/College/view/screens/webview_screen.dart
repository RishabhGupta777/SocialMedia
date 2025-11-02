import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  double _progress = 0; // Track loading progress

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
          NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
                setState(() {
                  _progress = progress / 100; // Convert percentage into 0 to 1 -->_progress is used as the value for LinearProgressIndicator,
                  // which expects a value between 0.0 (empty) and 1.0 (full).
                });
              },
            onPageFinished: (String url) {  //The initial URL (widget.url) is just what was requested, but the final loaded URL might change.so String url provides the actual URL of the page that has finished loading.
              setState(() {
                _progress = 0; // Hide progress bar when loading is complete-->Resets _progress to 0 when the page finishes loading.
              });
              },),)
      ..loadRequest(Uri.parse(widget.url));
  }

// 1. New method to handle the device's back button press
  Future<bool> _onWillPop() async {
    // Check if the WebView has any pages to go back to in its history
    if (await _controller.canGoBack()) {
      // If it can go back, tell the WebView to navigate back and
      // return FALSE to prevent the Flutter Navigator from popping the screen.
      _controller.goBack();
      return false;
    }
    // If it cannot go back (no more history), return TRUE, allowing
    // the Flutter Navigator to pop the screen and return to the main app.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text("DCRUST")),
        body: Stack(
      children: [
      WebViewWidget(controller: _controller),
      if (_progress < 1.0) // Show progress bar while loading
      LinearProgressIndicator(value: _progress),
      ],)
      ),
    );
  }
}
