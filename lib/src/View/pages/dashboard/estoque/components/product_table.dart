import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/View/helpers.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ProductProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';
import 'package:widget_zoom/widget_zoom.dart';

import '../../../../../Model/product_dto.dart';


class ProductTable extends StatefulWidget {
  const ProductTable({super.key});

  @override
  State<ProductTable> createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    return _estoquesTable(maxWidth);
  }
}

Widget _estoquesTable(double maxWidth) {
  return Consumer<ProdutoProvider>(builder: (context, model, child) {
    return StatefulBuilder(builder: (context, setState) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: maxWidth >= 800 ? maxWidth : null,
          child: Visibility(
            visible: model.produtos.isNotEmpty,
            replacement: Center(
              child: Text("Nenhum estoque encontrado.",
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            child: FittedBox(
              fit: SharedTheme.isLargeScreen(context)
                  ? BoxFit.scaleDown
                  : BoxFit.fitWidth,
              child: SizedBox(
                width: SharedTheme.isLargeScreen(context) ? maxWidth : null,
                child: DataTable(
                  sortColumnIndex: model.sortColumnIdx,
                  sortAscending: model.isAscending,
                  dataRowHeight: 55,
                  showCheckboxColumn: true,
                  columns: [
                    const DataColumn(
                      label: Text('Foto'),
                    ),
                    DataColumn(
                      label: const Text('Nome'),
                      onSort: (columnIndex, ascending) =>
                          model.sort(columnIndex, ascending),
                    ),
                    DataColumn(
                      label: const Text('Descrição'),
                      onSort: (columnIndex, ascending) =>
                          model.sort(columnIndex, ascending),
                    ),
                    DataColumn(
                        label: const Text('Categoria'),
                        onSort: (columnIndex, ascending) =>
                            model.sort(columnIndex, ascending)),
                    DataColumn(
                        label: const Text('Quantidade'),
                        onSort: (columnIndex, ascending) =>
                            model.sort(columnIndex, ascending)),
                    DataColumn(
                        label: const Text('Preço'),
                        onSort: (columnIndex, ascending) =>
                            model.sort(columnIndex, ascending)),
                    DataColumn(
                        label: const Text('Total'),
                        onSort: (columnIndex, ascending) =>
                            model.sort(columnIndex, ascending)),
                    DataColumn(
                        label: const Text('Visibilidade'),
                        onSort: (columnIndex, ascending) =>
                            model.sort(columnIndex, ascending)),
                    const DataColumn(
                      label: Text('Ações'),
                    ),
                  ],
                  rows: model.produtos.asMap().entries.map((entry) {
                    final key = entry.key;
                    final product = entry.value;

                    String productThumbnail = (product.photos != null && product.photos!.length != 0) ? "${BaseRepository.baseStaticUrl}/${product.photos![0]}" : '';

                    return DataRow(
                        selected: model.selectedIds.contains(key),
                        onSelectChanged: (bool? selected) {
                          if (selected != null) {
                            model.toggleSelection(product.id.toString());
                          }
                        },
                        cells: [
                          DataCell(
                            Visibility(
                              visible: product.photos!.length != 0,
                              replacement: Center(child: Icon(Icons.image)),
                              child: WidgetZoom(
                                heroAnimationTag: 'tag',
                                zoomWidget: Image.network(productThumbnail, width: 80, 
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(child: Icon(Icons.image));
                                  }
                                ),
                              ),
                            )
                          ),
                          DataCell(Text(product.name ?? '-')),
                          DataCell(Text(Helpers.truncateText(text: product.description ?? '-'))),
                          DataCell(Text(product.category?.name ?? '-')),
                          DataCell(Text(product.quantity.toString())),
                          DataCell(
                            Text(
                              (product.price != null && product.price!.isNaN)
                                  ? "Erro"
                                  : "R\$ ${(product.price ?? 0).toStringAsFixed(2).replaceAll('.', ',')}",
                            ),
                          ),
                          DataCell(
                            Text(
                              (product.quantity != null &&
                                      product.price != null &&
                                      (product.quantity!.isNaN ||
                                          product.price!.isNaN))
                                  ? "Erro"
                                  : "R\$ ${(product.quantity! * product.price!).toStringAsFixed(2).replaceAll('.', ',')}",
                            ),
                          ),
                          DataCell(Text((product.isPublished ?? false)
                              ? 'Público'
                              : 'Anotação')),
                          DataCell(
                            PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    onTap: () {
                                      _readMore(context, product);
                                    },
                                    child: Center(child: Icon(Icons.info_outline)),
                                  ),
                                  PopupMenuItem(
                                      value: 'edit',
                                      onTap: () {},
                                      child: Center(child: Icon(Icons.edit))),
                                  PopupMenuItem(
                                    value: 'delete',
                                    onTap: () async {
                                      _deleteModal(context, [product.id!]);
                                    },
                                    child: Center(child: Icon(Icons.delete)),
                                  ),
                                  
                                ];
                              },
                            ),
                          ),
                        ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      );
    });
  });
}
_deleteModal(BuildContext context, List<String> ids) {
  final model = Provider.of<ProdutoProvider>(context, listen: false);
  
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
                  // await deleteVendas(context, ids);
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

_readMore(BuildContext context, Produto product) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(product.name!),
        content: StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText.rich(
                  TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      const TextSpan(text: 'Titulo: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: product.name!.toLowerCase() + '\n'),

                      const TextSpan(text: 'Categoria: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: product.category!.name!.toLowerCase() + '\n'),

                      const TextSpan(text: 'Preço unitário: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "R\$ ${(product.price ?? 0).toStringAsFixed(2).replaceAll('.', ',')}\n"),

                      const TextSpan(text: 'Quantidade: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "${product.quantity}\n"),
                      
                      const TextSpan(text: 'Visualização: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "${product.isPublished! ? 'Publicado' : 'Anotação'}\n"),

                      const TextSpan(text: '\nDescricao: \n', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: product.description!.toLowerCase()),
                    ]
                  )
                ),
               Divider(),
                product.photos!.length == 0 ? const Text('Sem imagens') : SizedBox(
                  width: 300,
                  child: Wrap(
                    children: List.generate(product.photos!.length, (index) => MouseRegion(cursor: SystemMouseCursors.click, child: WidgetZoom(
                      heroAnimationTag: 'tag', 
                      zoomWidget: Image.network('${BaseRepository.baseStaticUrl}/${product.photos![index]}', 
                      height: 100, 
                      width: 100)
                    )))
                  ),
                )
              ],
            );
          }
        ),
      );
    }
  );

}