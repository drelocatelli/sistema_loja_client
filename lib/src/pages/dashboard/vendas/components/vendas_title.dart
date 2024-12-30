import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/components/refresh_component.dart';
import 'package:racoon_tech_panel/src/dto/response_dto.dart';
import 'package:racoon_tech_panel/src/dto/sales_response_dto.dart';
import 'package:racoon_tech_panel/src/dto/vendas_dto.dart';
import 'package:racoon_tech_panel/src/helpers.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/vendas/functions/vendas_functions.dart';
import 'package:racoon_tech_panel/src/providers/SalesProvider.dart';
import 'package:racoon_tech_panel/src/repository/SaleRepository.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';

class VendasTitle extends StatelessWidget {
  const VendasTitle({super.key});

  @override
  Widget build(BuildContext context) {
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
                    }, child: RefreshComponent(isLoading: model.isReloading))
                  );
                }
              ),
              ElevatedButton(
                onPressed: () {
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

