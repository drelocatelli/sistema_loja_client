import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:racoon_tech_panel/src/Model/cliente_dto.dart';
import 'package:racoon_tech_panel/src/Model/clientes_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/payload_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/LoginRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/utils/request.dart';

class ClientRepository {

  static Future<ResponseDTO<ClientesResponseDTO>> get({int? page = 1, String? searchTerm}) async {

    Map<String, dynamic> payload = {
      'page': page
    };

    if(searchTerm != null) {
      payload['searchTerm'] = searchTerm;
    }

    String payloadStr = PayloadDTO(payload);

    final String query = '''
      query GetClients {
          getClients($payloadStr) {
              clients {
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
              pagination {
                  totalRecords
                  totalPages
                  currentPage
                  pageSize
              }
          }
      }
    ''';

    return await BaseRepository.graphQlRequest(
      query: query, 
      authentication: true, 
      cbData: (response) {
        final clientsData = response.data['data']['getClients'];
        final clientesDTO = ClientesResponseDTO.fromJson(clientsData);


        return ResponseDTO<ClientesResponseDTO>(status: response.statusCode, data: clientesDTO);
      }, 
      cbNull: (response) {
        return ResponseDTO<ClientesResponseDTO>(status: response.statusCode, data: ClientesResponseDTO(clientes: [], pagination: null));
      }
    );
    
  }

  static Future<ResponseDTO> create(Cliente client) async {
    final clientJson = client
        .toJson();
      clientJson.remove('id');
      clientJson.remove('createdAt');
      clientJson.remove('updatedAt');
      
      final payload = 
        clientJson
        .entries
        .map((entry) => (entry.value != '') ? '${entry.key}: "${entry.value}"' : null)
        .where((entry) => entry != null)
        .join(', ');

    final String returnStr = '''
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
    ''';

    String queryName = 'createClient';

    String query = '''
        mutation CreateClient {
            ${queryName}($payload) {
                ${returnStr}
            }
        }
      ''';

      if(client.id != '-1') {
        queryName = 'updateClient';
        query = '''
        mutation UpdateClient {
            ${queryName}(id: "${client.id}", $payload) {
                ${returnStr}
            }
        }
      ''';
      }

    return await BaseRepository.graphQlRequest(
      query: query, 
      authentication: true, 
      cbData: (response) {
        final clientData = response.data['data'][queryName] as Map<String, dynamic>;
        return ResponseDTO(status: response.statusCode, data: Cliente.fromJson(clientData));
      }, 
      cbNull: (response) {
        return ResponseDTO(status: response.statusCode);
      }
    );
  }

  static Future<ResponseDTO<List<Cliente>>> delete(List<String> ids) async {
    try {
      final endpoint = '${dotenv.env['SERVER_URL']!}:${dotenv.env['SERVER_PORT']!}';

      ids = ids.map((id) => id).toList();
      
      final token = await LoginRepository.getToken();
      
      final String deleteClientsQuery = '''
          mutation DeleteClients {
              deleteClients(ids: $ids) {
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
          'query': deleteClientsQuery
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Authorization': "Bearer $token",
          }
        )
      );

      if(response.data != null) {
        final clientsData = response.data['data']['deleteClients'] as List;
        List<Cliente> clients = clientsData.map((client) => Cliente.fromJson(client)).toList();

        return ResponseDTO<List<Cliente>>(status: response.statusCode, data: clients);
      }

      return ResponseDTO<List<Cliente>>(status: response.statusCode, data: []);

    } on DioException catch(err) {
      debugPrint(err.toString());

      String? message;
      if(err.type == DioExceptionType.connectionError) {
        message = 'Não foi possível estabelecer comunicação com o servidor';
      }
      return ResponseDTO(status: 500, message: message);
    }
  }
  
}