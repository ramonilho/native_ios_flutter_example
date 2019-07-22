import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SecondPage extends StatefulWidget {
  static const basicChannel =
      const BasicMessageChannel('io.flutter.count', StringCodec());

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  void dismissPage() {
    setState(() {
      SecondPage.basicChannel.send("");
      SystemNavigator.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => dismissPage(),
          )
        ],
      ),
    );
  }
}
