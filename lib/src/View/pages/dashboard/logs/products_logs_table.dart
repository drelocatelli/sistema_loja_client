import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/produtos_response_dto%20copy.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/components/fake_cells%20.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/components/logs_pagination.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/components/scroll_prepare.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/fetch/fetch_logs.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ProductProvider.dart';
import '../estoque/components/product_table.dart';

class ProductsLogsTable extends StatefulWidget {
  ProductsLogsTable({super.key, int this.pageSize = 1});

  int? pageSize = 4;

  @override
  State<ProductsLogsTable> createState() => _ProductsLogsTableState();
}

class _ProductsLogsTableState extends State<ProductsLogsTable> {

  late Future<ProdutosResponseDTO?> _future;
  late ProdutoProvider? model;
  int pageNum = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _future = fetchProducts(context, pageNum: pageNum, isDeleted: true);
      model = Provider.of<ProdutoProvider>(context, listen: false);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final columns = produtosColumns(model!);

    return Consumer<ProdutoProvider>(
      builder: (context, model, child) {
          return FutureBuilder<ProdutosResponseDTO?>(
            future: _future,
            builder: (context, snapshot) {
              if(snapshot.hasError) return Text("Ocorreu um erro ao obter dados");
          
              switch(snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return DataTable(
                    columns: columns,
                    rows: List.generate(widget.pageSize!, (index) => DataRow(cells: fakeCells(columns.length)))
                  );
          
                case ConnectionState.done:
                  return Column(
                    children: [
                       Visibility(
                        visible: snapshot.data?.produtos.isNotEmpty ?? false,
                        replacement: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              children: [
                                Text("Nenhum dado encontrado"),
                              ],
                            ),
                          )
                        ),
                      child: Column(
                        children: [
                          scrollPrepare(child: productTable(produtos: snapshot.data?.produtos ?? [], showSelection: false, showActions: false)),
                          LogsPagination(model: model, isNotEmpty: model.produtos.isNotEmpty,  fetchCb: () {
                          _future = fetchProducts(context, pageNum: model.currentPage);
                          })
                        ],
                      ),
                      )
                    ],
                  );
                case ConnectionState.active:
                  throw UnimplementedError();
              }
          }
        );
      }
    );
  }
}