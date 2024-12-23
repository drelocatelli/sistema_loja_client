class LoginDTO {
  final bool error;
  final LoginData? data; // Nullable data
  final String message;

  LoginDTO({
    required this.error,
    required this.data,
    required this.message,
  });

  factory LoginDTO.fromJson(Map<String, dynamic> json) {
    return LoginDTO(
      error: json['error'] as bool,
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class LoginData {
  final String id;
  final String password;

  LoginData({
    required this.id,
    required this.password,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      id: json['id'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
    };
  }
}
