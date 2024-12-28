import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:gap/gap.dart';
import 'package:racoon_tech_panel/src/components/refresh_component.dart';
import 'package:racoon_tech_panel/src/dto/cliente_dto.dart';
import 'package:racoon_tech_panel/src/helpers.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/clients/components/clients_details.dart';
import 'package:racoon_tech_panel/src/repository/ClientRepository.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';

clientsTable(List<Cliente> clientes, maxWidth, {required bool isReloading, required Function refreshFn, required Widget search}) {

  // sort by name
  clientes.sort((a, b) => a.name.compareTo(b.name));

  // get clients that doesnt deleted
  clientes = clientes.where((item) => item.deletedAt == null).toList();

  int sortColumnIdx = 0;
  bool isAscending = true;
  List<bool> selected = List<bool>.generate(clientes.length, (int index) => false);
  bool _isDeletingLoad = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Helpers.rowOrWrap(
            wrap: !SharedTheme.isLargeScreen(context),
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Clientes",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Visibility(
                            visible: !SharedTheme.isLargeScreen(context),
                            child: InkWell(onTap: () => refreshFn(), child: RefreshComponent(isLoading: isReloading))
                          ),
                          const Gap(10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: SharedTheme.isLargeScreen(context) ? null : const EdgeInsets.all(3),
                            ),
                            onPressed: () {
                              _createClients(context, refreshFn);
                            },
                            child: SharedTheme.isLargeScreen(context) ? Text("Adicionar novo cliente") : Icon(Icons.add)
                          ),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: !SharedTheme.isLargeScreen(context), 
                    child:  search
                  )
                ],
              ),
              const Gap(10),
              Visibility(
                visible: SharedTheme.isLargeScreen(context),
                child: Align(alignment: Alignment.topLeft, child: search),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
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
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: const Text('Deseja excluir os clientes?'),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Esta ação não poderá ser desfeita.'),
                                Text('Tem certeza que deseja excluir?'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Cancelar'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Text(_isDeletingLoad ? 'Excluindo...' : 'Excluir'),
                                onPressed: () async {
                                  setState(() {
                                    _isDeletingLoad = true;
                                  });
                                  await Future.delayed(Duration(milliseconds: 2000));
                                  await _deleteClientes(context, clientes, selectedClients.map((item) => item!.id).toList(), refreshFn);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }
                      );
                    },
                  );
                  
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color.fromRGBO(220, 64, 38, 1)),
                  backgroundColor: (const Color.fromRGBO(250, 242, 241, 1)),
                  foregroundColor: (const Color.fromRGBO(220, 64, 38, 1))
                ), 
                child: Text('Excluir selecionados'),
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
            child: isReloading ? const Center(child: Text("Buscando dados, aguarde...")) : Container(),
          ),
          Visibility(
            visible: clientes.isNotEmpty,
            replacement: const Center(child: Text('Nenhum cliente cadastrado')),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FittedBox(
                  fit: SharedTheme.isLargeScreen(context) ? BoxFit.scaleDown : BoxFit.fitWidth,
                  child: SizedBox(
                    width: maxWidth,
                    child: DataTable(
                      sortColumnIndex: sortColumnIdx,
                      sortAscending: isAscending,
                      showCheckboxColumn: true,
                      dividerThickness: 2,
                      dataTextStyle: TextStyle(fontSize: maxWidth <= 800 ? 12 : null),
                      columns: [
                        DataColumn(
                          label: const Text('Nome'),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              clientes.sort((a, b) => isAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
                            });
                          }
                        ),
                        
                        const DataColumn(
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
                                      child: const Center(child: Icon(Icons.edit)),
                                      onTap: () {
                                        Cliente newCliente = _editCliente(context, cliente);
                                        setState(() {
                                          clientes[index] = newCliente;
                                        });
                                        print('edit cliente ${newCliente.name}');
                                      }
                                     ),
                                      PopupMenuItem(
                                        child: const Center(child: Icon(Icons.delete)),
                                        onTap: () {
                                          setState(() {
                                            selected = selected.map((item) => false).toList();
                                          });
                                          _deletePopup(context, () async {
                                          final availableClientes = await _deleteClientes(context, clientes, [cliente.id], refreshFn);
                                          clientes = availableClientes.whereType<Cliente>().toList();
                                          setState(() {});
                                        }, clientes, cliente.name, cliente.id, refreshFn);
                                          print('delete cliente ${cliente.name}');
                                        }
                                      ),
                                      PopupMenuItem(
                                        child: const Center(child: Icon(Icons.more_horiz)),
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
                                        _deletePopup(context, () async {
                                          final availableClientes = await _deleteClientes(context, clientes, [cliente.id], refreshFn);
                                          clientes = availableClientes.whereType<Cliente>().toList();
                                          setState(() {});
                                        }, clientes, cliente.name, cliente.id, refreshFn);
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



_deletePopup(BuildContext context, deleteCb, List<Cliente> clientes, clienteNome, String clienteId, Function refreshFn) {
  bool _isDeletingLoad = false;
  
  showDialog(
    context: context, 
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Deseja realmente excluir o cliente $clienteNome?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: const Text('Cancelar')
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _isDeletingLoad = true;
                  });
                  await _deleteClientes(context, clientes, [clienteId], refreshFn);
                  await Future.delayed(const Duration(seconds: 1));
                  Navigator.of(context).pop();
                }, 
                child: Text(_isDeletingLoad ? 'Aguarde...' : 'Excluir')
              ),
            ]
          );
        }
      );
    }
  );
}

