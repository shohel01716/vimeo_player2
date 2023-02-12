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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: WebUri(_videoPage(widget.id))),
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            mediaPlaybackRequiresUserGesture: false,
          ),
          android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
          ),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
          )
      ),
      onWebViewCreated: (controller) async {
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
      onConsoleMessage: (controller, consoleMessage) {
        print(consoleMessage);
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
                   background-color: lightgray;
                   margin: 0px;
                   }
                </style>
                <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
                <meta http-equiv="Content-Security-Policy" 
                content="default-src * gap:; script-src * 'unsafe-inline' 'unsafe-eval'; connect-src *; 
                img-src * data: blob: android-webview-video-poster:; style-src * 'unsafe-inline';">
             </head>
             <body>
             <div style="padding:56.25% 0 0 0;position:relative;"><iframe src="$videoId?autoplay=1" frameborder="0" allow="autoplay fullscreen picture-in-picture" allowfullscreen style="position:absolute;top:0;left:0;width:100%;height:100%;"></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>
                
             </body>
            </html>
            ''';
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(html));
    return 'data:text/html;base64,$contentBase64';
  }
}
