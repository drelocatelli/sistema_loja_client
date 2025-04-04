import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:logger/web.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/Model/sales_response_dto.dart';
import 'package:racoon_tech_panel/src/View/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/fetch/fetch_logs.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/vendas/components/vendas_search.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/vendas/components/vendas_table.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/vendas/components/vendas_title.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/colaborators_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/produtos_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/SalesProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/SaleRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';

class VendasPage extends StatefulWidget {
  const VendasPage({super.key});

  @override
  State<VendasPage> createState() => _VenddasState();
}

class _VenddasState extends State<VendasPage> {

  final NumberPaginatorController _controller = NumberPaginatorController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchSales(context, isDeleted: false);
      await fetchProdutos(context, isDeleted: false);
      await fetchColaborators(context);
      await fetchClients(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<SalesProvider>(
      builder: (context, model, child) {
        return MainLayout(
          isLoading: model.isLoading,
          child: SelectionArea(
            child: Column(
              children: [
                VendasTitle(),
                const Gap(10),
                VendasSearch(),
                Visibility(
                  visible: model.isLoading,
                  child: Text("Obtendo dados, aguarde...", style: Theme.of(context).textTheme.bodyMedium)
                ),
                Visibility(
                  visible: model.sales.isEmpty,
                  child: Text("Nenhuma venda cadastrada.")
                ),
                VendasTable(),
                Container(
                  color: Colors.white,
                  padding:  EdgeInsets.symmetric(horizontal: SharedTheme.isLargeScreen(context) ? 50 : 20, vertical: 8.0),
                  child: Visibility(
                    visible: model.totalPages > 1,
                    child: NumberPaginator(
                      config: NumberPaginatorUIConfig(
                        buttonSelectedBackgroundColor: SharedTheme.secondaryColor,
                      ),
                      numberPages: model.totalPages,
                      initialPage: model.currentIdx,
                      controller: _controller,
                      onPageChange: (int index) async {
                        setState(() {
                          model.setCurrentIdx(index);
                          model.setCurrentPage(index + 1);
                        });
                        await Future.delayed(const Duration(seconds: 1));
                        await fetchSales(context, pageNum: model.currentPage, pageSize: 4);
                      },
                    ),
                  ),
                ),
              ],
            )
          ),
        );
      }
    );
  }
}
