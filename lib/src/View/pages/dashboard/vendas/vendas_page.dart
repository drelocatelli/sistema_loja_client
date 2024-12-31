import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/cliente_dto.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/Model/sales_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/vendas_dto.dart';
import 'package:racoon_tech_panel/src/View/helpers.dart';
import 'package:racoon_tech_panel/src/View/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/vendas/components/vendas_search.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/vendas/components/vendas_table.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/vendas/components/vendas_title.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/CategoryProvider.dart';
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
  int _totalPages = 1;
  int currentIdx = 0;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchData();
    });
  }

  Future _fetchData({int? page = 1, String? searchTerm}) async {
    final model = Provider.of<SalesProvider>(context, listen: false);
    model.setIsLoading(true);
    ResponseDTO<SalesResponseDTO> vendasList = await SaleRepository.get(page: page, searchTerm: searchTerm);
    final newData = vendasList.data?.sales ?? [];

    if(vendasList.status != 200) {
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: const Text("Ocorreu um erro"),
            content: Text(vendasList.message ?? 'Ocorreu um erro inesperado!', style: Theme.of(context).textTheme.bodyMedium),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: const Text('Fechar')
              ),
            ],
          );  
        }
      );
    }

    model.setSales(newData);
    model.setIsLoading(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SalesProvider>(context);
    
    return MainLayout(
      isLoading: model.isLoading,
      floatingActionButton: Container(
        color: Colors.white,
        padding:  EdgeInsets.symmetric(horizontal: SharedTheme.isLargeScreen(context) ? 50 : 20, vertical: 8.0),
        child: Visibility(
          visible: _totalPages > 1,
          child: NumberPaginator(
            config: NumberPaginatorUIConfig(
              buttonSelectedBackgroundColor: SharedTheme.secondaryColor,
            ),
            numberPages: _totalPages,
            initialPage: currentIdx,
            controller: _controller,
            onPageChange: (int index) async {
              setState(() {
                currentIdx = index;
                currentPage = index + 1;
              });
              await Future.delayed(const Duration(seconds: 1));
              await _fetchData(page: currentPage);
            },
          ),
        ),
      ),
      child: SelectionArea(
        child: Column(
          children: [
            VendasTitle(),
            VendasSearch(),
            Helpers.rowOrWrap(
              wrap: !SharedTheme.isLargeScreen(context),
              children: [
                VendasTable(),
              ]
            )
          ],
        )
      ),
    );
  }
}
