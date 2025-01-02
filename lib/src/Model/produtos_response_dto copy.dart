import 'package:racoon_tech_panel/src/Model/pagination_dto.dart';
import 'package:racoon_tech_panel/src/Model/product_dto.dart';

class ProdutosResponseDTO {
  final List<Produto> produtos;
  final PaginationDTO? pagination;

  ProdutosResponseDTO({
    required this.produtos,
    this.pagination,
  });

  factory ProdutosResponseDTO.fromJson(Map<String, dynamic> json) {
    return ProdutosResponseDTO(
      produtos: List<Produto>.from(json['products'].map((x) => Produto.fromJson(x))),
      pagination: json['pagination'] != null ? PaginationDTO.fromJson(json['pagination']) : null,
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'products': produtos.map((x) => x.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}