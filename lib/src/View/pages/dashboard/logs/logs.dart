import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:racoon_tech_panel/src/View/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/sales_logs_table.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {

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
      children: [
              Text('Logs de vendas deletadas', style: Theme.of(context).textTheme.headlineMedium),
              const Gap(10),
              SalesLogs()
            ],
          ),
        ],
      ),
    );
  }
}