import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/CategoryProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/CategoryRepository.dart';

Future fetchCategories(BuildContext context, {bool onlyOnce = false, String? searchTerm, int? page = 1, bool? allCategories = false}) async {
  final model = Provider.of<CategoryProvider>(context, listen: false);

  if(onlyOnce && model.categories.isNotEmpty) {
    return;
  }

  model.setIsLoading(true);
  final response = await CategoryRepository.get(page: page, searchTerm: searchTerm, allCategories: allCategories);
  await Future.delayed(Duration(milliseconds: 1500));

  if(response.status == 200) {
    model.setCategories(response.data?.categories ?? []);
  }
  model.setIsLoading(false);

}