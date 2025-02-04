import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/payload_dto.dart';
import 'package:racoon_tech_panel/src/Model/product_controller.dart';
import 'package:racoon_tech_panel/src/Model/produtos_response_dto%20copy.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ProductProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/FileUploadRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/LoginRepository.dart';

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

  static Future<ResponseDTO> create(BuildContext context, ProductController controller, model) async {

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

    

    // record product
    return await BaseRepository.graphQlRequest(
      query: query, 
      authentication: true,
      cbData: (response) async {
        final productId = response.data['data']['createProduct']['id'];
        
        // upload photos
        final uploadedPhotos = await uploadImageByDevice(context, productId, model);

        if(uploadedPhotos.status != 200) {
          return ResponseDTO(status: 401);
        } else {
          return ResponseDTO(status: 401, message: 'Não foi possível fazer upload da imagem');
        }

      }, 
      cbNull: (response) {
        return ResponseDTO(status: 401);
      }
    );

  }
}

Future uploadImageByDevice(BuildContext context, String filename, model) async {

  // not web
   if ((Platform.isAndroid || Platform.isIOS || Platform.isWindows || Platform.isMacOS || Platform.isLinux) && model.selectedImages != null && model.selectedImages!.isNotEmpty) {
      model.selectedImages.asMap().forEach((index, image) async {
          String name  = index == 0 ? filename : "${filename}_${index}";
          await uploadPhotos(context, index, filename, name, model);
      });
   } else if (kIsWeb) {
     model.imagesBytes.asMap().forEach((index, image) async {
          String name  = index == 0 ? filename : "${filename}_${index}";
          await uploadPhotos(context, index, filename, name, model);
     });
   }
}

Future<ResponseDTO> uploadPhotos(BuildContext context, int index, String folderPath, String filename, model) async {
  try {
    String uploadUrl = "${BaseRepository.baseStaticUrl}/upload";
    FormData formData = await FileuploadRepository.getFormDataOfImages(context, index, folderPath, filename, model);

    Dio dio = Dio();
    final token = await LoginRepository.getToken();

    final response = await dio.post(uploadUrl, data: formData, options: Options(
      headers: {
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      }
    ));
    return ResponseDTO(status: 200, message: response.data['message']);
    
  } catch(e) {
    Logger().w(e);
  }
  return ResponseDTO(status: 401);
}