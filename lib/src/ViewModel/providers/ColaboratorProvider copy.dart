import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/Model/colaborator_dto.dart';
import 'package:racoon_tech_panel/src/Model/product_dto.dart';

class ProdutoProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  
  List<Produto> _produtosBkp = [];
  List<Produto> get produtosBkp => _produtosBkp;
  
  List<Produto> _produtos = [];
  List<Produto> get produtos => _produtos;

  bool _hasError = false;
  bool get hasError => _hasError;


  void setProdutos(List<Produto> produto) {
    _produtos = produto;
    if(_produtosBkp.isEmpty) {
      _produtosBkp = produto;
    }
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearProdutos() {
    _produtos = [];
    notifyListeners();
  }

  void reset() {
    _produtos = _produtosBkp;
    notifyListeners();
  }

  void setError(bool hasError) {
    _hasError = hasError;
    notifyListeners();
  }
  
}