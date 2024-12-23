import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:racoon_tech_panel/src/dto/cliente_dto.dart';
import 'package:racoon_tech_panel/src/dto/response_dto.dart';
import 'package:racoon_tech_panel/src/utils/request.dart';

class ClientRepository {

  static Future<ResponseDTO<List<Cliente>>> getClients() async {
    try {
      final endpoint = dotenv.env['SERVER_URL']! + ':' +  dotenv.env['SERVER_PORT']!;
      
      const String getClientsQuery = '''
        query GetClients {
          getClients {
            id
            name
            email
            rg
            cpf
            phone
            address
            cep
            city
            state
            country
            created_at
            updated_at
            deleted_at
          }
        }
      ''';

      final dio = requestInterceptor();
      final response = await dio.post(
        endpoint,
        data: {
          'query': getClientsQuery
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          }
        )
      );

      if(response.data != null) {
        final clientsData = response.data['data']['getClients'] as List;
        List<Cliente> clients = clientsData.map((client) => Cliente.fromJson(client)).toList();

        return ResponseDTO<List<Cliente>>(status: response.statusCode, data: clients);
      }

      return ResponseDTO<List<Cliente>>(status: response.statusCode, data: []);
    } on DioException catch(err) {
      debugPrint("${err.toString()}");

      String? message = null;
      if(err.type == DioExceptionType.connectionError) {
        message = 'Não foi possível estabelecer comunicação com o servidor';
      }
      return ResponseDTO(status: 500, message: message);
    }
    
  }

  static Future<ResponseDTO> deleteClient(String id) async {
    try {
      final endpoint = dotenv.env['SERVER_URL']!+ ':' + dotenv.env['SERVER_PORT']!;
      final String deleteClientQuery = '''
        mutation DeleteClient {
            deleteClient(id: "$id")
        }
      ''';

      final dio = requestInterceptor();
      await dio.post(
        endpoint,
        data: {
          'query': deleteClientQuery
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          }
        )
      );

      return ResponseDTO(status: 200);

    } on DioException catch(err) {
      debugPrint("${err.toString()}");

      String? message = null;
      if(err.type == DioExceptionType.connectionError) {
        message = 'Não foi possível estabelecer comunicação com o servidor';
      }
      return ResponseDTO(status: 500, message: message);
    }
  }

  // static Future<ResponseDTO> deleteClients(List<String> ids) async {

  // }
  
}