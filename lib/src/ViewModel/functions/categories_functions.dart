import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/CategoryProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/CategoryRepository.dart';

Future fetchCategories(BuildContext context, {bool onlyOnce = false, String? searchTerm}) async {
  final model = Provider.of<CategoryProvider>(context, listen: false);

  if(onlyOnce && model.categories.isNotEmpty) {
    return;
  }

  final response = await CategoryRepository.get();
  await Future.delayed(Duration(milliseconds: 1500));
  model.setIsLoading(true);

  if(response.status == 200) {
    model.setCategories(response.data?.categories ?? []);
  }
  model.setIsLoading(false);
}