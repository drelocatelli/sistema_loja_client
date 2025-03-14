import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/response_dto.dart';
import 'package:racoon_tech_panel/src/Model/sales_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/vendas_dto.dart';
import 'package:racoon_tech_panel/src/View/components/shimmer_cell.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/components/scroll_prepare.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/vendas/components/vendas_table.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/SalesProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/SaleRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';
import 'package:shimmer/shimmer.dart';


class SalesLogs extends StatefulWidget {
  const SalesLogs({super.key});

  @override
  State<SalesLogs> createState() => _SalesLogsState();
}

class _SalesLogsState extends State<SalesLogs> {

  final pageSize = 4;
  
  Future _fetchSales({int? pageNum = 1}) async {
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
  Widget salesTable() {
      final model = Provider.of<SalesProvider>(context, listen: true);
      List<Venda> salesDeleted = model.salesDeleted;
      
      final columns = salesColumns(model);

      final fakeCells = List.generate(columns.length, (index) => DataCell(
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ShimmerCell(width: 120)
        )
      ));
      
      return  Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          scrollPrepare(
            child: Visibility(
              visible: model.isLoading,
              child: DataTable(
                columns: columns, 
                rows: List.generate(pageSize, (index) => DataRow(cells: fakeCells))
              ),
              replacement: Visibility(
                visible: salesDeleted.isEmpty,
                child: const Text("Nenhuma venda deletada."),
                replacement: DataTable(
                    columns: columns,
                    rows: salesRows(model, salesDeleted)
                  ),
              ),
            ),
          ),
          salesPagination(),
        ],
      );
  }

  Widget salesPagination() {
    return Consumer<SalesProvider>(
      builder: (context, model, child) {
        return Visibility(
          visible: model.salesDeleted.isNotEmpty,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(model.totalPages, (idx) {
                final page =  idx + 1;
                return TextButton(
                  onPressed: () async {
                    if(model.currentPage == page) return;
                    await _fetchSales(pageNum: page);
                  },
                  child: Text(page.toString(), style: TextStyle(color: (model.currentPage == page) ? SharedTheme.primaryColor : null)),
                );
              })
            ),
          ),
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return salesTable();
  }
}