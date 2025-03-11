import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/payload_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/Model/sales_controller_dto.dart';
import 'package:racoon_tech_panel/src/Model/sales_response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ProductProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';

class SaleRepository {

  static Future<ResponseDTO<SalesResponseDTO>> get({int ? pageNum = 1, String? searchTerm, bool isDeleted = true}) async {
    Map<String, dynamic> payload = {
      'page': pageNum,
      'deleted': isDeleted
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
                  id
                  serial
                  client {
                      name
                  }
                  colaborator {
                      name
                  }
                  product {
                      name
                      price
                      photos
                      category {
                          id
                          name
                      }
                  }
                  description
                  total
                  date
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

        return ResponseDTO<SalesResponseDTO>(status: 200, data: dto);
      }, 
      cbNull: (response) {
        return ResponseDTO<SalesResponseDTO>(status: 401, data: SalesResponseDTO(sales: [], pagination: null));
      }
    );
  }

  static Future delete({required List<String> ids}) async {
     final payload = 
        ids
        .asMap()
        .entries
        .map((entry) => "\"${entry.value}\"")
        .where((entry) => entry != null)
        .join(', ');

    final String query = '''
      mutation DeleteSales {
          deleteSales(ids: [$payload]) 
      }
    ''';

    await BaseRepository.graphQlRequest(
      query: query, 
      authentication: true, 
      cbData: (response) {
        return ResponseDTO(status: 200);
      }, 
      cbNull: (response) {
        return ResponseDTO(status: 401);
      }
    );
  }

  static Future create(SalesController controller) async {

    final payload = {
      'input': {
        'serial': controller.serialController.text,
        'product_id': controller.produto?.id,
        'description': controller.descricaoController.text,
        'colaborator_id': controller.colaborator?.id,
        'client_id': controller.cliente?.id,
        'total': int.parse(controller.quantityController.text),
      }
    };

    String payloadStr = PayloadDTO(payload['input']!);

    final String query = '''
      mutation CreateSale {
        createSale(input: {$payloadStr}) {
            id
            serial
            total
            colaborator {
                name
            }
            description
            client {
                name
            }
            product {
                name
            }
        }
    }
    ''';

    return await BaseRepository.graphQlRequest(
      query: query,
      authentication: true,
      cbData: (response) {
        return ResponseDTO(status: 200);
      },
      cbNull: (response) {
        return ResponseDTO<SalesResponseDTO>(status: 401, data: SalesResponseDTO(sales: [], pagination: null));
      }
    );

  }


  
}
