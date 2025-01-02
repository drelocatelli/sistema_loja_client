import 'package:logger/web.dart';
import 'package:racoon_tech_panel/src/Model/payload_dto.dart';
import 'package:racoon_tech_panel/src/Model/produtos_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';

class ProdutosRepository {
   static Future<ResponseDTO<ProdutosResponseDTO>> get({int ? pageNum = 1, String? searchTerm, int? page}) async {
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
}