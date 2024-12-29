import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/dto/vendas_dto.dart';
import 'package:racoon_tech_panel/src/providers/SalesProvider.dart';

class VendasTable extends StatelessWidget {
  VendasTable({super.key});

  @override
  Widget build(BuildContext context) {
  final maxWidth = MediaQuery.of(context).size.width;
  
  return Consumer<SalesProvider>(
    builder: (context, model, child) {
      debugPrint(jsonEncode(model.sales.first.client));
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 5,
                children: [
                  Visibility(
                    visible: model.selectedSales.isNotEmpty,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color.fromRGBO(220, 64, 38, 1)),
                        backgroundColor: (const Color.fromRGBO(250, 242, 241, 1)),
                        foregroundColor: (const Color.fromRGBO(220, 64, 38, 1))
                      ),
                      onPressed: () {
                        // get all selections ids
                        List<int> selectionIdxs = List<int>.generate(model.sales.length, (index) => index);
                    
                        // get selected vendas
                        List selectedVendas = List.generate(model.sales.length, (index) => 
                          selectionIdxs.contains(index) ? model.sales[index] : null).where((item) => item != null).toList();
                        
                        List filteredProdutosTitle = selectedVendas.map((item) => item.produto).toList();
                  
                        showDialog(
                          context: context, 
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Excluir selecionados"),
                              content: const Text("Você tem certeza que deseja excluir as vendas selecionadas?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }, 
                                  child: const Text("Cancelar")
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                    });
                                    Navigator.of(context).pop();
                                  }, 
                                  child: const Text("Confirmar")
                                ),
                              ],
                            );
                          }
                        );
                      }, 
                      child: const Text("Excluir selecionados")
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: model.sales.isNotEmpty,
                replacement: Center(
                  child: Text("Nenhuma venda encontrada.", style: Theme.of(context).textTheme.bodyMedium),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: maxWidth),
                    child: DataTable(
                          sortColumnIndex: model.sortColumnIdx,
                          sortAscending: model.isAscending,
                          showCheckboxColumn: true,
                          columns: [
                            DataColumn(
                              label: const Text('Serial'),
                              onSort: (columnIndex, ascending) {
                                model.sortSales(columnIndex, ascending);
                              } 
                            ),
                            DataColumn(
                              label: const Text('Produto'),
                              onSort: (columnIndex, ascending) {
                                model.sortSales(columnIndex, ascending);
                              } 
                            ),
                            DataColumn(
                              label: const Text('Cliente'),
                              onSort: (columnIndex, ascending) {
                               model.sortSales(columnIndex, ascending);
                              },
                            ),
                            DataColumn(
                              label: const Text('Responsável'),
                              onSort: (columnIndex, ascending) {
                                model.sortSales(columnIndex, ascending);
                              }
                            ),
                            DataColumn(
                              label: const Text('Descrição'),
                              onSort: (columnIndex, ascending) {
                                model.sortSales(columnIndex, ascending);
                              }
                            ),
                            DataColumn(
                              label: const Text('Total'),
                              onSort: (columnIndex, ascending) {
                                model.sortSales(columnIndex, ascending);
                              }
                            ),
                            const DataColumn(
                              label: Text('Ações'),
                            ),
                          ],
                          rows: model.sales.asMap().entries.map((entry) {
                            final key = entry.key;
                            final sale = entry.value;
                            return DataRow(
                              cells: [
                                DataCell(Text(sale.serial ?? '-')),
                                DataCell(Text(sale.product?.name ?? '-')),
                                DataCell(Text(sale.client?.name ?? '-')),
                                DataCell(Text(sale.colaborator?.name ?? '-')),
                                DataCell(Text(sale.description ?? '-')),
                                DataCell(Text("R\$ ${sale.total.toString()}")),
                                DataCell(
                                  PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                            value: 'edit',
                                            onTap: () {
                                              
                                            },
                                            child: Center(child: Icon(Icons.edit))
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            onTap: () {
                                            },
                                            child: Center(child: Icon(Icons.delete)),
                                          )
                                        ];
                                      },
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
  );
  }
}

_deletePopup(BuildContext context, deleteCb, titulo) {
  showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: Text('Deseja realmente excluir o $titulo?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, 
            child: const Text('Cancelar')
          ),
          TextButton(
            onPressed: () {
                deleteCb();
                Navigator.of(context).pop();
            }, 
            child: const Text('Excluir')
          ),
        ]
      );
    }
  );
}

List<Venda> _deleteFn(BuildContext context, List<Venda> vendas, int indexToRemove) {
  vendas.removeAt(indexToRemove);
  return vendas;
}

Venda _editFn(BuildContext context, Venda item) {
  return item;
}

