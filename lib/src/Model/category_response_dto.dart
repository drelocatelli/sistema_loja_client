import 'package:racoon_tech_panel/src/Model/category_dto.dart';

class CategoryResponseDTO {
  final List<Category> categories;

  // Constructor
  CategoryResponseDTO({required this.categories});

  // Factory method to parse a list of categories
  factory CategoryResponseDTO.fromJson(List<dynamic> json) {
    return CategoryResponseDTO(
      categories: json.map((item) => Category.fromJson(item)).toList(),
    );
  }
}
