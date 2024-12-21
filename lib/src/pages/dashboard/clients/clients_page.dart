import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/dto/cliente_dto.dart';
import 'package:racoon_tech_panel/src/dto/response_dto.dart';
import 'package:racoon_tech_panel/src/helpers.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/repository/ClientRepository.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<Cliente> clientes = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchData();
      setState(() {
        _isLoading = false;
      });
    });
    
  }

  Future<void> fetchData() async {
    ResponseDTO<List<Cliente>> clientesList = await ClientRepository.getClients();
    setState(() {
      clientes = clientesList.data ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {

  final maxWidth = MediaQuery.of(context).size.width;  

    return MainLayout(
      isLoading: _isLoading,
      child: SelectionArea(
        child: SizedBox(
          width: maxWidth,
          child:clientsTable(clientes, maxWidth),
        ),
      ),
    );
  }
}

clientsTable(List<Cliente> clientes, maxWidth) {

  // sort by name
  clientes.sort((a, b) => a.name.compareTo(b.name));

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

                  List filteredClientesTitle = selectedClients.map((cliente) => cliente?.name).toList();

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
                              clientes.sort((a, b) => _isAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
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
                          DataCell(Text(cliente.name)),
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
                                        print('edit cliente ${cliente.name}');
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
                                        }, cliente.name);
                                        print('delete cliente ${cliente.name}');
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
                                        print('edit cliente ${newCliente.name}');
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
                                        }, cliente.name);
                                          print('delete cliente ${cliente.name}');
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
