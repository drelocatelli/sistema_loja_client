import 'package:racoon_tech_panel/src/Model/colaborator_dto.dart';

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
  final String? colaboratorId;
  final String? user;
  final Colaborator? colaborator;

  LoginDetails({
    this.id,
    this.password,
    this.role = RoleEnum.colaborator,  // Atribuindo valor default
    this.colaboratorId,
    this.user,
    this.colaborator,
  });

  factory LoginDetails.fromJson(Map<String, dynamic> json) {
    return LoginDetails(
      id: json['id'],
      password: json['password'],
      role: json['role'] ?? RoleEnum.colaborator, // Garantindo valor default para role
      colaboratorId: json['colaborator_id'],
      user: json['user'],
      colaborator: json['colaborator'] != null ? Colaborator.fromJson(json['colaborator']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'role': role,
      'colaborator_id': colaboratorId,
      'user': user,
      'colaborator': colaborator?.toJson(),
    };
  }
}

class RoleEnum {
  static const String admin = 'admin';
  static const String colaborator = 'colaborator';
  static const String client = 'client';
  static const String guest = 'guest';
}
