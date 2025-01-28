import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/Model/category_dto.dart' as racoon;

class ProductController {
  final name = TextEditingController();
  racoon.Category? category;
  final price = TextEditingController();
  final quantity = TextEditingController();
  final description = TextEditingController();
  bool isPublished = false;

  ProductController() {
    name.text = kDebugMode ? 'Teste' : '';
    price.text = kDebugMode ? '10.00' : '';
    quantity.text = kDebugMode ? '10' : '';
    description.text = kDebugMode ? 'Teste' : '';
    isPublished = false;
  }

}