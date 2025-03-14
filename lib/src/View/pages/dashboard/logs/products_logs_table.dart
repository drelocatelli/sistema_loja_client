import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/product_dto.dart';
import 'package:racoon_tech_panel/src/Model/produtos_response_dto%20copy.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/components/scroll_prepare.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ProductProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/ProdutosRepository.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Model/response_dto.dart';
import '../../../components/shimmer_cell.dart';
import '../estoque/components/product_table.dart';

class ProductsLogsTable extends StatefulWidget {
  const ProductsLogsTable({super.key});

  @override
  State<ProductsLogsTable> createState() => _ProductsLogsTableState();
}

class _ProductsLogsTableState extends State<ProductsLogsTable> {
  final pageSize = 4;

  Future _fetch({int? pageNum = 1}) async {
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

  Widget table() {
    final model = Provider.of<ProdutoProvider>(context, listen: true);
    List<Produto> productsDeleted = model.produtosDeleted;

    final columns = produtosColumns(model);

    final fakeCells = List.generate(columns.length, (index) => DataCell(
      Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ShimmerCell(width: 120)
          ),
    ));

    return Column(
      children: [
        scrollPrepare(
          child: Visibility(
            visible: model.isLoading,
            child: DataTable(
              columns: columns,
              rows: List.generate(pageSize, (index) => DataRow(cells: fakeCells))
            ),
            replacement: Visibility(
              visible: productsDeleted.isEmpty,
              child: const Text("Nenhum produto deletado."),
              replacement: DataTable(columns: columns, 
              rows: productsRows(model, productsDeleted),
            ),
            
            )
          )
        )
      ]
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return table();
  }
}