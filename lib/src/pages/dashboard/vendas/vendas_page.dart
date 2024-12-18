import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';

class Vendas extends StatefulWidget {
  const Vendas({super.key});

  @override
  State<Vendas> createState() => _VenddasState();
}

class _VenddasState extends State<Vendas> {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SelectionArea(
        child: Column(
          children: [
            Text('Gerenciar vendas', style: Theme.of(context).textTheme.headlineMedium),
            // _vendasTable()
          ],
        )
      ),
    );
  }
}

// Widget _vendasTable() {

// }