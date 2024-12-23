class Cliente {
  final String name;
  final String? email;
  String id;
  String? address;
  String? cep;
  String? city;
  String? state;
  String? country;
  String? cpf;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;
  String? phone;
  String? rg;

  Cliente({
    required this.name,
    required this.email,
    required this.id,
    this.address,
    this.cep,
    this.city,
    this.state,
    this.country,
    this.cpf,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.phone,
    this.rg,
  });

  // Converte o modelo em um mapa para ser usado em JSON
   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'name': name,
      'email': email,
      'rg': rg,
      'cpf': cpf,
      'phone': phone,
      'address': address,
      'cep': cep,
      'city': city,
      'state': state,
      'country': country,
    };
  }

  // Método para criar um modelo a partir de um mapa (para receber dados de JSON)
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'],
      cep: json['cep'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      cpf: json['cpf'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['created_at'])),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['updated_at'])),
      deletedAt: json['deleted_at'] != null ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['deleted_at'])) : null,
      phone: json['phone'],
      rg: json['rg'],
    );
  }
}
