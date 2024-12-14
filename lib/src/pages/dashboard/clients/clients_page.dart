import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});


  @override
  Widget build(BuildContext context) {

  final maxWidth = MediaQuery.of(context).size.width;  

    return MainLayout(
      padding: EdgeInsets.all(0),
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text("Clientes",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            clientsTable(maxWidth)
            // clientsTable(maxWidth),
          ],
        ),
      ),
    );
  }
}

class Cliente {
  final String nome;
  final String email;
  final String performance;

  Cliente({required this.nome, required this.email, required this.performance});
}

clientsTable(maxWidth) {

  final List<Cliente> clientes = [
    Cliente(nome: 'Carlos Pereira', email: 'carlos@example.com', performance: 'Regular'),
    Cliente(nome: 'Ana Souza', email: 'ana@example.com', performance: 'Excelente'),
    Cliente(nome: 'João Silva', email: 'joao@example.com', performance: 'Bom'),
    Cliente(nome: 'Maria Oliveira', email: 'maria@example.com', performance: 'Regular'),
    Cliente(nome: 'José Almeida', email: 'jose@example.com', performance: 'Ruim'),
    Cliente(nome: 'Luana Costa', email: 'luana@example.com', performance: 'Bom'),
    Cliente(nome: 'Pedro Santos', email: 'pedro@example.com', performance: 'Excelente'),
    Cliente(nome: 'Fernanda Lima', email: 'fernanda@example.com', performance: 'Regular'),
    Cliente(nome: 'Ricardo Martins', email: 'ricardo@example.com', performance: 'Bom'),
    Cliente(nome: 'Patrícia Rocha', email: 'patricia@example.com', performance: 'Excelente'),
    Cliente(nome: 'Felipe Gomes', email: 'felipe@example.com', performance: 'Regular'),
    Cliente(nome: 'Paula Pereira', email: 'paula@example.com', performance: 'Bom'),
    Cliente(nome: 'Lucas Fernandes', email: 'lucas@example.com', performance: 'Excelente'),
    Cliente(nome: 'Bruna Silva', email: 'bruna@example.com', performance: 'Ruim'),
    Cliente(nome: 'Rafael Costa', email: 'rafael@example.com', performance: 'Bom'),
    Cliente(nome: 'Carla Souza', email: 'carla@example.com', performance: 'Excelente'),
    Cliente(nome: 'Tiago Santos', email: 'tiago@example.com', performance: 'Regular'),
    Cliente(nome: 'Sabrina Almeida', email: 'sabrina@example.com', performance: 'Bom'),
    Cliente(nome: 'Vinícius Rocha', email: 'vinicius@example.com', performance: 'Excelente'),
    Cliente(nome: 'Cláudia Lima', email: 'claudia@example.com', performance: 'Regular'),
    Cliente(nome: 'André Martins', email: 'andre@example.com', performance: 'Bom'),
    Cliente(nome: 'Juliana Costa', email: 'juliana@example.com', performance: 'Excelente'),
    Cliente(nome: 'Eduardo Pereira', email: 'eduardo@example.com', performance: 'Regular'),
    Cliente(nome: 'Isabela Gomes', email: 'isabela@example.com', performance: 'Bom'),
    Cliente(nome: 'Gabriel Silva', email: 'gabriel@example.com', performance: 'Excelente'),
    Cliente(nome: 'Amanda Rocha', email: 'amanda@example.com', performance: 'Regular'),
    Cliente(nome: 'Matheus Lima', email: 'matheus@example.com', performance: 'Bom'),
    Cliente(nome: 'Mariana Santos', email: 'mariana@example.com', performance: 'Excelente'),
    Cliente(nome: 'Ricardo Oliveira', email: 'ricardo.oliveira@example.com', performance: 'Regular'),
    Cliente(nome: 'Beatriz Almeida', email: 'beatriz@example.com', performance: 'Bom'),
    Cliente(nome: 'Júlio Costa', email: 'julio@example.com', performance: 'Excelente'),
    Cliente(nome: 'Natália Pereira', email: 'natalia@example.com', performance: 'Regular'),
    Cliente(nome: 'Joana Fernandes', email: 'joana@example.com', performance: 'Bom'),
    Cliente(nome: 'Thiago Martins', email: 'thiago@example.com', performance: 'Excelente'),
    Cliente(nome: 'Marcelo Rocha', email: 'marcelo@example.com', performance: 'Regular'),
    Cliente(nome: 'Juliana Gomes', email: 'juliana.gomes@example.com', performance: 'Bom'),
    Cliente(nome: 'Carlos Almeida', email: 'carlos.almeida@example.com', performance: 'Excelente'),
    Cliente(nome: 'Larissa Santos', email: 'larissa.santos@example.com', performance: 'Regular'),
    Cliente(nome: 'Fábio Silva', email: 'fabio.silva@example.com', performance: 'Bom'),
    Cliente(nome: 'Gabriela Pereira', email: 'gabriela@example.com', performance: 'Excelente'),
    Cliente(nome: 'Felipe Rocha', email: 'felipe.rocha@example.com', performance: 'Regular'),
    Cliente(nome: 'Maria Clara', email: 'mariaclara@example.com', performance: 'Bom'),
    Cliente(nome: 'Daniel Souza', email: 'daniel@example.com', performance: 'Excelente'),
    Cliente(nome: 'Rogério Lima', email: 'rogerio@example.com', performance: 'Regular'),
    Cliente(nome: 'Luiz Martins', email: 'luiz@example.com', performance: 'Bom'),
    Cliente(nome: 'Roberta Costa', email: 'roberta@example.com', performance: 'Excelente'),
    Cliente(nome: 'Carlos Costa', email: 'carlos.costa@example.com', performance: 'Regular'),
    Cliente(nome: 'Larissa Rocha', email: 'larissa.rocha@example.com', performance: 'Bom'),
    Cliente(nome: 'Eduarda Almeida', email: 'eduarda@example.com', performance: 'Excelente'),
    Cliente(nome: 'André Souza', email: 'andre.souza@example.com', performance: 'Regular'),
    Cliente(nome: 'Sandra Pereira', email: 'sandra@example.com', performance: 'Bom'),
    Cliente(nome: 'Ricardo Lima', email: 'ricardolima@example.com', performance: 'Excelente')

  ];

  return DataTable(
    showCheckboxColumn: false,
    headingRowHeight: 32.0,
    dataRowHeight: 60.0,
    columns: [
      DataColumn(label: Text('Nome')),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('Ações')),
    ],
    rows: clientes.map((cliente) {
      return DataRow(cells: [
        DataCell(Text(cliente.nome)),
        DataCell(
          Tooltip(message:cliente.email, child: SizedBox(width: maxWidth <= 800 ? 80 : null, child: Text(cliente.email, softWrap: true, overflow: TextOverflow.ellipsis)))
        ),
        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Ação para editar o cliente
                print('Editando: ${cliente.nome}');
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Ação para excluir o cliente
                print('Excluindo: ${cliente.nome}');
              },
            ),
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                // Ação para ver mais detalhes
                print('Mais detalhes de: ${cliente.nome}');
              },
            ),
          ],
        )),
      ]);
    }).toList(),
  );
}
