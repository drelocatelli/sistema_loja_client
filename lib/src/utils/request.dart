import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

requestInterceptor() {
  // dio interceptor
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      debugPrint("Requisição pro servidor: ${dotenv.env['SERVER_URL']}");
      return handler.next(options);
    },
    onError: (error, handler) {
      debugPrint("Ocorreu um erro: ${error.toString()}");
      return handler.next(error);
    },
  ));

  return dio;
}