import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/Model/vendas_dto.dart';

class SalesProvider extends ChangeNotifier {
  int _sortColumnIdx = 0;
  bool _isAscending = true;
  
  bool _isLoading = true;
  bool _isReloading = false;
  List<Venda> _sales = [];
  List<String> _selectedIds = [];

  bool get isLoading => _isLoading;
  bool get isReloading => _isReloading;
  List<Venda> get sales => _sales;
  int get sortColumnIdx => _sortColumnIdx;
  bool get isAscending => _isAscending;
  List<String> get selectedIds => _selectedIds;

  bool _hasError = false;
  bool get hasError => _hasError;

  int totalPages = 1;
  int currentPage = 1;
  int currentIdx = 0;


  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setSales(List<Venda> sales) {
    _sales = sales;
    notifyListeners();
  }

  void setIsReloading(bool isLoading) {
    _isReloading = isLoading;
    debugPrint('isReloading!');
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
    _selectedIds = List<String>.generate(_sales.length, (int index) => _sales[index].id!);
    notifyListeners();
  }

  // Deselect all sales
  void deselectAll() {
    _selectedIds = [];
    notifyListeners();
  }

  void sortSales(int columnIndex, bool ascending) {
  if (columnIndex == 0) {
    _sales.sort((a, b) {
      // Safely handle nulls
      return a.serial?.compareTo(b.serial ?? '') ?? 0;
    });
  }

  if (!ascending) {
    _sales = _sales.reversed.toList();
  }

  _sortColumnIdx = columnIndex;
  _isAscending = ascending;

  // Notify listeners to rebuild the UI
  notifyListeners();
}

  void setError(bool hasError) {
    _hasError = hasError;
    notifyListeners();
  }

  void setTotalPages(int value) {
    totalPages = (value == 0) ? 1 : value;
    notifyListeners();
  }

  void setCurrentPage(int value) {
    currentPage = value;
    notifyListeners();
  }

  void setCurrentIdx(int value) {
    currentIdx = currentIdx >= totalPages ? 0 : currentIdx;
    notifyListeners();
  }

}