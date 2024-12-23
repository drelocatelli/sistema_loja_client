import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:racoon_tech_panel/src/dto/login_dto.dart';
import 'package:racoon_tech_panel/src/dto/response_dto.dart';
import 'package:racoon_tech_panel/src/utils/request.dart';

class LoginRepository {
  static final endpoint = dotenv.env['SERVER_URL']! + ':' +  dotenv.env['SERVER_PORT']!;

  static Future<ResponseDTO<LoginDTO>> login(String password) async {
    try {

      final dio = requestInterceptor();
      String loginQuery = '''
        mutation Login {
          login(password: "$password") {
              error
              message
              data {
                  id
                  password
              }
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
        final responseMap = request.data['data']['login'] as Map<String, dynamic>;
        final response = LoginDTO.fromJson(responseMap);

        if(!response.error) {
          return ResponseDTO<LoginDTO>(status: 200, message: response.message);
        }

        return ResponseDTO<LoginDTO>(status: 401, message: response.message);
      }

      return ResponseDTO<LoginDTO>(status: 401, message: 'Ocorreu um erro inesperado');
      
    }  on DioException catch(err) {
      debugPrint("${err.toString()}");

      String? message = null;
      if(err.type == DioExceptionType.connectionError) {
        message = 'Não foi possível estabelecer comunicação com o servidor';
      }
      return ResponseDTO<LoginDTO>(status: 500, message: message);
    }
    
  }
}