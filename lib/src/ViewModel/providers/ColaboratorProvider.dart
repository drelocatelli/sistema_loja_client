import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/Model/colaborator_dto.dart';

class ColaboratorProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  
  List<Colaborator> _colaboratorsBkp = [];
  List<Colaborator> get colaboratorsBkp => _colaboratorsBkp;
  
  List<Colaborator> _colaborators = [];
  List<Colaborator> get colaborators => _colaborators;


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
  
}