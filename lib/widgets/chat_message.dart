import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final String text; 
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    Key? key, 
    required this.text, 
    required this.uid,
    required this.animationController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: this.uid == "123"
          ? _myMessage()
          : _notMyMessage()
        ),
      ),
    );
  }



  Widget _myMessage(){

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(
          right: 5,
          bottom: 5,
          left: 50 // le agrega de la izquierda para que no se pegue al ancho de la pantalla
        ),
        child: Text(this.text, style: TextStyle(color: Colors.white)),
        decoration: BoxDecoration(
          color: Color(0xFF4D9EF6),
          borderRadius: BorderRadius.circular(8)
        ),
      ),
    );
  }


  Widget _notMyMessage(){
    
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(
          left: 5,
          bottom: 5,
          right: 50 // le agrega de la izquierda para que no se pegue al ancho de la pantalla
        ),
        child: Text(this.text, style: TextStyle(color: Colors.black87)),
        decoration: BoxDecoration(
          color: Color(0xFFE4E5E8),
          borderRadius: BorderRadius.circular(8)
        ),
      ),
    );
  }
}