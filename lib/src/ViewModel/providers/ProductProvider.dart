import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/Model/colaborator_dto.dart';
import 'package:racoon_tech_panel/src/Model/product_dto.dart';

class ProdutoProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isReloading = true;
  bool get isReloading => _isReloading;
  
  List<Produto> _produtosBkp = [];
  List<Produto> get produtosBkp => _produtosBkp;
  
  List<Produto> _produtos = [];
  List<Produto> get produtos => _produtos;

  bool _hasError = false;
  bool get hasError => _hasError;

  int _sortColumnIdx = 0;
  int get sortColumnIdx => _sortColumnIdx;

  bool _sortAscending = true;
  bool get sortAscending => _sortAscending;

  List<String> _selectedIds = [];
  List<String> get selectedIds => _selectedIds;

  bool _isAscending = true;
  bool get isAscending => _isAscending;

  List<File>? _selectedImages = [];
  List<File>? get selectedImages => _selectedImages;

  List<Uint8List> _imagesBytes = [];
  List<Uint8List> get imagesBytes => _imagesBytes;

  int totalPages = 1;
  int currentPage = 1;
  int currentIdx = 0;


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

  void setIsReloading(bool value) {
    _isReloading = value;
    notifyListeners();
  }

  void clearProdutos() {
    _produtos = [];
    notifyListeners();
  }

  void reset({bool removeAll = true}) {
    if(removeAll) {
      _produtos = [];
    } else {
      _produtos = _produtosBkp;
    }
    notifyListeners();
  }

  void setError(bool hasError) {
    _hasError = hasError;
    notifyListeners();
  }

  void toggleSelection(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id); // Se o index já estiver selecionado, remove
    } else {
      _selectedIds.add(id); // Se não estiver, adiciona
    }
    notifyListeners(); // Notifica para atualizar a UI
  }

  void selectAll() {
    _selectedIds = List<String>.generate(_produtos.length, (int index) => _produtos[index].id!);
    notifyListeners();
  }

  void unselectAll() {
    _selectedIds = [];
    notifyListeners();
  }

  void sort(int columnIndex, bool ascending) {
      if (columnIndex == 0) {
      _produtos.sort((a, b) {
        // Safely handle nulls
        return a.name?.compareTo(b.name ?? '') ?? 0;
      });
    }

    if (!ascending) {
      _produtos = _produtos.reversed.toList();
    }

    _sortColumnIdx = columnIndex;
    _isAscending = ascending;

    // Notify listeners to rebuild the UI
    notifyListeners();
  }

  void setImages(List<File> images) {
    _selectedImages = images;
    notifyListeners();
  }

  void setTotalPages(int value) {
    totalPages = value;
    notifyListeners();
  }

  void setCurrentPage(int value) {
    currentPage = value;
    notifyListeners();
  }

  void setCurrentIdx(int value) {
    currentIdx = value;
    notifyListeners();
  }

  void setImagesBytes(List<Uint8List> imagesBytes) {
    _imagesBytes = imagesBytes;
    notifyListeners();
  }
  
}