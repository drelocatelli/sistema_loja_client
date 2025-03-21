import 'package:racoon_tech_panel/src/Model/category_dto.dart';
import 'package:racoon_tech_panel/src/Model/cliente_dto.dart';
import 'package:racoon_tech_panel/src/Model/colaborator_dto.dart';
import 'package:racoon_tech_panel/src/Model/product_dto.dart';

class Venda {
  final String? id;
  final String? serial;
  final Cliente? client;
  final Colaborator? colaborator;
  final Produto? product;
  final String? description;
  final int? total;
  final String? date;
  final Category? category;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Venda({
    this.id,
    this.serial,
    this.client,
    this.colaborator,
    this.product,
    this.description,
    this.total,
    this.date,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Venda.fromJson(Map<String, dynamic> json) {
    return Venda(
      id: json['id'] as String?,
      serial: json['serial'] as String?,
      client: json['client'] != null ? Cliente.fromJson(json['client']) : null,
      colaborator: json['colaborator'] != null
          ? Colaborator.fromJson(json['colaborator'])
          : null,
      product: json['product'] != null ? Produto.fromJson(json['product']) : null,
      description: json['description'] as String?,
      total: (json['total'] as num?)?.toInt(),
      date: json['date'] as String?,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serial': serial,
      'client': client?.toJson(),
      'colaborator': colaborator?.toJson(),
      'product': product?.toJson(),
      'description': description,
      'total': total,
      'date': date,
      'category': category?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
