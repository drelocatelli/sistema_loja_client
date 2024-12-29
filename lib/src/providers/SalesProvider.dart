import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/dto/vendas_dto.dart';

class SalesProvider extends ChangeNotifier {
  int _sortColumnIdx = 0;
  bool _isAscending = true;
  Set<String> _selectedSales = {};
  
  bool _isLoading = true;
  bool _isReloadingLoading = false;
  List<Venda> _sales = [];

  bool get isLoading => _isLoading;
  bool get isReloadingLoading => _isReloadingLoading;
  List<Venda> get sales => _sales;
  Set<String> get selectedSales => _selectedSales;
  int get sortColumnIdx => _sortColumnIdx;
  bool get isAscending => _isAscending;

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setSales(List<Venda> sales) {
    _sales = sales;
    notifyListeners();
  }

  void setIsReloadingLoading(bool isLoading) {
    _isReloadingLoading = isLoading;
    notifyListeners();
  }

  void toggleSelection(String serial) {
    if (_selectedSales.contains(serial)) {
      _selectedSales.remove(serial);
    } else {
      _selectedSales.add(serial);
    }
    notifyListeners();
  }

  void selectAll() {
  _selectedSales = _sales
      .map((sale) => sale.serial ?? '')  
      .toSet();
  notifyListeners();
}

  // Deselect all sales
  void deselectAll() {
    _selectedSales.clear();
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

  void clearSelection() {
    _sortColumnIdx = 0;
    _isAscending = true;  
    notifyListeners();
  }

}