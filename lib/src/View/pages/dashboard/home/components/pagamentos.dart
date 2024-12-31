import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Pagamentos extends StatelessWidget {
  const Pagamentos({super.key});


  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    return Container(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text("Saída", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
             ],
           ),
           table(maxWidth),
          const Gap(50),

         ],
       )
    );
  }
}

Widget table(maxWidth) {
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
              DataCell(SizedBox(width: 80, child: Text("R\$ ${payment['valor'].toStringAsFixed(2)}"))),
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
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );

}
