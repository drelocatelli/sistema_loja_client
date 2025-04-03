import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';

requestInterceptor() {
  // dio interceptor
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      debugPrint("Requisição pro servidor: ${dotenv.env['SERVER_URL']}${BaseRepository.serverPort}");
      return handler.next(options);
    },
    onError: (error, handler) {
      debugPrint("Ocorreu um erro: ${error.toString()}");
      return handler.next(error);
    },
  ));

  return dio;
}