
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Wait...'),
          );
        },
      ),
   );
  }

  Future checkLoginState(BuildContext context) async{
    
    final authService = Provider.of<AuthService>(context, listen: false);

    final authenticate = await authService.isLoggedIn();

    if(authenticate){
      //Navigator.pushReplacementNamed(context, 'users');
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___)=> UsersPage(),
          transitionDuration: Duration(milliseconds: 0)
        )
      );
    }
    else{
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___)=> LoginPage(),
          transitionDuration: Duration(milliseconds: 0),
          
        )
      );
    }

  }

} 