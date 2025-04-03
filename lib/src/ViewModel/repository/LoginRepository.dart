import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/web.dart';
import 'package:racoon_tech_panel/src/Model/login_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  static final endpoint = '${dotenv.env['SERVER_URL']!}${BaseRepository.serverPort}/graphql';

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    return token;
  }

  static Future<LoginResponseDTO?> getCurrentLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? login = prefs.getString('login');
    final loginRes = LoginResponseDTO.fromJson(jsonDecode(login!));

    return loginRes;
  }

  static Future<ResponseDTO<LoginResponseDTO>> login(String user, String password) async {
    String query = '''
      mutation Login {
        login(user: "$user", password: "$password") {
            error
            message
            token
            details {
              id
              role
              colaborator_id
              user
              colaborator {
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
            }
        }
      }
    ''';

    return await BaseRepository.graphQlRequest(
      query: query, 
      authentication: false, 
      cbData: (request) {
        final loginData = request.data['data']['login']; 
        final dto = LoginResponseDTO.fromJson(loginData);
        

         if(!loginData['error']) {
          return ResponseDTO<LoginResponseDTO>(status: 200, message: dto.message, data: LoginResponseDTO(details: dto.details, token: dto.token));
        }

        return ResponseDTO<LoginResponseDTO>(status: 401, message: loginData['message']);
      }, 
      cbNull: (request) {
        return ResponseDTO<LoginResponseDTO>(status: 401, message: 'Ocorreu um erro inesperado');
      },
      onErrorCb: (err) {
        Logger().e(err);
      }
    );
  }

}