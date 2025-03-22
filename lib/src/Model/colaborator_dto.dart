class Colaborator {
  String? id;
  String? name;
  String? email;
  String? rg;
  String? dateOfBirth;
  String? maritalStatus;
  String? gender;
  String? fullAddress;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Colaborator({
    this.id,
    this.name,
    this.email,
    this.rg,
    this.dateOfBirth,
    this.maritalStatus,
    this.gender,
    this.fullAddress,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // Factory method to create a Colaborator from JSON
  factory Colaborator.fromJson(Map<String, dynamic> json) {
    return Colaborator(
      id: json['id']?.toString(),
      name: json['name'],
      email: json['email'],
      rg: json['rg'],
      dateOfBirth: json['date_of_birth'],
      maritalStatus: json['marital_status'],
      gender: json['gender'],
      fullAddress: json['full_address'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      deletedAt: json['deleted_at'] != null ? json['deleted_at'].toString() : null,
    );
  }

  // Method to convert Colaborator to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'rg': rg,
      'date_of_birth': dateOfBirth,
      'marital_status': maritalStatus,
      'gender': gender,
      'full_address': fullAddress,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
