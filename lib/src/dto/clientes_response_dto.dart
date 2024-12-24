import 'package:racoon_tech_panel/src/dto/cliente_dto.dart';
import 'package:racoon_tech_panel/src/dto/pagination_dto.dart';

class ClientesResponseDTO {
  final List<Cliente> clientes;
  final PaginationDTO? pagination;

  ClientesResponseDTO({
    required this.clientes,
    required this.pagination,
  });

  factory ClientesResponseDTO.fromJson(Map<String, dynamic> json) {
    return ClientesResponseDTO(
      clientes: (json['clients'] as List)
          .map((client) => Cliente.fromJson(client))
          .toList(),
      pagination: PaginationDTO.fromJson(json['pagination']),
    );
  }
}