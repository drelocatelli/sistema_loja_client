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
  final double? total;

  Venda({
    this.id,
    this.serial,
    this.client,
    this.colaborator,
    this.product,
    this.description,
    this.total,
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
      total: (json['total'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serial': serial,
      'client': client?.toJson(),
      'colaborator': colaborator?.toJson(),
      'product': product,
      'description': description,
      'total': total,
    };
  }
}