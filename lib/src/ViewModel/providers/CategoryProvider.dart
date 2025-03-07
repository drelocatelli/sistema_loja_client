import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/Model/category_dto.dart';

class CategoryProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _hasError = false;
  bool get hasError => _hasError;
  
  void setCategories(List<Category> categories) {
    categories.sort((a, b) => a.name!.compareTo(b.name!));
    _categories = categories;
    notifyListeners();
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void clearCategories() {
    _categories = [];
    notifyListeners();
  }

  void reset() {
    // to do
  }

  void setError(bool hasError) {
    _hasError = hasError;
    notifyListeners();
  }
  
}