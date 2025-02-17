import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/Model/sales_response_dto.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/vendas/components/vendas_form.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/clientes_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/colaborators_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/produtos_functions.dart';
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

novaCategoriaDialog(BuildContext context) {
  final maxWidth = MediaQuery.of(context).size.width;
  
  showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text('Nova categoria'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: maxWidth / 3,
              child: CategoryForm(),
            ),
          ],
        ),
      );
    }
  );
}