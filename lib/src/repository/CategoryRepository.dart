import 'package:racoon_tech_panel/src/dto/category_response_dto.dart';
import 'package:racoon_tech_panel/src/dto/response_dto.dart';
import 'package:racoon_tech_panel/src/repository/BaseRepository.dart';

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
  
}