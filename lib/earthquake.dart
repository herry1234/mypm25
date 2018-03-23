import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'dart:io';
import 'dart:convert';

const double _kAppBarHeight = 128.0;
const double _kFabHalfSize = 28.0;
const double _kRecipePageMaxWidth = 500.0;

class EarthQuakeData {
  const EarthQuakeData({
    this.title,
    this.place,
    this.mag,
    this.time,
    this.loc1,
    this.loc2,
    this.loc3,
  });

  final String title;
  final String place;
  final num mag;
  final int time;
  final double loc1;
  final double loc2;
  final double loc3;
}

const List<EarthQuakeData> testData = const <EarthQuakeData>[
  const EarthQuakeData(
    title: "SJC 3.4 earthquake",
    place: "SJC",
    mag: 3.4,
    time: 1520954384750,
    loc1: 24.0,
    loc2: 25.0,
    loc3: 10.3,
  ),
  const EarthQuakeData(
    title: "MTV 3.4 earthquake",
    place: "MTV",
    mag: 2.4,
    time: 1520954384750,
    loc1: 24.0,
    loc2: 25.0,
    loc3: 10.3,
  ),
];

class EarthQuake extends StatefulWidget {
  const EarthQuake({this.title});
  final title;

  @override
  _EarthQuakeState createState() => new _EarthQuakeState();
}

class _EarthQuakeState extends State<EarthQuake> {
  List<EarthQuakeData> eqs = [];
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  //http://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=
  _fetchData() async {
    var httpClient = new HttpClient();
//    var now = new DateTime.now();
//    var formatter = new DateFormat('yyyy-MM-dd');
//    String formatted = formatter.format(now);

    DateTime today = new DateTime.now();
    String dateSlug =
        "${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    var uri = new Uri.https('earthquake.usgs.gov', '/fdsnws/event/1/query',
        {'format': 'geojson', 'starttime': dateSlug});
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(UTF8.decoder).join();
    var data = JSON.decode(responseBody);
    setState(() {
      List features = data['features'];
      features.forEach((item) {
        var d = item['properties'];
        var g = item['geometry']['coordinates'];
        EarthQuakeData eq = new EarthQuakeData(
          title: d['title'],
          place: d['place'],
          loc1: g[0] * 1.0,
          loc2: g[1] * 1.0,
          loc3: g[2] * 1.0,
          time: d['time'],
          mag: d['mag'],
        );
        eqs.add(eq);
      });
    });
  }

  Widget _buildAppBar(BuildContext context, double statusBarHeight) {
    return new SliverAppBar(
      pinned: true,
      expandedHeight: 10.0,
      actions: <Widget>[
        new IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () => {},
        ),
      ],
//      flexibleSpace: LayoutBuilder(
//        builder: (BuildContext context, BoxConstraints constraints) {
//          final Size size = constraints.biggest;
//          final double appBarHeight = size.height - statusBarHeight;
//          final double t = (appBarHeight - kToolbarHeight) / (_kAppBarHeight - kToolbarHeight);
//          final double extraPadding = new Tween<double>(begin: 10.0, end: 24.0).lerp(t);
//          return new Padding(
//            padding: new EdgeInsets.only(
//              top: statusBarHeight + 0.5 * extraPadding,
//              bottom: extraPadding,
//            ),
//            child: new Center(
//                child: Container(),
//            ),
//          );
//        },
//      ),
    );
  }

  void _showEQPage(BuildContext context, EarthQuakeData eq) {
    Navigator.push(
        context,
        new MaterialPageRoute<Null>(
          settings: const RouteSettings(name: '/eq'),
          builder: (BuildContext context) {
            return new EarthQuakeDetailPage(eq: eq);
          },
        ));
  }

  Widget _buildBody(BuildContext context, double statusBarHeight) {
    final EdgeInsets mediaPadding = MediaQuery.of(context).padding;
    final EdgeInsets padding = new EdgeInsets.only(
        top: 8.0,
        left: 8.0 + mediaPadding.left,
        right: 8.0 + mediaPadding.right,
        bottom: 8.0);
    return new SliverPadding(
      padding: padding,
      sliver:
//      new SliverGrid(
//        gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
//          maxCrossAxisExtent: 400.0,
//          mainAxisSpacing: 10.0,
//          crossAxisSpacing: 10.0,
//          childAspectRatio: 8.0,
//        ),
//        delegate: new SliverChildBuilderDelegate(
//              (BuildContext context, int index) {
//            return new Container(
//              alignment: Alignment.center,
//              color: Colors.teal[100 * (index % 9)],
//              child: new Text('grid item $index'),
//            );
//          },
//          childCount: 20,
//        ),
//      ),
//
          new SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: _kRecipePageMaxWidth,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 4.0,
        ),
        delegate: new SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final EarthQuakeData eq = eqs[index];
            return new EarthQuakeCard(
              eq: eq,
              onTap: () {
                _showEQPage(context, eq);
              },
            );
          },
          childCount: eqs.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return new Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildAppBar(context, statusBarHeight),
          _buildBody(context, statusBarHeight),
        ],
      ),
    );
  }
}

