class LoginResponseDTO {
  final bool? error;
  final String? message;
  final String? token;
  final LoginDetails? details;

  LoginResponseDTO({
    this.error,
    this.message,
    this.token,
    this.details,
  });

  factory LoginResponseDTO.fromJson(Map<String, dynamic> json) {
    return LoginResponseDTO(
      error: json['error'],
      message: json['message'],
      token: json['token'],
      details: json['details'] != null ? LoginDetails.fromJson(json['details']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'token': token,
      'details': details?.toJson(),
    };
  }
}

class LoginDetails {
  final String? id;
  final String? password;
  final String? role;
  final int? colaboratorId;
  final String? user;

  LoginDetails({
    this.id,
    this.password,
    this.role,
    this.colaboratorId,
    this.user,
  });

  factory LoginDetails.fromJson(Map<String, dynamic> json) {
    return LoginDetails(
      id: json['id'],
      password: json['password'],
      role: json['role'],
      colaboratorId: json['colaborator_id'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'role': role,
      'colaborator_id': colaboratorId,
      'user': user,
    };
  }
}
