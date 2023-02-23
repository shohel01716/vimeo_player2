import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:vimeo_player_flutter/web_uri.dart';

///vimeo player for Flutter apps
///Flutter plugin based on the [webview_flutter] plugin
///[videoId] is the only required field to use this plugin

class VimeoPlayer extends StatelessWidget {
  final String videoId;
  VimeoPlayer({
    Key? key,
    required this.videoId,
  }) : super(key: key);

  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return InAppWebViewExampleScreen(id: videoId);
  }
}

class InAppWebViewExampleScreen extends StatefulWidget {
  final String id;

  const InAppWebViewExampleScreen({Key? key, required this.id})
      : super(key: key);

  @override
  _InAppWebViewExampleScreenState createState() =>
      new _InAppWebViewExampleScreenState();
}

class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    webViewController!.clearCache();
    webViewController!.android.clearHistory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: WebUri(_videoPage(widget.id))),
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            //javaScriptCanOpenWindowsAutomatically: true,
            //javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            //clearCache: true
          ),
          android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
            //clearSessionCache: true
          ),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
          )
      ),
      onWebViewCreated: (controller) async {
       // webViewController = controller;

        debugPrint(await controller.getUrl().toString());
      },
      onLoadStart: (controller, url) async {
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url!;

        if (!["http", "https", "file", "chrome", "data", "javascript", "about"]
        .contains(uri.scheme)) {
          /*if (await canLaunchUrl(uri)) {
                        // Launch the App
                        await launchUrl(
                          uri,
                        );
                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }*/
        }

        return NavigationActionPolicy.ALLOW;
      },
      onLoadStop: (controller, url) async {
      },
      onProgressChanged: (controller, progress) {
      },
      onUpdateVisitedHistory: (controller, url, isReload) {
      },
      onConsoleMessage: (controller, consoleMessage) async {
        print("consoleMessage:: "+consoleMessage.toString());
        if(consoleMessage.toString().contains("fullscreen")){

          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
        }
      },
      onEnterFullscreen: (controller) async {
        debugPrint(">>>>>>>>>>>>>>>>>>>>>>onEnterFullscreen>>>>>>>>>>>>>>>>>");
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      },
      onExitFullscreen: (controller) async {
        debugPrint(">>>>>>>>>>>>>>>>>>>>>>onExitFullscreen>>>>>>>>>>>>>>>>>");
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      },
    );
  }

  String _videoPage(String videoId) {
    final html = '''
            <html>
              <head>
                <style>
                  body {
                   background-color: black;
                   margin: 0px;
                   }
                </style>
                <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
                <meta http-equiv="Content-Security-Policy" 
                content="default-src * gap:; script-src * 'unsafe-inline' 'unsafe-eval'; connect-src *; 
                img-src * data: blob: android-webview-video-poster:; style-src * 'unsafe-inline';">
             </head>
             <body>
             <iframe src="$videoId?autoplay=true&muted=false&loop=true&autopause=false&controls=true&pip=true&playsinline=true" width="100%" height="100%" frameborder=“0”  allowfullscreen  allow="autoplay fullscreen picture-in-picture"></iframe></body>
            </html>
            ''';
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(html));
    return 'data:text/html;base64,$contentBase64';
  }
}
