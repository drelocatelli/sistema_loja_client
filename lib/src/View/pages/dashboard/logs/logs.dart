import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:racoon_tech_panel/src/View/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/products_logs_table.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/sales_logs_table.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {

  final pageSize = 4;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isLoading: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 40,
      children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('Histórico de vendas', style: Theme.of(context).textTheme.headlineMedium),
                    Gap(10),
                    ExpansionTile(
                      onExpansionChanged: (bool expanded) async {
                        if(!expanded) return;
                      },
                      title: Text("Vendas canceladas"),
                      children: [
                        SalesLogs(pageSize: pageSize)
                      ]
                    ),
                ],
            ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Histórico de produtos', style: Theme.of(context).textTheme.headlineMedium),
                  const Gap(10),
                  ExpansionTile(
                    title: Text("Produtos cancelados"),
                    onExpansionChanged: (bool expanded) async {
                      if(!expanded) return;
                    },
                    children: [
                      ProductsLogsTable(pageSize: pageSize)
                    ]
                  )
                ],
                  
              )
            ],
          ),
        ],
      ),
    );
  }
}