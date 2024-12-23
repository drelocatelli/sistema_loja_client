import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:racoon_tech_panel/src/dto/response_dto.dart';
import 'package:racoon_tech_panel/src/repository/LoginRepository.dart';
import 'package:racoon_tech_panel/src/utils/request.dart';

class BaseRepository {

  static Future<ResponseDTO<T>> graphQlRequest<T>({required String query, required bool authentication ,required Function cbData, required Function cbNull}) async {
    try {
      final  endpoint = dotenv.env['SERVER_URL']!+ ':' + dotenv.env['SERVER_PORT']!;

      final token = await LoginRepository.getToken();

      final fetch = requestInterceptor();

      final headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      };
      
      if(authentication) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await fetch.post(
        endpoint,
        data: {
          'query': query
        },
        options: Options(
          headers: headers
        )
      );

      if(response.data != null) {
        return cbData(response);
      }

      return cbNull(response);

    }  on DioException catch(err) {
      debugPrint("${err.toString()}");

      String? message = null;
      if(err.type == DioExceptionType.connectionError) {
        message = 'Não foi possível estabelecer comunicação com o servidor';
      }
      return ResponseDTO(status: 500, message: message);
    }
    
  }
  
}