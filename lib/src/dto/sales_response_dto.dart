import 'package:racoon_tech_panel/src/dto/pagination_dto.dart';
import 'package:racoon_tech_panel/src/dto/vendas_dto.dart';


class SalesResponseDTO {
  final List<Venda> sales;
  final PaginationDTO? pagination;

  SalesResponseDTO({
    required this.sales,
    required this.pagination,
  });

  // Factory method to create an instance from a JSON map
  factory SalesResponseDTO.fromJson(Map<String, dynamic> json) {
    return SalesResponseDTO(
      sales: (json['sales'] as List)
          .map((e) => Venda.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? PaginationDTO.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  // Method to convert the instance back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'sales': sales.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}