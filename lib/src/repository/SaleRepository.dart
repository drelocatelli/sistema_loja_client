import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/dto/payload_dto.dart';
import 'package:racoon_tech_panel/src/dto/response_dto.dart';
import 'package:racoon_tech_panel/src/dto/sales_response_dto.dart';
import 'package:racoon_tech_panel/src/repository/BaseRepository.dart';

class SaleRepository {

  static Future<ResponseDTO<SalesResponseDTO>> get({int ? pageNum = 1, String? searchTerm, int? page}) async {
    Map<String, dynamic> payload = {
      'page': pageNum
    };

    if(searchTerm != null) {
      payload['searchTerm'] = searchTerm;
    }

    String payloadStr = PayloadDTO(payload);

    final String query = '''
      query GetSales {
          getSales($payloadStr) {
              pagination {
                  totalRecords
                  totalPages
                  currentPage
                  pageSize
              }
              sales {
                  serial
                  client {
                      name
                  }
                  colaborator {
                      name
                  }
                  product {
                      name
                  }
                  description
                  total
              }
          }
      }
    ''';

    return await BaseRepository.graphQlRequest(
      query: query, 
      authentication: true, 
      cbData: (response) {
        final data = response.data['data']['getSales'];

        final dto = SalesResponseDTO.fromJson(data);
        debugPrint('data :');
        debugPrint(jsonEncode(dto));

        return ResponseDTO<SalesResponseDTO>(status: 200, data: dto);
      }, 
      cbNull: (response) {
        return ResponseDTO<SalesResponseDTO>(status: 401, data: SalesResponseDTO(sales: [], pagination: null));
      }
    );
  }
  
}