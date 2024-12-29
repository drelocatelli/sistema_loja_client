class Produto {
  final String? name;  // Nullable name field

  Produto({this.name});

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      name: json['name'] as String?,  // Handling the 'name' field from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,  // Converting the 'name' field to JSON
    };
  }
}
