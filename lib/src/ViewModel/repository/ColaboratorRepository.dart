import 'package:racoon_tech_panel/src/Model/colaborator_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/payload_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';

class ColaboratorRepository {

  static Future<ResponseDTO> assignColaboratorToUser({required String colaboratorId, required String userId}) async {

    Map<String, dynamic> payload = {
      'colaboratorId': colaboratorId,
      'userId': userId
    };

    String payloadStr = PayloadDTO(payload);

    final String query = '''
        mutation AssignColaboratorToUser {
          assignColaboratorToUser($payloadStr) {
            id
            password
            role
            colaborator_id
            user
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
        return ResponseDTO(status: 401);
      }
    );
  }

  static Future<ResponseDTO<ColaboratorResponseDTO>> get({int? page = 1, String? searchTerm, bool? assigned}) async {

    Map<String, dynamic> payload = {
      'page': page
    };

    if(searchTerm != null) {
      payload['searchTerm'] = searchTerm;
    }

    if(assigned != null) {
      payload['isAssigned'] = assigned;
    }

    String payloadStr = PayloadDTO(payload);

    final String query = '''
        query GetColaborators {
          getColaborators($payloadStr) {
              colaborators {
                  id
                  name
                  email
                  rg
                  date_of_birth
                  marital_status
                  gender
                  full_address
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
        final data = response.data['data']['getColaborators'];
        final dto = ColaboratorResponseDTO.fromJson(data);
        
        return ResponseDTO<ColaboratorResponseDTO>(status: 200, data: dto);
      },
      cbNull: (response) {
        return ResponseDTO<ColaboratorResponseDTO>(status: 401, data: ColaboratorResponseDTO(colaborators: [], pagination: null));
      }
    );
    
  }
  
}