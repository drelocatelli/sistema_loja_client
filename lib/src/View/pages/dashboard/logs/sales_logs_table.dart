import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/sales_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/vendas_dto.dart';
import 'package:racoon_tech_panel/src/View/components/shimmer_cell.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/components/fake_cells%20.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/components/logs_pagination.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/components/scroll_prepare.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/fetch/fetch_logs.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/vendas/components/vendas_table.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/SalesProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/SaleRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';
import 'package:shimmer/shimmer.dart';


class SalesLogs extends StatefulWidget {
  SalesLogs({super.key, this.pageSize});

  int? pageSize = 4;

  @override
  State<SalesLogs> createState() => _SalesLogsState();
}

class _SalesLogsState extends State<SalesLogs> {
  late Future<SalesResponseDTO?> _future;
  late SalesProvider? model;
  
  int pageNum = 1;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      model = Provider.of<SalesProvider>(context, listen: false);
      _future = fetchSales(context, pageNum: pageNum);
      setState(() {});
    });
  }
  
  @override
  Widget build(BuildContext context) {
      final columns = salesColumns(model!);
      
      return  Consumer<SalesProvider>(
        builder: (context, model, child) {
            return FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if(snapshot.hasError) return Text("Ocorreu um erro ao obter dados");
                    
                switch(snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return DataTable(
                      columns: columns,
                      rows: List.generate(widget.pageSize!, (index) => DataRow(cells: fakeCells(columns.length))
                    ));
                    
                    case ConnectionState.done:
                      return Column(
                        children: [
                          scrollPrepare(child: salesTable(vendas: snapshot.data?.sales ?? [])),
                          LogsPagination(model: model, isNotEmpty: model.salesDeleted.isNotEmpty, fetchCb: () async {
                            _future = fetchSales(context, pageNum: model.currentPage);
                          })
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