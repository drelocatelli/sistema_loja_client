import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/sales_response_dto.dart';
import 'package:racoon_tech_panel/src/Model/vendas_dto.dart';
import 'package:racoon_tech_panel/src/View/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/vendas/components/vendas_table.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/vendas_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/SalesProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/SaleRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';

import '../../../../Model/response_dto.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchSales();
    });
  }

  Future _fetchSales() async {
    final model = Provider.of<SalesProvider>(context, listen: false);
    model.setIsLoading(true);

    ResponseDTO<SalesResponseDTO> vendasList = await SaleRepository.get(pageNum: 1, isDeleted: true);
    final newData = vendasList.data?.sales ?? [];

    model.setSalesDeleted(newData);
    await Future.delayed(Duration(milliseconds: 500));

    model.setIsLoading(false);
  }
  
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isLoading: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _sales(),
        ],
      ),
    );
  }

  Widget scrollPrepare({required Widget child}) {
    final _horizontalController = ScrollController();
    final _verticalScrollController = ScrollController();
    bool _isHorizontalThumbShowing = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Scrollbar(
          interactive: true,
          controller: _horizontalController,
          trackVisibility: false,
          thumbVisibility: _isHorizontalThumbShowing,
          child: SingleChildScrollView(
            controller: _horizontalController,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Scrollbar(
              interactive: true,
              controller: _verticalScrollController,
              trackVisibility: true,
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _verticalScrollController,
                physics: const BouncingScrollPhysics(),
                child: MouseRegion(
                  onHover: (event) => setState(() => _isHorizontalThumbShowing = true),
                  onExit: (event) => setState(() => _isHorizontalThumbShowing = false),
                  child: FittedBox(
                    fit: SharedTheme.isLargeScreen(context) ? BoxFit.scaleDown : BoxFit.fitWidth,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _sales() {
    final model = Provider.of<SalesProvider>(context, listen: true);
    List<Venda> salesDeleted = model.salesDeleted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Logs de vendas deletadas', style: Theme.of(context).textTheme.headlineMedium),
        const Gap(10),
        Visibility(
          visible: !model.isLoading,
          replacement: Text("Carregando logs vendas, aguarde..."),
          child: Visibility(
            visible: salesDeleted.isNotEmpty,
            replacement: Text("Nenhuma venda foi deletada."),
            child: scrollPrepare(
              child: DataTable(
                    columns: salesColumns(model),
                    rows: salesRows(model, salesDeleted)
                  ),
            ),
          ),
        )
      ],
    );
  }
}