import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:racoon_tech_panel/src/components/main_menu.dart';
import 'package:racoon_tech_panel/src/dto/vendas_dto.dart';
import 'package:racoon_tech_panel/src/helpers.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/notas_fiscais/nfe_generated.dart';

class VendasPage extends StatefulWidget {
  const VendasPage({super.key});

  @override
  State<VendasPage> createState() => _VenddasState();
}

class _VenddasState extends State<VendasPage> {
  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;


    return MainLayout(
      child: SelectionArea(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gerenciar vendas', style: Theme.of(context).textTheme.headlineMedium),
            _vendasTable(maxWidth),
          ],
        )
      ),
    );
  }
}

Widget _vendasTable(double maxWidth) {

  List<Venda> vendas = [
    Venda(id: 1, nome: 'João', produto: 'Produto A', categoria: 'Categoria 1', responsavel: 'Fulano', valor: 450.75, data: '12/05/2024'),
    Venda(id: 2, nome: 'Maria', produto: 'Produto B', categoria: 'Categoria 2', responsavel: 'Ciclano', valor: 1200.50, data: '08/15/2024'),
    Venda(id: 3, nome: 'Carlos', produto: 'Produto C', categoria: 'Categoria 3', responsavel: 'Beltrano', valor: 789.99, data: '03/22/2024'),
    Venda(id: 4, nome: 'Ana', produto: 'Produto D', categoria: 'Categoria 1', responsavel: 'Fulano', valor: 334.60, data: '07/10/2024'),
    Venda(id: 5, nome: 'Lucas', produto: 'Produto A', categoria: 'Categoria 2', responsavel: 'Ciclano', valor: 999.99, data: '10/05/2024'),
    Venda(id: 6, nome: 'Fernanda', produto: 'Produto B', categoria: 'Categoria 3', responsavel: 'Beltrano', valor: 543.40, data: '11/12/2024'),
    Venda(id: 7, nome: 'João', produto: 'Produto C', categoria: 'Categoria 1', responsavel: 'Fulano', valor: 670.80, data: '02/25/2024'),
    Venda(id: 8, nome: 'Maria', produto: 'Produto D', categoria: 'Categoria 2', responsavel: 'Ciclano', valor: 1100.50, data: '06/17/2024'),
    Venda(id: 9, nome: 'Carlos', produto: 'Produto A', categoria: 'Categoria 3', responsavel: 'Beltrano', valor: 850.60, data: '04/30/2024'),
    Venda(id: 10, nome: 'Ana', produto: 'Produto B', categoria: 'Categoria 1', responsavel: 'Fulano', valor: 450.30, data: '09/20/2024'),
  ];

  vendas.asMap().entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key))
    ..forEach((entry) => entry.value.numero = entry.key + 1);

  int _sortColumnIdx = 0; // coluna de data
  bool _isAscending = true;
  List<bool> selection = List<bool>.generate(vendas.length, (int index) => false);
  
  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 5,
            children: [
              OutlinedButton(
                onPressed: () {
                  _novaVendaDialog(context);
                }, 
                child: Text('Nova venda')
              ),
              Visibility(
                visible: selection.contains(true),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color.fromRGBO(220, 64, 38, 1)),
                    backgroundColor: (const Color.fromRGBO(250, 242, 241, 1)),
                    foregroundColor: (const Color.fromRGBO(220, 64, 38, 1))
                  ),
                  onPressed: () {
                    // get all selections ids
                     List<int> selectionsIdxs = selection.asMap().entries
                      .where((entry) => entry.value == true)
                      .map((entry) => entry.key)
                      .toList();
                
                    // get selected vendas
                    List selectedVendas = List.generate(vendas.length, (index) => 
                      selectionsIdxs.contains(index) ? vendas[index] : null).where((item) => item != null).toList();
                    
                    List filteredProdutosTitle = selectedVendas.map((item) => item.produto).toList();
              
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Excluir selecionados"),
                          content: Text("Você tem certeza que deseja excluir as vendas selecionadas?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              }, 
                              child: Text("Cancelar")
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  vendas.removeWhere((item) {
                                    int index = vendas.indexOf(item);
                                    return selectionsIdxs.contains(index);
                                  });
                                  selection = List<bool>.generate(vendas.length, (int index) => false);
                                });
                                Navigator.of(context).pop();
                              }, 
                              child: Text("Confirmar")
                            ),
                          ],
                        );
                      }
                    );
                  }, 
                  child: Text("Excluir selecionados")
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: maxWidth >= 800 ? maxWidth : null,
              child: Visibility(
                visible: vendas.isNotEmpty,
                replacement: Center(
                  child: Text("Nenhuma venda encontrada.", style: Theme.of(context).textTheme.bodyMedium),
                ),
                child: DataTable(
                  sortColumnIndex: _sortColumnIdx,
                  sortAscending: _isAscending,
                  showCheckboxColumn: true,
                  columns: [
                    DataColumn(
                      label: Text('N°'),
                      onSort: (columnIndex, ascending) => 
                        setState(() {
                          _sortColumnIdx = columnIndex;
                          _isAscending = ascending;
                          vendas.sort((a, b) => _isAscending ? a.numero.compareTo(b.numero) : b.numero.compareTo(a.numero));
                        }),
                    ),
                    DataColumn(
                      label: Text('Nome'),
                      onSort: (columnIndex, ascending) => 
                        setState(() {
                          _sortColumnIdx = columnIndex;
                          _isAscending = ascending;
                          vendas.sort((a, b) => _isAscending ? a.nome.compareTo(b.nome) : b.nome.compareTo(a.nome));
                        }),
                    ),
                    DataColumn(
                      label: Text('Produto'),
                      onSort: (columnIndex, ascending) => 
                        setState(() {
                          _sortColumnIdx = columnIndex;
                          _isAscending = ascending;
                          vendas.sort((a, b) => _isAscending ? a.produto.compareTo(b.produto) : b.produto.compareTo(a.produto));
                        }),
                    ),
                    DataColumn(
                      label: Text('Categoria'),
                      onSort: (columnIndex, ascending) => 
                        setState(() {
                          _sortColumnIdx = columnIndex;
                          _isAscending = ascending;
                          vendas.sort((a, b) => _isAscending ? a.categoria.compareTo(b.categoria) : b.categoria.compareTo(a.categoria));
                        }),
                    ),
                    DataColumn(
                      label: Text('Responsável'),
                      onSort: (columnIndex, ascending) => 
                        setState(() {
                          _sortColumnIdx = columnIndex;
                          _isAscending = ascending;
                          vendas.sort((a, b) => _isAscending ? a.responsavel.compareTo(b.responsavel) : b.responsavel.compareTo(a.responsavel));
                        }),
                    ),
                    DataColumn(
                      label: Text('Valor'),
                      onSort: (columnIndex, ascending) => 
                        setState(() {
                          _sortColumnIdx = columnIndex;
                          _isAscending = ascending;
                          vendas.sort((a, b) => _isAscending ? a.valor.compareTo(b.valor) : b.valor.compareTo(a.valor));
                        }),
                    ),
                    DataColumn(
                      label: Text('Data'),
                      onSort: (columnIndex, ascending) => 
                        setState(() {
                          _sortColumnIdx = columnIndex;
                          _isAscending = ascending;
                          vendas.sort((a, b) => _isAscending ? a.data.compareTo(b.data) : b.data.compareTo(a.data));
                        }),
                    ),
                    DataColumn(
                      label: Text('Ações'),
                    ),
                  ],
                  rows: vendas.asMap().entries.map((entry) {
                    final key = entry.key;
                    final venda = entry.value;
                    return DataRow(
                      selected: selection[entry.key],
                      onSelectChanged: (value) {
                        setState(() {
                          selection[key] = value!;
                        });
                      },
                      cells: [
                        DataCell(Text(venda.numero.toString())),
                        DataCell(Text(venda.nome)),
                        DataCell(Text(venda.produto)),
                        DataCell(Text(venda.categoria)),
                        DataCell(Text(venda.responsavel)),
                        DataCell(Text("R\$ ${venda.valor.toString()}")),
                        DataCell(Text(venda.data)),
                        DataCell(
                          Visibility(
                            visible: maxWidth > 800,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    // Lógica para editar a venda
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // Lógica para excluir a venda
                                  },
                                ),
                              ],
                            ),
                            replacement: PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (context) {
                                final popupItems = _editAndDeleteIco(venda, maxWidth).map((item) => PopupMenuItem(child: Center(child: item,), onTap: () { item.onPressed!(); })).toList();
                                  return popupItems;
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      );
    }
  );
  
}

List<IconButton> _editAndDeleteIco(item, maxWidth) {
  List<IconButton> items = [
    IconButton(
      icon: Icon(Icons.edit, size: maxWidth <= 800 ? 20 : null),
      onPressed: () {
        // Ação para editar o item
        print('Editando: ${item.nome}');
      },
    ),
    IconButton(
      icon: Icon(Icons.delete, size: maxWidth <= 800 ? 20 : null),
      onPressed: () {
        // Ação para excluir o item
        print('Excluindo: ${item.nome}');
      },
    ),
  ];

  return items;
}

_novaVendaDialog(BuildContext context) {
  final maxWidth = MediaQuery.of(context).size.width;

  Venda venda;

  Map<String, TextEditingController> _controllers = {
    "data": TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now())),
    "produto": TextEditingController(),
    "responsavel": TextEditingController(),
    "valor": TextEditingController(),
    "categoria": TextEditingController(),
  };

  _selectDate(BuildContext context) async {
    
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if(picked! != null) {
      _controllers["data"]!.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }
  
  showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: Text('Nova venda'),
        content: SizedBox(
          width: maxWidth / 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    rowOrWrap(
                      context,
                      wrap: maxWidth < 800,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _controllers["produto"],
                            decoration: InputDecoration(labelText: 'Produto'),
                          ),
                        ),
                        DropdownMenu(
                          controller: _controllers["categoria"]!,
                          width: maxWidth < 800 ? double.infinity : null,
                          enableFilter: true,
                          label: Text("Categoria"),
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: 1, label: "Categoria 1"),
                            DropdownMenuEntry(value: 2, label: "Categoria 2"),
                            DropdownMenuEntry(value: 3, label: "Categoria 3"),
                          ],
                        ),
                      ],
                    ),
                    
                    TextFormField(
                      controller: _controllers["valor"]!,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Valor', prefixText: 'R\$ '),
                    ),
                    TextFormField(
                      controller: _controllers["data"]!,
                      onTap: () => _selectDate(context),
                       decoration: InputDecoration(
                          labelText: "Data",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                        ),
                    ),
                    Gap(20),
                    DropdownMenu(
                      width: double.infinity,
                      enableFilter: true,
                      controller: _controllers["responsavel"]!,
                      label: Text("Responsável"),
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: 1, label: "Colaborador 1"),
                        DropdownMenuEntry(value: 2, label: "Colaborador 2"),
                        DropdownMenuEntry(value: 3, label: "Colaborador 3"),
                      ],
                    ),
                    Gap(30),
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                      }, 
                      child: 
                      Text("Salvar venda")
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  );
}

