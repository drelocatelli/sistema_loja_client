import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ColaboratorProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/ColaboratorRepository.dart';

Future fetchColaborators(BuildContext context, {bool onlyOnce = false, String? searchTerm, int? page = 1}) async {
  final model = Provider.of<ColaboratorProvider>(context, listen: false);

  if(onlyOnce && model.colaborators.isNotEmpty) {
    return;
  }

  final response = await ColaboratorRepository.get(searchTerm: searchTerm, page: page);
  await Future.delayed(Duration(milliseconds: 1500));
  model.setIsLoading(true);

  if(response.status == 200) {  
    model.setError(false);
    model.setColaborators(response.data?.colaborators ?? []);
  } else {
    model.setError(true);
  }

  Logger().i('Colaborators loaded ${model.colaborators.length}');
  
  model.setIsLoading(false);
}