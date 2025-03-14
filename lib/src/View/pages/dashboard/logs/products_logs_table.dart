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
  ProductsLogsTable({super.key, int this.pageSize = 1, required this.products});

  int? pageSize = 4;
  List<Produto> products;

  @override
  State<ProductsLogsTable> createState() => _ProductsLogsTableState();
}

class _ProductsLogsTableState extends State<ProductsLogsTable> {

  Widget table() {
    final model = Provider.of<ProdutoProvider>(context, listen: true);
    List<Produto> products = widget.products;

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
              rows: List.generate(widget.pageSize!, (index) => DataRow(cells: fakeCells))
            ),
            replacement: Visibility(
              visible: products.isEmpty,
              child: const Text("Nenhum produto deletado."),
              replacement: DataTable(columns: columns, 
              rows: productsRows(model, products),
            ),
            
            )
          )
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return table();
  }
}