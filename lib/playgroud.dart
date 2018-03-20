import 'dart:async';

import 'package:flutter/material.dart';

class PlayGroud extends StatefulWidget {
  PlayGroud({Key key, this.title}) : super(key: key);
  final title;
  @override
  PlayGroudState createState() => new PlayGroudState();
}

class PlayGroudState extends State<PlayGroud> {
  bool showtext = true;
  bool toggleState = true;
  Timer t2;
  void toggleBlinkState() {
    setState(() {
      toggleState = !toggleState;
    });
    var twenty = const Duration(milliseconds: 1000);
    if (toggleState == false) {
      t2 = new Timer.periodic(twenty, (Timer t) {
        toggleShowText();
      });
    } else {
      t2.cancel();
    }
  }

  void toggleShowText() {
    setState(() {
      showtext = !showtext;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: const Color(0xFF42A5F5),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Container(
            child: Column(children: <Widget>[
          (showtext
              ? (new Text('This execution will be done before you can blink.'))
              : (new Container())),
          Padding(
              padding: new EdgeInsets.only(top: 70.0),
              child: new RaisedButton(
                  onPressed: toggleBlinkState,
                  child:
                      (toggleState ? Text("Blink") : Text("Stop Blinking")))),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              width: 72.0,
              child: new Icon(Icons.message, color: Colors.pink)),
        ])),
      ),
      onTap: () {
        print('Tapped');
      },
      onLongPress: () {
        print('Long Pressed');
      },
      onVerticalDragEnd: (DragEndDetails value) {
        print('Swiped Vertically');
      },
      onHorizontalDragEnd: (DragEndDetails value) {
        print('Swiped Horizontally');
      },
    );
  }
}