Future<List<Cliente?>> _deleteClientes(BuildContext context, List<Cliente> clientes, List<String> clienteIds, Function refreshFn) async {
  final client = await ClientRepository.delete(clienteIds);
    if(client.status != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(client.message ?? 'Ocorreu um erro inesperado!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  final deletedCliente = clientes.where((element) => element.id == clienteIds);
  clientes.remove(deletedCliente);
  refreshFn();

  return clientes;
}

Cliente _editCliente(BuildContext context, Cliente cliente) {
  print('edit cliente');

  return cliente;
}

_createClients(BuildContext context, Function refreshFn) {

  final formKey = GlobalKey<FormState>();

  Map<String, TextEditingController> controllers = {
    "country": TextEditingController(text: 'Brasil'),
    "state": TextEditingController(),
    "name": TextEditingController(),
    "email": TextEditingController(),
    "rg": MaskedTextController(mask: '0000-000'),
    "cpf": MaskedTextController(mask: '000.000.000-00'),
    "phone": MaskedTextController(mask: '(00) 0 0000-0000'),
    "cep": MaskedTextController(mask: '00000-000'),
    "address": TextEditingController(),
    "city": TextEditingController(),
  };
  
  showDialog(
    context: context,
    builder: (context) {
      return SelectionArea(
        child: AlertDialog(
          title: const Text("Cadastrar Cliente"),
          content: SizedBox(
            width: SharedTheme.isLargeScreen(context) ? MediaQuery.of(context).size.width * 0.5 : MediaQuery.of(context).size.width * 0.3,
            child: Form(
              key: formKey,
              child: SizedBox(
                height: SharedTheme.isLargeScreen(context) ? null : MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 20,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: controllers['name'],
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Nome completo*',
                          border: OutlineInputBorder(),
                          isDense: true
                        ),
                      ),
                      TextFormField(
                        controller: controllers['email'],
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          border: OutlineInputBorder(),
                          isDense: true
                        ),
                      ),
                      
                      Helpers.rowOrWrap(
                        wrap: !SharedTheme.isLargeScreen(context),
                        children: [
                          Flexible(
                            child: TextFormField(
                              controller: controllers['rg'],
                              decoration: const InputDecoration(
                                labelText: 'RG',
                                hintText:   '0000-000',
                                border: OutlineInputBorder(),
                                isDense: true
                              ),
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              controller: controllers['cpf'],
                              decoration: const InputDecoration(
                                labelText: 'CPF',
                                hintText:   '000.000.000-00',
                                border: OutlineInputBorder(),
                                isDense: true
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: controllers['phone'],
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
                          hintText:   '(00) 0 0000-0000',
                          border: OutlineInputBorder(),
                          isDense: true
                        ),
                      ),
                      Helpers.rowOrWrap(
                        wrap: !SharedTheme.isLargeScreen(context),
                        children: [
                          Flexible(
                            flex: 3,
                            child: TextFormField(
                              controller: controllers['address'],
                              decoration: const InputDecoration(
                                labelText: 'Endereço',
                                border: OutlineInputBorder(),
                                isDense: true
                              ),
                            ),
                          ),
                        Flexible(
                          child: TextFormField(
                            controller: controllers['cep'],
                            decoration: const InputDecoration(
                              labelText: 'CEP',
                              hintText:   '00000-000',
                              border: OutlineInputBorder(),
                              isDense: true
                            ),
                          ),
                        ),
                        ],
                      ),
                      Helpers.rowOrWrap(
                        wrap: !SharedTheme.isLargeScreen(context),
                        children: [
                          Flexible(
                            child: TextFormField(
                              controller: controllers['state'],
                              decoration: const InputDecoration(
                                labelText: 'Estado',
                                border: OutlineInputBorder(),
                                isDense: true
                              ),
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              controller: controllers['city'],
                              decoration: const InputDecoration(
                                labelText: 'Cidade',
                                border: OutlineInputBorder(),
                                isDense: true
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: controllers['country'],
                        decoration: const InputDecoration(
                          labelText: 'País',
                          border: OutlineInputBorder(),
                          isDense: true
                        ),
                      ),
                      
                    ]
                  ),
                ),
              )
            )
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fechar"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();
                  await _createClientReq(context, controllers);
                  refreshFn();
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                     builder: (context) {
                       return AlertDialog(
                         title: const Text('Cliente cadastrado com sucesso!'),
                         actions: [
                           TextButton(
                             onPressed: () {
                               Navigator.of(context).pop();
                             }, 
                             child: const Text('Fechar')
                           ),
                         ]
                       );
                     }
                  );
                }
              }, 
              child: const Text("Adicionar novo cliente")
            ),
          ],
        ),
      );
    },
  );
}

_createClientReq(BuildContext context, Map<String, TextEditingController> controllers) async {
  final client = Cliente(
    id: "-1",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    name: controllers['name']!.text,
    email: controllers['email']!.text,
    rg: controllers['rg']!.text,
    cpf: controllers['cpf']!.text,
    phone: controllers['phone']!.text,
    address: controllers['address']!.text,
    cep: controllers['cep']!.text,
    city: controllers['city']!.text,
    state: controllers['state']!.text,
    country: controllers['country']!.text
  );


  final response = await ClientRepository.create(client);
  if(response.status != 200) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro ao adicionar cliente'),
          content: Text(response.message ?? 'Ocorreu um erro inesperado!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fechar"),
            ),
          ],
        );
      }
    );
  } 

}