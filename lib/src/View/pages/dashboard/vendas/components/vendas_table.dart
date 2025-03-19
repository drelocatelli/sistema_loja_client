import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/vendas_dto.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/vendas/components/vendas_details.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/vendas_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/SalesProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';
import 'package:widget_zoom/widget_zoom.dart';


class VendasTable extends StatelessWidget {
  VendasTable({super.key});

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
  final maxWidth = MediaQuery.of(context).size.width;

  bool _isHorizontalThumbShowing = false;

  
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
                        _deleteModal(context, model.selectedIds);
                        
                      }, 
                    ),
                  ),
                ],
              ),
              Scrollbar(
                interactive: true,
                controller: _horizontalScrollController,
                trackVisibility: false,
                thumbVisibility: _isHorizontalThumbShowing,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                  child: Scrollbar(
                    interactive: true,
                    controller: _verticalScrollController,
                    trackVisibility: true,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: _verticalScrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Visibility(
                        visible: !model.isLoading,
                        child: Visibility(
                          visible: model.salesNotDeleted.isNotEmpty,
                          child: MouseRegion(
                            onHover: (event) {
                              setState(() {
                                _isHorizontalThumbShowing = true;
                              });
                            },
                            onExit: (event) {
                              setState(() {
                                _isHorizontalThumbShowing = false;
                              });
                            },
                            child: FittedBox(
                              fit: SharedTheme.isLargeScreen(context)
                              ? BoxFit.scaleDown
                              : BoxFit.fitWidth,
                              child: SizedBox(
                                width: SharedTheme.isLargeScreen(context)
                                ? maxWidth
                                : null,
                                child: salesTable(vendas: model.sales),
                              ),
                            ),
                          ),
                          ),
                      ),
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

Widget salesTable({required List<Venda> vendas}) {
  return Consumer<SalesProvider>(
    builder: (context, model, child) {
      return DataTable(
        sortColumnIndex: model.sortColumnIdx,
        sortAscending: model.isAscending,
        showCheckboxColumn: true,
        columns: salesColumns(model),
        rows: salesRows(model, vendas)
      );
    }
  );
}

_deleteModal(BuildContext context, List<String> ids) {
  final model = Provider.of<SalesProvider>(context, listen: false);
  
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
                  await deleteVendas(context, ids);
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
}

List<DataColumn> salesColumns(SalesProvider model) {
    return [
      DataColumn(
        label: const Text('Serial'),
        onSort: (columnIndex, ascending) {
          model.sortSales(columnIndex, ascending);
        } 
      ),
        DataColumn(
        label: const Text('Capa'),
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
        label: const Text('Data da venda'),
        onSort: (columnIndex, ascending) {
          model.sortSales(columnIndex, ascending);
        }
      ),
      DataColumn(
        label: const Text('Preço unitário'),
        onSort: (columnIndex, ascending) {
          model.sortSales(columnIndex, ascending);
        }
      ),
      DataColumn(
        label: const Text('Qtd. vendida'),
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
    ];
  }
List<DataRow> salesRows(SalesProvider model, List<Venda> sales) {
  return sales.asMap().entries.map((entry) {
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
          DataCell(Visibility(
            visible: sale.product?.photos != null && sale.product?.photos?.length != 0,
            replacement:
                Center(child: Icon(Icons.image)),
            child: WidgetZoom(
              heroAnimationTag: 'tag',
              zoomWidget: Image.network(
              (sale.product?.photos != null && sale.product!.photos!.isNotEmpty)
                  ? "${BaseRepository.baseStaticUrl}/${sale.product?.photos![0]}"
                  : '', // Imagem padrão se a lista estiver vazia
                  width: 80,
            ),
            ),
          )),
          DataCell(
              Text(sale.product?.name ?? '-'),
          ),
          DataCell(Text(sale.client?.name ?? '-')),
          DataCell(Text(sale.colaborator?.name ?? '-')),
          DataCell(Text(sale.date ?? '-')),
          // DataCell(Text(Helpers.truncateText(text: sale.description ?? ''))),
          // valor de estoque
          DataCell(
            Text(
              (sale.product?.price != null && sale.product!.price!.isNaN) 
                ? "Erro" 
                : "R\$ ${(sale.product?.price ?? 0).toStringAsFixed(2).replaceAll('.', ',')}",
            ),
          ),
          DataCell(Text("${sale.total.toString() ?? 0}")),
          DataCell(
            Text(
              (sale.total != null && sale.product?.price != null &&
    (sale.total!.isNaN || sale.product!.price!.isNaN))
                  ? "Erro"
                  : "R\$ ${(sale.total! * sale.product!.price!).toStringAsFixed(2).replaceAll('.', ',')}",
            ),
          ),
          DataCell(
            PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'edit',
                      onTap: () {
                        vendaDetails(context, sale);
                      },
                      child: Center(child: Icon(Icons.info_outline))
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      onTap: () {
                        
                      },
                      child: Center(child: Icon(Icons.edit))
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      onTap: () async {
                        _deleteModal(context, [sale.id!]);
                      },
                      child: Center(child: Icon(Icons.delete)),
                    )
                  ];
                },
              ),
          ),
        ],
      );
    }).toList();
}