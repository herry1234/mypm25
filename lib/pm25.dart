import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:convert';

class PM25 extends StatefulWidget {
  PM25({Key key, this.title}) : super(key: key);
  final title;
  @override
  PM25State createState() => new PM25State();
}

class PM25State extends State<PM25> {
  int _pm25 = 0;
  _updatePM25() async {
    var httpClient = new HttpClient();
    var uri = new Uri.http('api.waqi.info', '/feed/@728/',
        {'token': 'c2e449bbb5e4dffa06e8b5f28a7813e7b4f5b2e6'});
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(UTF8.decoder).join();
    var data = JSON.decode(responseBody);
    print(data.toString());
    setState(() {
      _pm25 = data['data']['iaqi']['pm25']['v'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF42A5F5),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Container(
          child: Column(children: <Widget>[
        Text(
          'PM25:',
        ),
        Text(
          '$_pm25',
          style: Theme.of(context).textTheme.display1,
        ),
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _updatePM25,
        tooltip: 'Update',
        child: Icon(Icons.update),
      ),
    );
  }
}
