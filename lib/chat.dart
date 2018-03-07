import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
const String _name = "Herry Wang";
class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  ChatPageState createState() => new ChatPageState();
}
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_name, style: Theme.of(context).textTheme.subhead),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
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
class ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  bool _isComposing = false;
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
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
  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar:  AppBar(
        title:  Text(widget.title),
        backgroundColor: const Color(0xFF42A5F5),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body:  Container(
          child:  Column(
            children: <Widget>[
              Flexible(
                child:  ListView.builder(
                  padding:  EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              controller: _textController,
                              onSubmitted: _handleSubmitted,
                              decoration:
                              InputDecoration.collapsed(hintText: "Send a message"),
                              onChanged: (String text) {
                                setState(() {
                                  _isComposing = text.length > 0;
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
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
                    ],
                  ),
                decoration:
                BoxDecoration(color: Theme.of(context).cardColor),
              )
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ?  BoxDecoration(
            border:  Border(
              top:  BorderSide(color: Colors.grey[200]), //new
            ),
          )
              : null),
    );
  }
}


