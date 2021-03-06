



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';

import 'package:chat_app/widgets/blue_button.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/helpers/show_alert.dart';



class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * .9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, //Con esto los separo literalmente como quiero
              children: <Widget>[
                Logo(title: 'Register'),
                _Form(),
                Labels(route: 'login', title: 'Already have an account?', subtitle: 'Sign In!'),
                // Text('Terms and conditions of use', style: TextStyle(fontWeight: FontWeight.w200))
              ],
            ),
          ),
        ),
      )
   );
  }
}


//Hago un stfull porque tiene estados el form
class _Form extends StatefulWidget {
  const _Form({ Key? key }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final pwCtrl    = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>( context );
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Name',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),

          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),

          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            textController: pwCtrl,
            isPassword: true,
          ),

          BlueButton(
            text: 'Create account',
            onPressed: authService.authenticating ? ()=>{} : () async {
               final registroOk = await authService.register(nameCtrl.text.trim(), emailCtrl.text.trim(), pwCtrl.text.trim());

               if ( registroOk == true ) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'users');
               } else {
                 showAlert(context, 'Registro incorrecto', registroOk );
               }

             },
            
          )
        ],
      ),
    );
  }
}




