import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/earthquake.dart';
import 'package:myapp/playgroud.dart';

import 'chat.dart';
import 'pm25.dart';

void main() => runApp(new MyApp());

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
      title: 'Flutter Demo App',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new MyHomePage(title: 'Home Page'),
//      routes: <String, WidgetBuilder>{
//        '/Chat': (BuildContext context) => new ChatPage(title: 'Chat'),
//        '/PM25': (BuildContext context) => new PM25(),
//        '/Play': (BuildContext context) => new PlayGroud(title: 'Just for Fun'),
////        '/Play': (BuildContext context) => new EarthQuake(title: 'Earth'),
//      },
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController controller;
  @override
  void dispose() {
//    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
  }

//  Widget _buildUI() {
//    return new IconTheme(
//      data: new IconThemeData(color: Theme.of(context).accentColor),
//      child: new Container(
//          margin: const EdgeInsets.symmetric(horizontal: 8.0),
//          // Center is a layout widget. It takes a single child and positions it
//          // in the middle of the parent.
//          child: Column(
//            // Column is also layout widget. It takes a list of children and
//            // arranges them vertically. By default, it sizes itself to fit its
//            // children horizontally, and tries to be as tall as its parent.
//            //
//            // Invoke "debug paint" (press "p" in the console where you ran
//            // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
//            // window in IntelliJ) to see the wireframe for each widget.
//            //
//            // Column has various properties to control how it sizes itself and
//            // how it positions its children. Here we use mainAxisAlignment to
//            // center the children vertically; the main axis here is the vertical
//            // axis because Columns are vertical (the cross axis would be
//            // horizontal).
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Text(
//                'You have pushed the button this many times:',
//              ),
//              Text(
//                '$_counter',
//                style: Theme.of(context).textTheme.display1,
//              ),
//            ],
//          )),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          backgroundColor: const Color(0xFF42A5F5),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
//          bottom: TabBar(
//            tabs: <Tab>[
//              new Tab(icon: Icon(Icons.home)),
//              new Tab(
//                icon: new Icon(Icons.person),
//              ),
//              new Tab(
//                icon: new Icon(Icons.email),
//              ),
//            ],
//            controller: controller,
//          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ChatPage(title: 'Chat'),
            PM25(),
            EarthQuake(title: 'EarthQuake'),
//            PlayGroud(title: 'Just for Fun'),
          ],
          controller: controller,
        ),
        /*
        Column(children: <Widget>[
          Container(
              child: _buildUI(),
              decoration: Theme.of(context).platform == TargetPlatform.iOS
                  ? BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[200]),
                      ),
                    )
                  : null),
          ListTile(
            title: Text("Chat Msg"),
            subtitle: Text("Chat"),
            onTap: () {
              Navigator.pushNamed(context, "/Chat");
            },
          ),
          ListTile(
            title: Text("PM25"),
            subtitle: Text("PM25"),
            onTap: () {
              Navigator.pushNamed(context, "/PM25");
            },
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/Play");
            },
            child: Text("Tap me"),
          ),
        ]),
        */
        floatingActionButton: FloatingActionButton(
          onPressed: () => {},
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
        drawer: Drawer(
          key: Key("mykey"),
          child: ListTile(
            leading: Icon(Icons.mail),
            title: Text('Change history'),
            onTap: () {
              Navigator.pop(context); // close the drawer
            },
          ),
        ),
        bottomNavigationBar: Material(
          child: TabBar(
            tabs: <Tab>[
              new Tab(icon: new Icon(Icons.home)),
              new Tab(
                icon: new Icon(Icons.person),
              ),
              new Tab(
                icon: new Icon(Icons.email),
              ),
            ],
            controller: controller,
          ),
          color: Colors.pink,
        ));
  }
}
