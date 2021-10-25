import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin { //hago ese with para usar animaciones

  final _textCtrl = new TextEditingController();
  final _focusNode = new FocusNode();

  List<ChatMessage> _messages = [];

  bool _isTyping = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text("Te", style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text("Luciano Romero", style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                //Recibe build context e indice, pero se abrevia asi
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              )
            ),
            Divider(height: 1),

            //to do
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
   );
  }

  Widget _inputChat(){
  
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: 
          [
            Flexible(
              child: TextField(
                controller: _textCtrl,
                onSubmitted: _handleSubmit,
                onChanged: (text){
                  setState(() {
                    text.trim().length > 0 
                    ? _isTyping = true 
                    : _isTyping = false;
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: "Send message"
                ),
                focusNode: _focusNode,
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS 
              ? CupertinoButton(
                  child: Text("Send"), 
                  onPressed: _isTyping
                        ? () => _handleSubmit(_textCtrl.text.trim())
                        : null
                )
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconTheme(
                    data: IconThemeData(color: Colors.blue[400]),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.send, ),
                      onPressed: _isTyping
                        ? () => _handleSubmit(_textCtrl.text.trim())
                        : null
                    ),
                  ),
                )

            ),
          ],
        ),
      ),
    );

  }

  _handleSubmit(String text){

    if(text.length == 0) return;

    _textCtrl.clear();
    _focusNode.requestFocus(); 

    final newMessage = new ChatMessage(
      uid: '123', 
      text: text,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400)),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isTyping = false;
    });
    
  }


  @override
  void dispose() {
    

    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }

    super.dispose();
  }


}