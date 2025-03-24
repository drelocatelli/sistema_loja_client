import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/Model/colaborator_dto.dart';
import 'package:racoon_tech_panel/src/Model/login_response_dto.dart';

class ColaboratorProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  
  List<Colaborator> _colaboratorsBkp = [];
  List<Colaborator> get colaboratorsBkp => _colaboratorsBkp;
  
  List<Colaborator> _colaborators = [];
  List<Colaborator> get colaborators => _colaborators;

  bool _hasError = false;
  bool get hasError => _hasError;

  LoginResponseDTO _currentLogin = LoginResponseDTO();
  LoginResponseDTO get currentLogin => _currentLogin;

  bool hasColaboratorAssigned = false;


  void setCurrentLogin(LoginResponseDTO colaborator) {
    _currentLogin = colaborator;
    notifyListeners();
  }
  
  void setColaborators(List<Colaborator> colaborators) {
    _colaborators = colaborators;
    if(_colaboratorsBkp.isEmpty) {
      _colaboratorsBkp = colaborators;
    }
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearColaborators() {
    _colaborators = [];
    notifyListeners();
  }

  void reset() {
    _colaborators = _colaboratorsBkp;
    notifyListeners();
  }

  void setError(bool hasError) {
    _hasError = hasError;
    notifyListeners();
  }
  
}