class EarthQuakeDetailPage extends StatefulWidget {
  const EarthQuakeDetailPage({Key key, this.eq}) : super(key: key);
  final EarthQuakeData eq;
  @override
  _EarthQuakeDetailState createState() => new _EarthQuakeDetailState();
}

class _EarthQuakeDetailState extends State<EarthQuakeDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  double _getAppBarHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.3;

  @override
  Widget build(BuildContext context) {
    var markers = <Marker>[
      new Marker(
        width: 80.0,
        height: 80.0,
        point: new LatLng(widget.eq.loc2, widget.eq.loc1),
        builder: (ctx) => new Container(
              child: new FlutterLogo(),
            ),
      ),
    ];

    return new Scaffold(
      appBar: new AppBar(title: new Text("Home")),
      body: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          children: [
            new Padding(
              padding: new EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: new Text("This is a map that is showing (51.5, -0.9)."),
            ),
            new Flexible(
              child: new FlutterMap(
                options: new MapOptions(
                  center: new LatLng(widget.eq.loc2, widget.eq.loc1),
                  zoom: 5.0,
                ),
                layers: [
                  new TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  new MarkerLayerOptions(markers: markers)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//  Widget build(BuildContext context) {
//    // The full page content with the recipe's image behind it. This
//    // adjusts based on the size of the screen. If the recipe sheet touches
//    // the edge of the screen, use a slightly different layout.
//    final double appBarHeight = _getAppBarHeight(context);
//    final Size screenSize = MediaQuery.of(context).size;
//    final bool fullWidth = screenSize.width < _kRecipePageMaxWidth;
//    return new Scaffold(
//      key: _scaffoldKey,
//      body: new Stack(
//        children: <Widget>[
//          Positioned(
//            top: 0.0,
//            left: 0.0,
//            right: 0.0,
//            height: appBarHeight + _kFabHalfSize,
//            child: Container(),
//          ),
//          CustomScrollView(
//            slivers: <Widget>[
//              new SliverToBoxAdapter(
//                  child: new Stack(
//                children: <Widget>[
//                  new Container(
//                    padding: const EdgeInsets.only(top: _kFabHalfSize),
//                    width: fullWidth ? null : _kRecipePageMaxWidth,
//                    child: new EarthQuakeSubSheet(eq: widget.eq),
//                  ),
//                ],
//              )),
//            ],
//          ),
//        ],
//      ),
//    );
//  }
}

class EarthQuakeCard extends StatelessWidget {
  const EarthQuakeCard({Key key, this.eq, this.onTap}) : super(key: key);

  final EarthQuakeData eq;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onTap,
      child: new Card(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(16.0),
//                    child: Container(),
                  ),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(eq.title,
                            softWrap: false, overflow: TextOverflow.ellipsis),
                        new Text(DateTime
                            .fromMillisecondsSinceEpoch(eq.time)
                            .toString()),
                      ],
                    ),
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

class EarthQuakeSubSheet extends StatelessWidget {
  EarthQuakeSubSheet({Key key, this.eq}) : super(key: key);

  final EarthQuakeData eq;

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new SafeArea(
        top: false,
        bottom: false,
        child: Column(children: [
          new Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
          ),
          new Flexible(
            child: FlutterMap(
              options: new MapOptions(
                center: new LatLng(51.0, -0.09),
                zoom: 5.0,
              ),
              layers: [
                new TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                new MarkerLayerOptions(
                  markers: [
                    new Marker(
                      width: 80.0,
                      height: 80.0,
                      point: new LatLng(51.5, -0.09),
                      builder: (ctx) => new Container(
                            child: new FlutterLogo(),
                          ),
                    ),
                    new Marker(
                      width: 80.0,
                      height: 80.0,
                      point: new LatLng(53.3498, -6.2603),
                      builder: (ctx) => new Container(
                            child: new FlutterLogo(
                              colors: Colors.green,
                            ),
                          ),
                    ),
                    new Marker(
                      width: 80.0,
                      height: 80.0,
                      point: new LatLng(48.8566, 2.3522),
                      builder: (ctx) => new Container(
                            child: new FlutterLogo(colors: Colors.purple),
                          ),
                    ),
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  TableRow _buildItemRow(String left, String right) {
    return new TableRow(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: new Text(
            left,
          ),
        ),
        new Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: new Text(
            right,
          ),
        ),
      ],
    );
  }
}
