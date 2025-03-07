import 'package:dio/dio.dart';
import 'package:logger/web.dart';
import 'package:racoon_tech_panel/src/Model/category_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/payload_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';

class CategoryRepository {
  
  static Future<ResponseDTO<CategoryResponseDTO>> get({int? page = 1, String? searchTerm, int? pageSize = 5, bool? allCategories = false}) async {

    Map<String, dynamic> payload = {
      'page': page,
    };

    if(allCategories != null && allCategories == false) {
      payload['pageSize'] = pageSize;      
    }

    if(searchTerm != null) {
      payload['searchTerm'] = searchTerm;
    }

    String payloadStr = PayloadDTO(payload);


    final String query = '''
      query GetCategories {
        getCategories($payloadStr) {
            categories {
                id
                name
            }
            pagination {
                totalPages
                currentPage
                pageSize
                totalRecords
            }
        }
      }

    ''';

    return await BaseRepository.graphQlRequest(
      query: query, 
      authentication: true, 
      cbData: (response) {
        final data = response.data['data']['getCategories'];
        final dto = CategoryResponseDTO.fromJson(data);
        return ResponseDTO<CategoryResponseDTO>(status: 200, data: dto);
      }, 
      cbNull: (response) {
        return ResponseDTO<CategoryResponseDTO>(status: 401, data: CategoryResponseDTO(categories: [], pagination: null));
      }
    );

  }

  static Future<ResponseDTO> create(String categoryName) async {
    final String query = '''
      mutation CreateCategory {
          createCategory(name: "$categoryName") {
              id
              name
          }
      }
    ''';

    return await BaseRepository.graphQlRequest(
      query: query,
      authentication: true,
      cbData: (response) {
        return ResponseDTO<CategoryResponseDTO>(status: 200);
      },
      cbNull: (response) {
        return ResponseDTO(status: 401);
      }
    );

  }
  
  
}