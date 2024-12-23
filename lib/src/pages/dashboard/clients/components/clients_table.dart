import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:racoon_tech_panel/src/components/refresh_component.dart';
import 'package:racoon_tech_panel/src/dto/cliente_dto.dart';
import 'package:racoon_tech_panel/src/helpers.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/clients/components/clients_details.dart';
import 'package:racoon_tech_panel/src/repository/ClientRepository.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';

clientsTable(List<Cliente> clientes, maxWidth, {required bool isReloading, required Function refreshFn}) {

  debugPrint(isReloading.toString());

  // sort by name
  clientes.sort((a, b) => a.name.compareTo(b.name));

  // get clients that doesnt deleted
  clientes = clientes.where((item) => item.deletedAt == null).toList();

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
              Row(
                children: [
                  Text("Clientes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => refreshFn(), icon: RefreshComponent(isLoading: isReloading)),
                ],
              ),
              Gap(10),
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
                            onPressed: () async {
                              for(int i = 0; i < selectedClients.length; i++) {
                                await ClientRepository.deleteClient(selectedClients[i]!.id);
                                refreshFn();
                              }
                              // setState(() {
                              //   clientes.removeWhere((cliente) => selectedIds.contains(clientes.indexOf(cliente)));
                              //   selected = List<bool>.generate(clientes.length, (int index) => false);
                              // });
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder:(Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: isReloading ? Center(child: Text("Buscando dados, aguarde...")) : Container(),
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
                          DataCell(Row(
                            children: [
                              Visibility(
                                visible: maxWidth >= 800,
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
                                        }, cliente.name, cliente.id, refreshFn);
                                          print('delete cliente ${cliente.name}');
                                        }
                                      ),
                                      PopupMenuItem(
                                        child: Center(child: Icon(Icons.more_horiz)),
                                        onTap: () {
                                          clientsDetails(context, cliente);
                                          print('delete cliente ${cliente.name}');
                                        }
                                      ),
                                    ]; 
                                  } 
                                ),
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
                                        }, cliente.name, cliente.id, refreshFn);
                                        print('delete cliente ${cliente.name}');
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () => clientsDetails(context, cliente), 
                                      icon: const Icon(Icons.more_horiz)
                                    )
                                  ]
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
       decoration: const InputDecoration(
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

_deletePopup(BuildContext context, deleteCb, clienteNome, String clienteId, Function refreshFn) {
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
            onPressed: () async {
              final deletedClients = await ClientRepository.deleteClient(clienteId);
              if(deletedClients.status != 200) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(deletedClients.message ?? 'Ocorreu um erro inesperado!'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              refreshFn();
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
