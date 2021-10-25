import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final String title;

  const Logo({
    Key? key, 
    required this.title,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150,
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Image(image: AssetImage('assets/chat-app-logo2.png')),
            SizedBox(height: 20),
            Text(this.title, style: TextStyle(fontSize: 30))
          ],
        ),
      ),
    );
  }
}