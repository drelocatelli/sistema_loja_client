
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/dto/vendas_dto.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/vendas/functions/vendas_functions.dart';
import 'package:racoon_tech_panel/src/providers/SalesProvider.dart';

class VendasTable extends StatelessWidget {
  VendasTable({super.key});

  @override
  Widget build(BuildContext context) {
  final maxWidth = MediaQuery.of(context).size.width;
  
  return Consumer<SalesProvider>(
    builder: (context, model, child) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 5,
                children: [
                  Visibility(
                    visible: model.selectedIds.isNotEmpty,
                    child: OutlinedButton(
                      child: const Text("Excluir selecionados"),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color.fromRGBO(220, 64, 38, 1)),
                        backgroundColor: (const Color.fromRGBO(250, 242, 241, 1)),
                        foregroundColor: (const Color.fromRGBO(220, 64, 38, 1))
                      ),
                      onPressed: () async {
                        model.setIsReloading(false);

                        showDialog(
                          context: context, 
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
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
                                      onPressed: () async {
                                        model.setIsReloading(true);
                                        setState(() {});
                                        final selectedIds = model.selectedIds;
                                        await deleteVendas(context, selectedIds);
                                        Navigator.of(context).pop();
                                      }, 
                                      child: Text(model.isReloading ? 'Aguarde...' : "Confirmar")
                                    ),
                                  ],
                                );
                              }
                            );
                          }
                        );
                      }, 
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: model.sales.isNotEmpty,
                replacement: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text("Nenhuma venda encontrada.", style: Theme.of(context).textTheme.bodyMedium),
                  ),
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
        selected: model.selectedIds.contains(sale.id),
        onSelectChanged: (bool? selected) {
          if(selected != null) {
            model.toggleSelection(sale.id!);
          }
        },
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
  )
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
