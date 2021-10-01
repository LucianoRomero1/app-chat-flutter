import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {

  final String text;
  final Function? onPressed;

  const BlueButton({
    Key? key, 
    this.text = '',
    this.onPressed 
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        primary: Colors.blue,
        shape: StadiumBorder(),
      ),
      onPressed: (){
        this.onPressed;
      }, 
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(this.text, style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      )
    );
  }
}