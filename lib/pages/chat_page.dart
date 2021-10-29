import 'dart:io';




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/chat_service.dart';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:chat_app/models/message_response.dart';

class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin { //hago ese with para usar animaciones

  final _textCtrl = new TextEditingController();
  final _focusNode = new FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessage> _messages = [];

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();

    this.chatService   = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService   = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('personal-message', _listenMessage);

    _loadHistory(this.chatService.userTo.uid);

  }

  void _loadHistory(String userId) async {

    List<Message> chat = await this.chatService.getChat(userId);

    final history = chat.map((m) => new ChatMessage(
      text: m.msg, 
      uid: m.from, 
      animationController: new AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward()
    ));

    setState(() {
      _messages.insertAll(0, history);
    });

  }


  void _listenMessage( dynamic payload ) {

     //print("TENGO MENSAJE $payload");
    
    ChatMessage message = new ChatMessage(
      text: payload['msg'], 
      uid: payload['from'], 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300))
    );
    setState(() {
      _messages.insert(0,message );
    });
    message.animationController.forward();

  }


  @override
  Widget build(BuildContext context) {

    final userTo = chatService.userTo;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(userTo.name.substring(0,2), style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(userTo.name, style: TextStyle(color: Colors.black87, fontSize: 12))
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
      uid: authService.user.uid, 
      text: text,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400)),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {_isTyping = false; });

    this.socketService.emit('personal-message', {
      'from': this.authService.user.uid,
      'to': this.chatService.userTo.uid,
      'msg': text
    });
    
  }


  @override
  void dispose() {
    

    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }


    this.socketService.socket.off('personal-message');
    super.dispose();
  }


}