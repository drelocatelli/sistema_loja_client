import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/category_dto.dart';
import 'package:racoon_tech_panel/src/View/components/refresh_component.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/Model/sales_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/vendas_dto.dart';
import 'package:racoon_tech_panel/src/View/helpers.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/categories_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/colaborators_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/vendas_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/CategoryProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/SalesProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/SaleRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';

import '../../../../../ViewModel/functions/clientes_functions.dart';

class VendasTitle extends StatefulWidget {
  const VendasTitle({super.key});

  @override
  State<VendasTitle> createState() => _VendasTitleState();
}

class _VendasTitleState extends State<VendasTitle> {

  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadAllSalesProps(context);
    });
  }

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
              OutlinedButton(
                onPressed: () async {
                  novaCategoriaDialog(context, categoryModel);
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
      ]
    );
  }
}

