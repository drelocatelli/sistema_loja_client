import 'package:racoon_tech_panel/src/Model/category_dto.dart';
import 'package:racoon_tech_panel/src/Model/pagination_dto.dart';

class CategoryResponseDTO {
  final List<Category> categories;
  final PaginationDTO? pagination;

  CategoryResponseDTO({required this.categories, required this.pagination});

  factory CategoryResponseDTO.fromJson(Map<String, dynamic> json) {
    return CategoryResponseDTO(
      categories: (json['categories'] as List)
          .map((item) => Category.fromJson(item))
          .toList(),
      pagination: PaginationDTO.fromJson(json['pagination']),
    );
  }
}