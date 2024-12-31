import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Problems extends StatelessWidget {
  const Problems({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           const Text("Despesas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
           table(),
          const Gap(50),

         ],
       )
    );
  }
}

Widget table() {
  final List<Map<String, dynamic>> payments = [
      {"titulo": "Problema 1", "valor": -150.00},
      {"titulo": "Problema 2", "valor": -200.50},
      {"titulo": "Problema 3", "valor": -75.25},
    ];
return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Título')),
          DataColumn(label: Text('Total')),
          DataColumn(label: Text('Ações')),
        ],
        rows: payments.map((payment) {
          return DataRow(
            cells: [
              DataCell(Text(payment['titulo'])),
              DataCell(Text("R\$ ${payment['valor'].toStringAsFixed(2)}")),
              DataCell(
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context)  {
                   return [
                    const PopupMenuItem(
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