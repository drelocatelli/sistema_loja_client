import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/payload_dto.dart';
import 'package:racoon_tech_panel/src/Model/product_controller.dart';
import 'package:racoon_tech_panel/src/Model/produtos_response_dto%20copy.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ProductProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';

class ProdutosRepository {
   static Future<ResponseDTO<ProdutosResponseDTO>> get({int? pageNum = 1, String? searchTerm}) async {
    Map<String, dynamic> payload = {
      'page': pageNum
    };

    if(searchTerm != null) {
      payload['searchTerm'] = searchTerm;
    }

    String payloadStr = PayloadDTO(payload);

    final String query = '''
      query GetProducts {
          getProducts($payloadStr) {
              products {
                name
                id
                description
                category {
                    name
                }
                price
                quantity
                is_published
                photos
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
        final data = response.data['data']['getProducts'];

        final dto = ProdutosResponseDTO.fromJson(data);

        return ResponseDTO<ProdutosResponseDTO>(status: 200, data: dto);
      }, 
      cbNull: (response) {
        return ResponseDTO<ProdutosResponseDTO>(status: 401, data: ProdutosResponseDTO(produtos: [], pagination: null));
      }
    );
  }

  static Future<ResponseDTO> create(ProductController controller) async {

    final payload = {
      'input': {
        'name': controller.name.text,
        'category_id': controller.category?.id,
        'price': double.parse(controller.price.text),
        'quantity': int.parse(controller.quantity.text),
        'is_published': controller.isPublished,
        'description': controller.description.text,
      }
    };

    String payloadStr = PayloadDTO(payload['input']!);

    String query = '''
      mutation CreateProduct {
        createProduct(input: {$payloadStr}) {
            id
            name
            description
            price
            quantity
            is_published
            category {
                name
            }
        }
      }
    ''';


    Logger().w(payloadStr);

    return await BaseRepository.graphQlRequest(
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

  static Future uploadPhotos(BuildContext context) async {
    final model = Provider.of<ProdutoProvider>(context, listen: true);

    dynamic images = (kIsWeb) 
      ? model.imagesBytes.map((e) => base64Encode(e)).toList()
      : model.selectedImages;

    Logger().w(images);
    
  }
}