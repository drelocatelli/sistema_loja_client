import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/CategoryProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/CategoryRepository.dart';

Future fetchCategories(BuildContext context) async {
  final model = Provider.of<CategoryProvider>(context, listen: false);
  final response = await CategoryRepository.get();
  model.setIsLoading(true);

  if(response.status == 200) {
    model.setCategories(response.data?.categories ?? []);
  }
  model.setIsLoading(false);
}