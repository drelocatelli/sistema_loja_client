import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/web.dart';
import 'package:racoon_tech_panel/src/Model/login_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  static final endpoint = '${dotenv.env['SERVER_URL']!}:${dotenv.env['SERVER_PORT']!}/graphql';

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    return token;
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
            }
        }
      }
    ''';

    return await BaseRepository.graphQlRequest(
      query: query, 
      authentication: false, 
      cbData: (request) {
        Logger().i(request);
        final loginData = request.data['data']['login']; 
        final dto = LoginResponseDTO.fromJson(loginData);
        Logger().i(loginData);
        

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