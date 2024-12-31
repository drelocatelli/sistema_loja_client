import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/Model/cliente_dto.dart';
import 'package:racoon_tech_panel/src/Model/clientes_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/ClientRepository.dart';

class ClientProvider extends ChangeNotifier {
  List<Cliente> _clientes = [];
  List<Cliente> get clientes => _clientes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  void setClientes(List<Cliente> clientes) {
    _clientes = clientes;
    notifyListeners();
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void clearClientes() {
    _clientes = [];
    notifyListeners();
  }
}