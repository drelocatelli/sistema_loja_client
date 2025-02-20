import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/Model/sales_response_dto.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/vendas/components/vendas_form.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/categories_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/clientes_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/colaborators_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/produtos_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/CategoryProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/SalesProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/SaleRepository.dart';

import '../../View/pages/dashboard/vendas/category_form.dart';

Future reloadVendas(BuildContext context) async {
  final model = Provider.of<SalesProvider>(context, listen: false);
  model.setIsReloading(true);
  ResponseDTO<SalesResponseDTO> vendasList = await SaleRepository.get(pageNum: 1);
  final newData = vendasList.data?.sales ?? []; 
  model.setSales(newData);
  await Future.delayed(Duration(milliseconds: 1500));
  model.setIsReloading(false);
}

Future saveVendas(BuildContext context) async {


}

Future loadVendas(BuildContext context) async {
  final model = Provider.of<SalesProvider>(context, listen: false);
  ResponseDTO<SalesResponseDTO> vendasList = await SaleRepository.get(pageNum: 1);
  final newData = vendasList.data?.sales ?? []; 
  model.setSales(newData);
}

deleteVendas(BuildContext context, List<String> ids) async {
  final model = Provider.of<SalesProvider>(context, listen: false);

  model.setIsReloading(true);
  await SaleRepository.delete(ids: ids);
  await loadVendas(context);
  model.deselectAll();
  model.setIsReloading(false);
}

loadAllSalesProps(BuildContext context) async {
  // load categories
  // await fetchCategories(context);

  // load colaborators
  await fetchColaborators(context);

  // load clients
  await fetchClientes(context);

  // produtos
  await fetchProdutos(context);
}

novaVendaDialog(BuildContext context) {
  final maxWidth = MediaQuery.of(context).size.width;
  
  showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text('Nova venda'),
        content: SizedBox(
          width: maxWidth / 3,
          child: VendasForm()
        ),
      );
    }
  );
}

enum ShowingCategoryMenu {
  create,
  read,
  update,
  delete,
}

novaCategoriaDialog(BuildContext context, CategoryProvider model) {

  final maxWidth = MediaQuery.of(context).size.width;
  final maxHeight = MediaQuery.of(context).size.height;

  ShowingCategoryMenu showingCategoryMenu = ShowingCategoryMenu.read;

  final _scrollController = ScrollController();

  showDialog(
    context: context, 
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gerenciar categorias'),
                    OutlinedButton(
                      onPressed: () {
                        setState((){
                          showingCategoryMenu = showingCategoryMenu == ShowingCategoryMenu.create ? ShowingCategoryMenu.read : ShowingCategoryMenu.create;
                        });
                      },
                      child: Row(
                        spacing: 7,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            showingCategoryMenu == ShowingCategoryMenu.create ? Icons.close : Icons.add_circle_outline,
                            size: 18,
                          ),
                          const Text('Nova categoria'),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                Visibility(
                  visible: showingCategoryMenu == ShowingCategoryMenu.read,
                  child: TextField(
                    autofocus: false,
                    decoration: const InputDecoration(
                      labelText: 'Pesquisar categoria',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                )
              ],
            ),
            content: SizedBox(
              width: maxWidth / 3,
              height: maxHeight / 3,
              child: Scrollbar(
                controller: _scrollController,
                interactive: true,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        switchInCurve: Curves.easeIn,
                        switchOutCurve: Curves.easeOut,
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: showingCategoryMenu == ShowingCategoryMenu.create
                            ? CategoryForm(key: ValueKey<int>(1))
                            : Container(key: ValueKey<int>(2)),
                      ),
                      Visibility(
                        visible: showingCategoryMenu == ShowingCategoryMenu.read,
                        child: SizedBox(
                          width: maxWidth,
                          child: showCategoriesTable(context)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      );
    }
  );
}


Widget showCategoriesTable(BuildContext context) {
  return Consumer<CategoryProvider>(
    builder: (context, model, child) {
      return Visibility(
        visible: !model.isLoading,
        replacement: const Center(child: Text("Obtendo dados, aguarde...")),
        child: Visibility(
          visible: model.categories.length != 0,
          replacement: const Text("Nenhuma categoria cadastrada."),
          child: DataTable(
              columns: const [
                DataColumn(label: Text('Título')),
                DataColumn(label: Text('Ações')),
              ], 
              rows: model.categories.map((category) {
                return DataRow(
                  cells: [
                    DataCell(Text(category.name!)),
                    DataCell(
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context)  {
                         return [
                          const PopupMenuItem(
                            child:Center(
                              child: Icon(Icons.edit))
                          ),
                          const PopupMenuItem(
                            child: Center(
                              child: Icon(Icons.delete)),
                          ),
                         ];
                      },
                    ),
                    ),
                  ],
                );
              }).toList()
          ),
        ),
      );
    }
  );
}