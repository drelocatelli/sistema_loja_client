import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ColaboratorProvider%20copy.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/ProdutosRepository.dart';

Future fetchProdutos(BuildContext context, {bool onlyOnce = false, String? searchTerm, int? page = 1}) async {
  final model = Provider.of<ProdutoProvider>(context, listen: false);

  if(onlyOnce && model.produtos.isNotEmpty) {
    return;
  }

  final response = await ProdutosRepository.get(searchTerm: searchTerm, page: page);
  await Future.delayed(Duration(milliseconds: 1500));
  model.setIsLoading(true);

  if(response.status == 200) {  
    model.setError(false);
    model.setProdutos(response.data?.produtos ?? []);
  } else {
    model.setError(true);
  }

  Logger().i('Produtos loaded ${model.produtos.length}');
  
  model.setIsLoading(false);
}