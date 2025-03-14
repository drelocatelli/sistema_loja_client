import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ProductProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/ProdutosRepository.dart';

import '../../../../../Model/produtos_response_dto copy.dart';
import '../../../../../Model/sales_response_dto.dart';
import '../../../../../ViewModel/providers/SalesProvider.dart';
import '../../../../../ViewModel/repository/SaleRepository.dart';

Future fetchSales(BuildContext context, {int? pageNum = 1, int pageSize = 4}) async {
  final model = Provider.of<SalesProvider>(context, listen: false);
  model.setIsLoading(true);


  await Future.delayed(Duration(milliseconds: 1000));
  ResponseDTO<SalesResponseDTO> vendasList = await SaleRepository.get(pageNum: pageNum, pageSize: pageSize, isDeleted: true);
  final newData = vendasList.data?.sales ?? [];

  model.setTotalPages(vendasList.data?.pagination?.totalPages ?? 1);
  model.setCurrentPage(vendasList.data?.pagination?.currentPage ?? 1);
  model.setSalesDeleted(newData);
  model.setIsLoading(false);
}

Future fetchProducts(BuildContext context, {int? pageNum = 1, int pageSize = 4}) async {
    final model = Provider.of<ProdutoProvider>(context, listen: false);
    model.setIsLoading(true);

    await Future.delayed(Duration(milliseconds: 1000));
    ResponseDTO<ProdutosResponseDTO> vendasList = await ProdutosRepository.get(pageNum: pageNum, pageSize: pageSize, isDeleted: true);
    final newData = vendasList.data?.produtos ?? [];

    model.setTotalPages(vendasList.data?.pagination?.totalPages ?? 1);
    model.setCurrentPage(vendasList.data?.pagination?.currentPage ?? 1);
    model.setProdutosDeleted(newData);
    model.setIsLoading(false);
  }