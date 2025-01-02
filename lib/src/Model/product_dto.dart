import 'package:racoon_tech_panel/src/Model/category_dto.dart';

class Produto {
  String? name;
  String? id;
  String? description;
  Category? category;
  double? price;
  int? quantity;
  bool? isPublished;

  Produto({
    this.name,
    this.id,
    this.description,
    this.category,
    this.price,
    this.quantity,
    this.isPublished,
  });

  // Factory constructor para criar um objeto Produto a partir de um JSON
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      name: json['name'] as String?,
      id: json['id'] as String?,
      description: json['description'] as String?,
      category: json['category'] != null
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      price: (json['price'] as num?)?.toDouble(),
      quantity: json['quantity'] as int?,
      isPublished: json['is_published'] as bool?,
    );
  }

  // Método para converter um objeto Product em JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'description': description,
      'category': category?.toJson(),
      'price': price,
      'quantity': quantity,
      'is_published': isPublished,
    };
  }
}
