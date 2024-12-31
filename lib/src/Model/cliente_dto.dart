class Cliente {
  String? name;
  String? email;
  String? id;
  String? address;
  String? cep;
  String? city;
  String? state;
  String? country;
  String? cpf;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  String? phone;
  String? rg;

  Cliente({
    this.name,
    this.email,
    this.id,
    this.address,
    this.cep,
    this.city,
    this.state,
    this.country,
    this.cpf,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.phone,
    this.rg,
  });

  // Convert the model to a map for JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
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

  // Create a model from a map (to handle JSON input)
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
      cep: json['cep'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      cpf: json['cpf'],
      createdAt: json['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['created_at']))
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['updated_at']))
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['deleted_at']))
          : null,
      phone: json['phone'],
      rg: json['rg'],
    );
  }
}
