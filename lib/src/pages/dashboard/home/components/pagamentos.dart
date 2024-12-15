import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Pagamentos extends StatelessWidget {
  const Pagamentos({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           Text("Pagamentos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
           table(),
          Gap(50),

         ],
       )
    );
  }
}

Widget table() {
  final List<Map<String, dynamic>> payments = [
      {"titulo": "Pagamento 1", "valor": 150.00},
      {"titulo": "Pagamento 2", "valor": 200.50},
      {"titulo": "Pagamento 3", "valor": 75.25},
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
              DataCell(Text("R\$ ${payment['valor'].toStringAsFixed(2)}")),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Lógica para editar
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Lógica para excluir
                    },
                  ),
                ],
              )),
            ],
          );
        }).toList(),
      ),
    );

}