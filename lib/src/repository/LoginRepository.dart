import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:racoon_tech_panel/src/dto/login_dto.dart';
import 'package:racoon_tech_panel/src/dto/response_dto.dart';
import 'package:racoon_tech_panel/src/utils/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  static final endpoint = dotenv.env['SERVER_URL']! + ':' +  dotenv.env['SERVER_PORT']!;

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    return token;
  }

  static Future<ResponseDTO<String>> login(String password) async {
    try {

      final dio = requestInterceptor();
      String loginQuery = '''
        mutation Login {
          login(password: "$password") {
              error
              message
              token
          }
        }
      ''';

      final request = await dio.post(
        endpoint,
        data: {
          'query': loginQuery
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          }
        )
      );

      if(request != null) {
        final loginData = request.data['data']['login'];
        // debugPrint(loginData.toString());

        final response = LoginDTO.fromJson(loginData);

        if(!response.error) {
          return ResponseDTO<String>(status: 200, message: response.message, data: response.token);
        }

        return ResponseDTO<String>(status: 401, message: response.message);
      }

      return ResponseDTO<String>(status: 401, message: 'Ocorreu um erro inesperado');
      
    }  on DioException catch(err) {
      debugPrint("${err.toString()}");

      String? message = null;
      if(err.type == DioExceptionType.connectionError) {
        message = 'Não foi possível estabelecer comunicação com o servidor';
      }
      return ResponseDTO<String>(status: 500, message: message);
    }
    
  }
}