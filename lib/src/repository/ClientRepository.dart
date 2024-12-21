import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:racoon_tech_panel/src/dto/cliente_dto.dart';
import 'package:racoon_tech_panel/src/dto/response_dto.dart';

class ClientRepository {

  static Future<ResponseDTO<List<Cliente>>> getClients() async {
    try {
      final endpoint = dotenv.env['SERVER_URL']!;
      
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

      final response = await Dio().post(
        endpoint,
        data: {
          'query': getClientsQuery
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          }
        )
      );

      if(response.data != null) {
        final clientsData = response.data['data']['getClients'] as List;
        List<Cliente> clients = clientsData.map((client) => Cliente.fromJson(client)).toList();
        return ResponseDTO<List<Cliente>>(status: response.statusCode, data: clients);
      }

      return ResponseDTO<List<Cliente>>(status: response.statusCode, data: []);
    } catch(err) {
      return ResponseDTO(status: 500, message: err.toString());
    }
    
  }
  
}