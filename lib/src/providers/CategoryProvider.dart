import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/dto/category_dto.dart';

class CategoryProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  List<Category> _categories = [];
  List<Category> get categories => _categories;
  
  void setCategories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}