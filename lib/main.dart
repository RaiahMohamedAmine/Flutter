import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
void main()=>  runApp(FriendlychatApp());

class FriendlychatApp extends StatelessWidget {
  @override
  final ThemeData newTheme = new ThemeData(
      primaryColor: Colors.purple,
      primarySwatch: Colors.orange,
      accentColor: Colors.pink);

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: defaultTargetPlatform== TargetPlatform.android? newTheme : null,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  State createState ()=> ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin
{
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _iscomposed = false;

  Widget build (BuildContext context)
  {
    return new  Scaffold(
      appBar: AppBar(
        title: Text("FreindlyChat"),
        elevation: Theme.of(context).platform ==TargetPlatform.android ? 4.0:0.0,
      ),
      body: Column(
        children: <Widget>[
          new Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  reverse:false,
                  itemBuilder: (_,int index) =>   _messages[index],
                  itemCount: _messages.length,
             )
          ),
          Divider(height: 1.0),
          Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTExtComposent(),
          )
        ],
      )
    );
  }

  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  Widget _buildTExtComposent ()
  {
    return IconTheme(
      data: IconThemeData( color: Theme.of(context).accentColor),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  decoration: new InputDecoration.collapsed(hintText: "Send a message"),
                  onChanged: (String text) {
                    setState(() {
                      _iscomposed = text.length>0;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child:IconButton(icon: Icon (Icons.send, color: Colors.pink,),
                    onPressed: () => _iscomposed ? _handleSubmitted (_textController.text) : null),
              ),
            ],
          ),
        ),

    );
  }
  
  _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _iscomposed=false;
    });
    ChatMessage message = new ChatMessage(text: text,
      animationController: new AnimationController(vsync: this,
                duration: new Duration(milliseconds: 500)),
    );
    setState(() {
      _messages.add(message);
    });
    message.animationController.forward();
  }

}

class ChatMessage extends StatelessWidget{
  ChatMessage({this.text, this.animationController});
  String text ;
  final String _name = "Amine Raiah";
  final AnimationController animationController ;

  Widget build (BuildContext context)
  {
    return (SizeTransition(sizeFactor: (CurvedAnimation(parent: animationController,
        curve: Curves.easeIn)),

      child: (Container(
        margin: const EdgeInsets.only(left: 5,bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin : EdgeInsets.only(right: 8),
              child: CircleAvatar(child: Text(_name[0]),),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_name, style: TextStyle(fontWeight: FontWeight.bold),),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(text),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    )
    );
  }
}