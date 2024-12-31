import 'package:racoon_tech_panel/src/Model/colaborator_dto.dart';
import 'package:racoon_tech_panel/src/Model/pagination_dto.dart';

class ColaboratorResponseDTO {
  final List<Colaborator> colaborators;
  final PaginationDTO? pagination;

  ColaboratorResponseDTO({
    required this.colaborators,
    this.pagination,
  });

  factory ColaboratorResponseDTO.fromJson(Map<String, dynamic> json) {
    return ColaboratorResponseDTO(
      colaborators: List<Colaborator>.from(json['colaborators'].map((x) => Colaborator.fromJson(x))),
      pagination: json['pagination'] != null ? PaginationDTO.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'colaborators': colaborators.map((x) => x.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
  
}