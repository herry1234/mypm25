import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';

void main() => runApp(new MyApp());
const String _name = "Herry Wang";
final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new MyHomePage(title: 'Flutter myapp Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:  CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child:  Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child:  Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Container(
              margin: const EdgeInsets.only(right: 16.0),
              child:  CircleAvatar(child: Text(_name[0])),
            ),
             Expanded(
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   Text(_name, style: Theme.of(context).textTheme.subhead),
                   Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child:  Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  int _pm25 = 0;
  bool _isComposing = false;
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  _updatePM25() async {
    var httpClient = new HttpClient();
    var uri = new Uri.http(
        'api.waqi.info', '/feed/@728/', {'token': 'c2e449bbb5e4dffa06e8b5f28a7813e7b4f5b2e6'});
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(UTF8.decoder).join();
    var data = JSON.decode(responseBody);
    print(data.toString());
    setState(() {
      _counter = 0;
      _pm25 = data['data']['iaqi']['pm25']['v'];
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  Widget _buildUI() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: new Column(
            // Column is also layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug paint" (press "p" in the console where you ran
            // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
            // window in IntelliJ) to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Flexible(
                    child: new TextField(
                      controller: _textController,
                      onSubmitted: _handleSubmitted,
                      decoration: new InputDecoration.collapsed(
                          hintText: "Send a message"),
                      onChanged: (String text) {
                        setState(() {
                          _isComposing = text.length > 0;
                        });
                      },
                    ),
                  ),
                  new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 4.0),
                    child: Theme.of(context).platform == TargetPlatform.iOS
                        ? CupertinoButton(
                            child: Text("Send"),
                            onPressed: _isComposing
                                ? () => _handleSubmitted(_textController.text)
                                : null,
                          )
                        : IconButton(
                            color: Colors.pink,
                            icon: Icon(Icons.mail),
                            onPressed: _isComposing
                                ? () => _handleSubmitted(_textController.text)
                                : null,
                          ),
                  ),
                ],
              ),
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.display1,
              ),
              Text(
                'PM25:',
              ),
              Text(
                '$_pm25',
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
//        title: new Text("appbar title"),
        backgroundColor: const Color(0xFF42A5F5),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              new Container(
                child: _buildUI(),
                decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor),
              )
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border: new Border(
                    top: new BorderSide(color: Colors.grey[200]), //new
                  ),
                )
              : null),
      floatingActionButton: new FloatingActionButton(
//        onPressed: _incrementCounter,
        onPressed: _updatePM25,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      drawer: new Drawer(
        key: new Key("mykey"),
        child: new ListTile(
          leading: new Icon(Icons.mail),
          title: new Text('Change history'),
          onTap: () {
            // change app state...
            setState(() {
              _counter = 0;
            });

            Navigator.pop(context); // close the drawer
          },
        ),
      ),
    );
  }
}
