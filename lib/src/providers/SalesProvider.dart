import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/dto/vendas_dto.dart';

class SalesProvider extends ChangeNotifier {
  int _sortColumnIdx = 0;
  bool _isAscending = true;
  
  bool _isLoading = true;
  bool _isReloadingLoading = false;
  List<Venda> _sales = [];
  List<int> _selectedIdx = [];

  bool get isLoading => _isLoading;
  bool get isReloadingLoading => _isReloadingLoading;
  List<Venda> get sales => _sales;
  int get sortColumnIdx => _sortColumnIdx;
  bool get isAscending => _isAscending;
  List<int> get selected => _selectedIdx;


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

  void toggleSelection(int index) {
    if (_selectedIdx.contains(index)) {
      _selectedIdx.remove(index); // Se o index já estiver selecionado, remove
    } else {
      _selectedIdx.add(index); // Se não estiver, adiciona
    }
    notifyListeners(); // Notifica para atualizar a UI
  }

  void selectAll() {
    _selectedIdx = List<int>.generate(_sales.length, (int index) => index); // All selected
    notifyListeners();
  }

  // Deselect all sales
  void deselectAll() {
    _selectedIdx = List<int>.generate(_sales.length, (int index) => index); // All deselected
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

}