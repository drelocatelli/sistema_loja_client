import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/dto/response_dto.dart';
import 'package:racoon_tech_panel/src/dto/sales_response_dto.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/vendas/components/vendas_form.dart';
import 'package:racoon_tech_panel/src/providers/SalesProvider.dart';
import 'package:racoon_tech_panel/src/repository/SaleRepository.dart';

Future reloadVendas(BuildContext context) async {
  final model = Provider.of<SalesProvider>(context, listen: false);
  model.setIsReloading(true);
  ResponseDTO<SalesResponseDTO> vendasList = await SaleRepository.get(page: 1);
  final newData = vendasList.data?.sales ?? []; 
  model.setSales(newData);
  await Future.delayed(Duration(milliseconds: 1500));
  model.setIsReloading(false);
}

Future loadVendas(BuildContext context) async {
  final model = Provider.of<SalesProvider>(context, listen: false);
  ResponseDTO<SalesResponseDTO> vendasList = await SaleRepository.get(page: 1);
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