import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customized Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Customized Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String videoId = 'https://player.vimeo.com/video/796729561';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      /*appBar: AppBar(
        title: Text(widget.title),
      ),*/
      child: VimeoPlayer(
       videoId: videoId,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
