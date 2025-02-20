import 'package:dio/dio.dart';
import 'package:racoon_tech_panel/src/Model/category_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';

class CategoryRepository {
  
  static Future<ResponseDTO<CategoryResponseDTO>> get() async {

    final String query = '''
      query GetAllCategories {
          getAllCategories {
              id
              name
          }
      }
    ''';

    return await BaseRepository.graphQlRequest(
      query: query, 
      authentication: true, 
      cbData: (response) {
        final data = response.data['data']['getAllCategories'];
        final dto = CategoryResponseDTO.fromJson(data);
        return ResponseDTO<CategoryResponseDTO>(status: 200, data: dto);
      }, 
      cbNull: (response) {
        return ResponseDTO<CategoryResponseDTO>(status: 401, data: CategoryResponseDTO(categories: []));
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