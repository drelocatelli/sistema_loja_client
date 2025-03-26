import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/View/components/refresh_component.dart';
import 'package:racoon_tech_panel/src/View/components/rowOrWrap.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/fetch/fetch_logs.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/categories_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/vendas_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/CategoryProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/SalesProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';

class VendasTitle extends StatefulWidget {
  const VendasTitle({super.key});

  @override
  State<VendasTitle> createState() => _VendasTitleState();
}

class _VendasTitleState extends State<VendasTitle> {

  @override
  Widget build(BuildContext context) {
    final categoryModel = Provider.of<CategoryProvider>(context);


    return 
        Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Gerenciar vendas', style: Theme.of(context).textTheme.headlineMedium),
          Row(
            spacing: 5,
            children: [
              Consumer<SalesProvider>(
                builder: (context, model, child) {
                  return Visibility(
                    visible: !SharedTheme.isLargeScreen(context),
                    child: InkWell(onTap: () async {
                      await reloadVendas(context);
                      await loadAllSalesProps(context);
                    }, child: RefreshComponent(isLoading: model.isReloading))
                  );
                }
              ),
              rowOrWrap(
                context,
                wrap: !SharedTheme.isLargeScreen(context),
                column: true,
                spacing: !SharedTheme.isLargeScreen(context) ? 5 : 10,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      novaCategoriaDialog(context, categoryModel);
                      await fetchCategories(context, allCategories: true);
                    }, 
                    child: const Text('Gerenciar categorias')
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      novaVendaDialog(context);
                    }, 
                    child: const Text('Adicionar nova venda')
                  ),
                ],
              ),
              
            ],
          ),
      ]
    );
  }
}

