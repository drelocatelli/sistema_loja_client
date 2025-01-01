import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:racoon_tech_panel/src/Model/colaborator_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/payload_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';

class ColaboratorRepository {

  static Future<ResponseDTO<ColaboratorResponseDTO>> get({int? page = 1, String? searchTerm}) async {

    Map<String, dynamic> payload = {
      'page': page
    };

    if(searchTerm != null) {
      payload['searchTerm'] = searchTerm;
    }

    String payloadStr = PayloadDTO(payload);

    debugPrint(payloadStr);

    final String query = '''
        query GetColaborators {
          getColaborators($payloadStr) {
              colaborators {
                  id
                  name
                  email
                  role
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