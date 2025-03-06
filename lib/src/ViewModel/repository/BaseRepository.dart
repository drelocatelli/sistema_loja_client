import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/web.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/LoginRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/utils/request.dart';

class BaseRepository {

  static String baseUrl = "${dotenv.env['SERVER_URL']}:${dotenv.env['SERVER_PORT']}/graphql";
  static String baseStaticUrl = "${dotenv.env['SERVER_URL']}:${dotenv.env['SERVER_PORT']}";

  static Future<ResponseDTO<T>> graphQlRequest<T>({required String query, required bool authentication ,required Function cbData, required Function cbNull, Function? onErrorCb}) async {
    try {
      final  endpoint = baseUrl;

      final token = await LoginRepository.getToken();

      final fetch = requestInterceptor();

      final headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      };
      
      if(authentication) {
        // headers['Authorization'] = 'Bearer $token';
        headers['Authorization'] = 'Bearer aaa';
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

      if(response.data['errors'] != null) {
        final errors = response.data['errors'];
        final errorsStr = response.data['errors'].map((error) => error['message']).toList().join(', ');

        return ResponseDTO(status: 401, message: errorsStr);
      }

      if(response.data != null) {
        return cbData(response);
      }

      return cbNull(response);

    }  on DioException catch(err) {
      debugPrint(err.toString());
      if(onErrorCb != null) {
        onErrorCb(err);
      }

      String? message;
      if(err.type == DioExceptionType.connectionError) {
        message = 'Não foi possível estabelecer comunicação com o servidor';
      }
      return ResponseDTO(status: 500, message: message);
    }
    
  }
  
}