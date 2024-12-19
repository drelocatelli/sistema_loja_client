import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Pagamentos extends StatelessWidget {
  Pagamentos({super.key});


  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    return Container(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text("Pagamentos previstos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Tooltip(
                message: "Adicionar pagamentos previstos",
                child: ElevatedButton(
                  onPressed: () {
                    _showAddDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Forma circular
                  ),
                  child: Icon(Icons.add),
                ),
              ),
             ],
           ),
           table(maxWidth),
          Gap(50),

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
                Visibility(
                  visible: maxWidth >= 800,
                  child: Row(
                    children: _editAndDeleteIco(maxWidth),
                  ),
                  replacement: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context)  {
                     final popupItems = _editAndDeleteIco(maxWidth).map((item) => PopupMenuItem(child: Center(child: item,), onTap: () { item.onPressed!(); })).toList();
                      return popupItems;
                  },
                  ),
                )
              ),
            ],
          );
        }).toList(),
      ),
    );

}

List<IconButton> _editAndDeleteIco( maxWidth) {
  List<IconButton> items = [
    IconButton(
      icon: Icon(Icons.edit, size: maxWidth <= 800 ? 20 : null),
      onPressed: () {
      },
    ),
    IconButton(
      icon: Icon(Icons.delete, size: maxWidth <= 800 ? 20 : null),
      onPressed: () {
      },
    ),
  ];

  return items;
}


_showAddDialog(BuildContext context) {
  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Adicionar pagamentos previstos'),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Título',
                  ),
                ),
                TextFormField(
                  controller: TextEditingController(text: '0.00'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    prefixText: 'R\$ ',
                    labelText: 'Valor',
                  ),
                ),
                Gap(10),
                ElevatedButton(
                  onPressed: () {}, 
                  child: Text('Adicionar pagamentos previstos')
                )
              ],
            ),
          )
        ],
      )
    )
  );
}