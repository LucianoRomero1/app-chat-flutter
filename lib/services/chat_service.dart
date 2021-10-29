

import 'package:chat_app/models/message_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/global/environment.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/models/user.dart';


class ChatService with ChangeNotifier {

  late User userTo;  

 

  Future<List<Message>> getChat(String userId) async {

     String? token = await AuthService.getToken();
    
    final uri = Uri.parse('${ Environment.apiUrl }/messages/$userId');
    final resp = await http.get(uri, 
      headers: {
        'Content-Type': 'application/json',
        'x-token': token.toString()
      }
    );

    final msgResponse = messageResponseFromJson(resp.body);

    return msgResponse.messages;

  }

}