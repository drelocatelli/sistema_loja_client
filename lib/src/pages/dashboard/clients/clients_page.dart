import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/dto/cliente_dto.dart';
import 'package:racoon_tech_panel/src/helpers.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});


  @override
  Widget build(BuildContext context) {

  final maxWidth = MediaQuery.of(context).size.width;  

    return MainLayout(
      child: SelectionArea(
        child: SizedBox(
          width: maxWidth,
          child: clientsTable(maxWidth),
        ),
      ),
    );
  }
}

clientsTable(maxWidth) {
  List<Cliente> clientes = [
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

  // sort by name
  clientes.sort((a, b) => a.nome.compareTo(b.nome));

  int _sortColumnIdx = 0;
  bool _isAscending = true;
  List<bool> selected = List<bool>.generate(clientes.length, (int index) => false);

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Helpers.rowOrWrap(
            wrap: maxWidth <= 800,
            children: [
              Text("Clientes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Align(alignment: Alignment.topRight, child: _pesquisa(maxWidth)),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Visibility(
              visible: selected.contains(true),
              child: OutlinedButton(
                onPressed: () {
                  // get all selection ids
                  List<int> selectedIds = selected.asMap().entries
                    .where((entry) => entry.value == true)
                    .map((entry) => entry.key)
                    .toList();
                  
                  // get selected clients
                  List<Cliente?> selectedClients = List.generate(clientes.length, (index) => 
                      selectedIds.contains(index) ? clientes[index] : null).where((item) => item != null)
                    .toList();

                  List filteredClientesTitle = selectedClients.map((cliente) => cliente?.nome).toList();

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Deseja excluir os clientes?'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Esta ação não poderá ser desfeita.'),
                            Text('Tem certeza que deseja excluir?'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text('Cancelar'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: Text('Excluir'),
                            onPressed: () {
                              setState(() {
                                clientes.removeWhere((cliente) => selectedIds.contains(clientes.indexOf(cliente)));
                                selected = List<bool>.generate(clientes.length, (int index) => false);
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                  
                }, 
                child: Text('Excluir selecionados'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color.fromRGBO(220, 64, 38, 1)),
                  backgroundColor: (const Color.fromRGBO(250, 242, 241, 1)),
                  foregroundColor: (const Color.fromRGBO(220, 64, 38, 1))
                ),
              ),
            ),
          ),
          Visibility(
            visible: clientes.isNotEmpty,
            replacement: Center(child: Text('Nenhum cliente cadastrado')),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FittedBox(
                  fit: SharedTheme.isLargeScreen(context) ? BoxFit.scaleDown : BoxFit.fitWidth,
                  child: SizedBox(
                    width: maxWidth,
                    child: DataTable(
                      sortColumnIndex: _sortColumnIdx,
                      sortAscending: _isAscending,
                      showCheckboxColumn: true,
                      dividerThickness: 2,
                      dataTextStyle: TextStyle(fontSize: maxWidth <= 800 ? 12 : null),
                      columns: [
                        DataColumn(
                          label: Text('Nome'),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIdx = columnIndex;
                              _isAscending = ascending;
                              clientes.sort((a, b) => _isAscending ? a.nome.compareTo(b.nome) : b.nome.compareTo(a.nome));
                            });
                          }
                        ),
                        DataColumn(
                          label: Text('Email'),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIdx = columnIndex;
                              _isAscending = ascending;
                              clientes.sort((a, b) => _isAscending ? a.email.compareTo(b.email) : b.email.compareTo(a.email));
                            });
                          }
                        ),
                        DataColumn(
                          label: Text('Ações'),
                        ),
                      ],
                      rows: clientes.asMap().entries.map((entry) {
                        final cliente = entry.value;
                        final index = entry.key;
                        return DataRow(
                          selected: selected[index],
                          onSelectChanged: (bool? value) {
                            selected[index] = value!;
                            setState(() {});
                          },
                          cells: [
                          DataCell(Text(cliente.nome)),
                          DataCell(
                            Tooltip(message:cliente.email, child: SizedBox(width: maxWidth <= 800 ? 80 : null, child: Text(cliente.email, softWrap: true, overflow: TextOverflow.ellipsis)))
                          ),
                          DataCell(Row(
                            children: [
                              Visibility(
                                visible: maxWidth >= 800,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, size: maxWidth <= 800 ? 20 : null),
                                      onPressed: () {
                                        Cliente newCliente = _editCliente(context, cliente);
                                        setState(() {
                                          clientes[index] = newCliente;
                                        });
                                        print('edit cliente ${cliente.nome}');
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, size: maxWidth <= 800 ? 20 : null),
                                      onPressed: () {
                                        setState(() {
                                            selected = selected.map((item) => false).toList();
                                          });
                                        _deletePopup(context, () {
                                          clientes = _deleteCliente(context, clientes, index);
                                          setState(() {});
                                        }, cliente.nome);
                                        print('delete cliente ${cliente.nome}');
                                      },
                                    ),
                                  ]
                                  ),
                                  replacement: PopupMenuButton(
                                  icon: Icon(Icons.more_vert, size: maxWidth <= 800 ? 28 : null),
                                  itemBuilder: (BuildContext context) {
                                    return [
                                     PopupMenuItem(
                                      child: Center(child: Icon(Icons.edit)),
                                      onTap: () {
                                        Cliente newCliente = _editCliente(context, cliente);
                                        setState(() {
                                          clientes[index] = newCliente;
                                        });
                                        print('edit cliente ${newCliente.nome}');
                                      }
                                     ),
                                      PopupMenuItem(
                                        child: Center(child: Icon(Icons.delete)),
                                        onTap: () {
                                          setState(() {
                                            selected = selected.map((item) => false).toList();
                                          });
                                          _deletePopup(context, () {
                                          clientes = _deleteCliente(context, clientes, index);
                                          setState(() {});
                                        }, cliente.nome);
                                          print('delete cliente ${cliente.nome}');
                                        }
                                      ),
                                    ]; 
                                  } 
                                ),
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  );
}

Widget _pesquisa(double maxWidth) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: SizedBox(
      width: maxWidth >= 800 ? 400 : null,
      child: TextFormField(
       decoration: InputDecoration(
          hintText: 'Digite sua busca',
          border: OutlineInputBorder(), 
          suffixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          isDense: true
        ),
      ),
    ),
  );
}

_deletePopup(BuildContext context, deleteCb, clienteNome) {
  showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: Text('Deseja realmente excluir o cliente ${clienteNome}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, 
            child: Text('Cancelar')
          ),
          TextButton(
            onPressed: () {
                deleteCb();
                Navigator.of(context).pop();
            }, 
            child: Text('Excluir')
          ),
        ]
      );
    }
  );
}

List<Cliente> _deleteCliente(BuildContext context, List<Cliente> clientes, int indexToRemove) {
  clientes.removeAt(indexToRemove);
  
  
  return clientes;
}

Cliente _editCliente(BuildContext context, Cliente cliente) {
  print('edit cliente');

  return cliente;
}
