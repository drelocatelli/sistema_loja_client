import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/product_dto.dart';
import 'package:racoon_tech_panel/src/View/helpers.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/estoque/components/product_details.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ProductProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';
import 'package:widget_zoom/widget_zoom.dart';


class ProductTable extends StatefulWidget {
  const ProductTable({super.key});

  @override
  State<ProductTable> createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  bool _isHorizontalThumbShowing = false;

  @override
  Widget build(BuildContext context) {

    Widget _estoquesTable(double maxWidth) {
      return Consumer<ProdutoProvider>(builder: (context, model, child) {
        return StatefulBuilder(builder: (context, setState) {
          return Scrollbar(
            interactive: true,
            controller: _horizontalScrollController,
            trackVisibility: false,
            thumbVisibility: _isHorizontalThumbShowing,
            radius: const Radius.circular(10),
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
                  child: SizedBox(
                    width: maxWidth >= 800 ? maxWidth : null,
                    child: Visibility(
                      visible: !model.isLoading,
                      replacement: Center(
                        child:Text("Obtendo dados, aguarde...", style: Theme.of(context).textTheme.bodyMedium),
                      ),
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
                            width: SharedTheme.isLargeScreen(context)
                                ? maxWidth
                                : null,
                            child: MouseRegion(
                              onHover: (PointerHoverEvent event) {
                                if(!_isHorizontalThumbShowing) {
                                  _isHorizontalThumbShowing = true;
                                }
                                setState(() {});
                              },
                              onExit: (PointerExitEvent event) {
                                _isHorizontalThumbShowing = false;
                                setState(() {});
                              },
                              child: productTable(produtos: model.produtos),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ),
          );
        });
      });
    }

    final maxWidth = MediaQuery.of(context).size.width;

    return _estoquesTable(maxWidth);
  }
}

Widget productTable({required List<Produto> produtos, bool showSelection = true, bool showActions = true}) {
   return Consumer<ProdutoProvider>(
     builder: (context, model, child) {
       return Visibility(
        visible: produtos.isNotEmpty,
        child: DataTable(
            sortColumnIndex: model.sortColumnIdx,
            sortAscending: model.isAscending,
            dataRowHeight: 55,
            showCheckboxColumn: showSelection,
            columns: produtosColumns(model, showActions: showActions), 
            rows: productsRows(model, produtos, showActions: showActions),
          ),
       );
     }
   );
}

List<DataRow> productsRows(ProdutoProvider model, List<Produto> produtos, {bool showActions = true}) {
  return produtos.asMap().entries.map((entry) {
      final key = entry.key;
      final product = entry.value;
  
      String productThumbnail = (product.photos !=
                  null &&
              product.photos!.length != 0)
          ? "${BaseRepository.baseStaticUrl}/${product.photos![0]}"
          : '';
  
      return DataRow(
        color: WidgetStateProperty.resolveWith((states) {
          return product.quantity! <= 0 ? const Color.fromARGB(255, 255, 205, 205) : Colors.transparent;
        }),

          selected: model.selectedIds.contains(product.id.toString()),
          onSelectChanged: (bool? selected) {
            if (selected != null) {
              model.toggleSelection(
                  product.id.toString());
            }
          },
          cells: [
            DataCell(Visibility(
              visible: product.photos!.length != 0,
              replacement:
                  Center(child: Icon(Icons.image)),
              child: WidgetZoom(
                heroAnimationTag: 'tag',
                zoomWidget: Image.network(
                    productThumbnail,
                    width: 80, errorBuilder:
                        (context, error, stackTrace) {
                  return Center(
                      child: Icon(Icons.image));
                }),
              ),
            )),
            DataCell(Text(product.name ?? '-')),
            DataCell(Text(Helpers.truncateText(
                text: product.description ?? '-'))),
            DataCell(
                Text(product.category?.name ?? '-')),
            DataCell(Text(product.quantity.toString())),
            DataCell(
              Text(
                (product.price != null &&
                        product.price!.isNaN)
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
            !showActions! ? DataCell(Container()) : DataCell(
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        productDetails(
                            context, product);
                      },
                      child: Center(
                          child:
                              Icon(Icons.info_outline)),
                    ),
                    PopupMenuItem(
                        value: 'edit',
                        onTap: () {},
                        child: Center(
                            child: Icon(Icons.edit))),
                    PopupMenuItem(
                      value: 'delete',
                      onTap: () async {
                        _deleteModal(
                            context, [product.id!]);
                      },
                      child: Center(
                          child: Icon(Icons.delete)),
                    ),
                  ];
                },
              ),
            ),
          ]);
    }).toList();
}

List<DataColumn> produtosColumns(ProdutoProvider model, {bool showActions = true}) {
  return [
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
      !showActions ? DataColumn(label: Container()) : DataColumn(
        label: Text('Ações'),
      ),
    ];
}

_deleteModal(BuildContext context, List<String> ids) {
  final model = Provider.of<ProdutoProvider>(context, listen: false);

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Excluir selecionados"),
            content: const Text(
                "Você tem certeza que deseja excluir as vendas selecionadas?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () async {
                    model.setIsReloading(true);
                    setState(() {});
                    // await deleteVendas(context, ids);
                    Navigator.of(context).pop();
                  },
                  child: Text(model.isReloading ? 'Aguarde...' : "Confirmar")),
            ],
          );
        });
      });
}
