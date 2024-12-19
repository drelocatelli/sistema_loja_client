import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/vendas/vendas_page.dart';

class Recebimentos extends StatelessWidget {
  const Recebimentos({super.key});

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    
    return Container(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           Text("Receitas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
           table(maxWidth),
            Gap(50),
         ],
       )
    );
  }
}

Widget table(maxWidth) {
  final List<Map<String, dynamic>> payments = [
      {"titulo": "Recebimento 1", "valor": 150.00},
      {"titulo": "Recebimento 2", "valor": 200.50},
      {"titulo": "Recebimento 3", "valor": 75.25},
    ];
return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Título')),
          DataColumn(label: Text('Valor')),
          DataColumn(label: Text('Ações')),
        ],
        rows: payments.map((payment) {
          return DataRow(
            cells: [
              DataCell(Text(payment['titulo'])),
              DataCell(SizedBox(width: 80, child: Text("R\$ ${payment['valor'].toStringAsFixed(2)}"))),
              DataCell(
                PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context)  {
                   return [
                    PopupMenuItem(
                      child: Text("Mais detalhes")
                    ),
                   ];
                },
                                )
              ),
            ],
          );
        }).toList(),
      ),
    );
}