import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/web.dart';
import 'package:racoon_tech_panel/src/Model/login_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  static final endpoint = '${dotenv.env['SERVER_URL']!}:${dotenv.env['SERVER_PORT']!}/graphql';

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    return token;
  }

  static Future<ResponseDTO<String>> login(String user, String password) async {
    String query = '''
      mutation Login {
        login(user: "$user", password: "$password") {
            error
            message
            token
        }
      }
    ''';

    return await BaseRepository.graphQlRequest(
      query: query, 
      authentication: false, 
      cbData: (request) {
        Logger().i(request);
        final loginData = request.data['data']['login']; 
        Logger().i(loginData);
        final response = LoginDTO.fromJson(loginData);

         if(!response.error) {
          return ResponseDTO<String>(status: 200, message: response.message, data: response.token);
        }

        return ResponseDTO<String>(status: 401, message: response.message);
      }, 
      cbNull: (request) {
        return ResponseDTO<String>(status: 401, message: 'Ocorreu um erro inesperado');
      },
      onErrorCb: (err) {
        Logger().e(err);
      }
    );
  }

}