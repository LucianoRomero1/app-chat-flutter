

import 'package:http/http.dart' as http;

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/users_response.dart';

import 'package:chat_app/services/auth_service.dart';


class UserService {

  Future<List<User>> getUsers() async {

    //obtengo el token asi sino no funca
    String? token = await AuthService.getToken();

    try {
      
      final uri = Uri.parse('${Environment.apiUrl}/users');
      final resp = await http.get(uri,
        headers: {
          'Content-Type': 'application.json',
          'x-token': token.toString()
        }
      );

      final usersResponse = usersResponseFromJson(resp.body);

      return usersResponse.users;

    } catch (e) {

      return [];
    }

  }
 
}