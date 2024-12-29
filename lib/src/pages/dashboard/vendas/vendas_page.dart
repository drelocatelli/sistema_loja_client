import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/helpers.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/vendas/components/vendas_search.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/vendas/components/vendas_table.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/vendas/components/vendas_title.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';

class VendasPage extends StatefulWidget {
  const VendasPage({super.key});

  @override
  State<VendasPage> createState() => _VenddasState();
}

class _VenddasState extends State<VendasPage> {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SelectionArea(
        child: Column(
          children: [
            Helpers.rowOrWrap(
              wrap: !SharedTheme.isLargeScreen(context),
              children: [
                VendasTitle(),
                VendasSearch(),
                VendasTable(),
              ]
            )
          ],
        )
      ),
    );
  }
}
