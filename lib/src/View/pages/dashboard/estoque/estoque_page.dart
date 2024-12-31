import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/Model/estoque_dto.dart';
import 'package:racoon_tech_panel/src/View/helpers.dart';
import 'package:racoon_tech_panel/src/View/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';
import 'package:widget_zoom/widget_zoom.dart';

class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  State<EstoquePage> createState() => _VenddasState();
}

class _VenddasState extends State<EstoquePage> {
  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;


    return MainLayout(
      child: SelectionArea(
        child: _estoquesTable(maxWidth)
      ),
    );
  }
}

Widget _estoquesTable(double maxWidth) {

  List<Estoque> estoques = [
    Estoque(
      id: 1,
      foto_url: 'https://dummyimage.com/600x400/000/fff&text=no+image',
      nome: 'Produto A',
      descricao: 'Descrição do Produto A',
      quantidade: 10,
      valor: 100.0,
      publicado: true
    ),
    Estoque(
      id: 2,
      foto_url: 'https://dummyimage.com/600x400/000/fff&text=no+image',
      nome: 'Produto B',
      descricao: 'Descrição do Produto B',
      quantidade: 20,
      valor: 200.0,
      publicado: true
    ),
    Estoque(
      id: 3,
      foto_url: 'https://dummyimage.com/600x400/000/fff&text=no+image',
      nome: 'Produto C',
      descricao: 'Descrição do Produto C',
      quantidade: 5,
      valor: 150.0,
    ),
    Estoque(
      id: 4,
      foto_url: 'https://dummyimage.com/600x400/000/fff&text=no+image',
      nome: 'Produto D',
      descricao: 'Descrição do Produto D',
      quantidade: 30,
      valor: 250.0,
    ),
    Estoque(
      id: 5,
      foto_url: 'https://dummyimage.com/600x400/000/fff&text=no+image',
      nome: 'Produto E',
      descricao: 'Descrição do Produto E',
      quantidade: 8,
      valor: 120.0,
    ),
  ];


  estoques.asMap().entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key))
    ..forEach((entry) => entry.value.numero = entry.key + 1);

  int sortColumnIdx = 0; // coluna de data
  bool isAscending = true;
  List<bool> selection = List<bool>.generate(estoques.length, (int index) => false);
  
  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          Helpers.rowOrWrap(
            wrap: maxWidth <= 800,
            children: [
              Text('Gerenciar estoque', style: Theme.of(context).textTheme.headlineMedium),
              Align(alignment: Alignment.topRight, child: _pesquisa(maxWidth)),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight, 
            child: Visibility(
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
                  List<Estoque?> selectedEstoques = List.generate(estoques.length, (index) => 
                    selectionsIdxs.contains(index) ? estoques[index] : null).where((item) => item != null).toList();
                  
                  List filteredProdutosTitle = selectedEstoques.map((item) => item?.nome).toList();

                  showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Excluir selecionados"),
                        content: const Text("Você tem certeza que deseja excluir os estoques selecionadas?"),
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
                                estoques.removeWhere((item) {
                                  int index = estoques.indexOf(item);
                                  return selectionsIdxs.contains(index);
                                });
                                selection = List<bool>.generate(estoques.length, (int index) => false);
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
            )
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: maxWidth >= 800 ? maxWidth : null,
              child: Visibility(
                visible: estoques.isNotEmpty,
                replacement: Center(
                  child: Text("Nenhum estoque encontrado.", style: Theme.of(context).textTheme.bodyMedium),
                ),
                child: FittedBox(
                  fit: SharedTheme.isLargeScreen(context) ? BoxFit.scaleDown : BoxFit.fitWidth,
                  child: SizedBox(
                    width: SharedTheme.isLargeScreen(context) ? maxWidth : null,
                    child: DataTable(
                      sortColumnIndex: sortColumnIdx,
                      sortAscending: isAscending,
                      dataRowHeight: 55,
                      showCheckboxColumn: true,
                      columns: [
                        DataColumn(
                          label: const Text('N°'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              estoques.sort((a, b) => isAscending ? a.numero.compareTo(b.numero) : b.numero.compareTo(a.numero));
                            }),
                        ),
                        const DataColumn(
                          label: Text('Foto'),
                        ),
                        DataColumn(
                          label: const Text('Nome'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              estoques.sort((a, b) => isAscending ? a.nome.compareTo(b.nome) : b.nome.compareTo(a.nome));
                            }),
                        ),
                        
                        DataColumn(
                          label: const Text('Descrição'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              estoques.sort((a, b) => isAscending ? a.descricao.compareTo(b.descricao) : b.descricao.compareTo(a.descricao));
                            }),
                        ),
                        DataColumn(
                          label: const Text('Categoria'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              estoques.sort((a, b) => isAscending ? a.categoria.compareTo(b.categoria) : b.categoria.compareTo(a.categoria));
                            }),
                        ),
                        DataColumn(
                          label: const Text('Quantidade'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              estoques.sort((a, b) => isAscending ? a.quantidade.compareTo(b.quantidade) : b.quantidade.compareTo(a.quantidade));
                            }),
                        ),
                        DataColumn(
                          label: const Text('Valor'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              estoques.sort((a, b) => isAscending ? a.valor.compareTo(b.valor) : b.valor.compareTo(a.valor));
                            }),
                        ),
                        DataColumn(
                          label: const Text('Valor total'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              estoques.sort((a, b) => isAscending ? a.total.compareTo(b.total) : b.total.compareTo(a.total));
                            }),
                        ),
                        DataColumn(
                          label: const Text('Publicado'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              estoques.sort((a, b) {
                                if (a.publicado && !b.publicado) {
                                  return isAscending ? -1 : 1;
                                } else if (!a.publicado && b.publicado) {
                                  return isAscending ? 1 : -1;
                                } else {
                                  return 0;
                                }
                              });
                            }),
                        ),
                        const DataColumn(
                          label: Text('Ações'),
                        ),
                      ],
                      rows: estoques.asMap().entries.map((entry) {
                        final key = entry.key;
                        final estoque = entry.value;
                        return DataRow(
                          selected: selection[entry.key],
                          onSelectChanged: (value) {
                            setState(() {
                              selection[key] = value!;
                            });
                          },
                          cells: [
                            DataCell(Text(estoque.numero.toString())),
                            DataCell(Tooltip(message: 'Clique para expandir', child: WidgetZoom(heroAnimationTag: 'tag', zoomWidget: Image.network(estoque.foto_url, width: 80, height: 80, fit: BoxFit.contain)))),
                            DataCell(Text(estoque.nome)),
                            DataCell(Text('${estoque.descricao.substring(0, 8)}...')),
                            DataCell(Text(estoque.categoria)),
                            DataCell(Text(estoque.quantidade.toString())),
                            DataCell(Text("R\$ ${estoque.valor.toString()}")),
                            DataCell(Text("R\$ ${estoque.total.toString()}")),
                            DataCell(Text(estoque.publicado ? "Público" : "Anotação")),
                            DataCell(
                              Visibility(
                                visible: maxWidth > 800,
                                replacement: PopupMenuButton(
                                  icon: const Icon(Icons.more_vert),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        value: 'edit',
                                        onTap: () {
                                          Estoque newEstoque = _editFn(context, estoque);
                                          setState(() {
                                            estoques[key] = newEstoque;
                                          });
                                        },
                                        child: Center(child: Icon(Icons.edit))
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        onTap: () {
                                          setState(() {
                                            selection = selection.map((item) => false).toList();
                                          });
                                          _deletePopup(context, () {
                                            estoques = _deleteFn(context, estoques, key);
                                            setState(() {});
                                          }, estoque.nome);
                                        },
                                        child: Center(child: Icon(Icons.delete)),
                                      )
                                    ];
                                  },
                                ),
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
                                        setState(() {
                                          selection = selection.map((item) => false).toList();
                                        });
                                        _deletePopup(context, () {
                                          estoques = _deleteFn(context, estoques, key);
                                          setState(() {});
                                        }, estoque.nome);
                                      },
                                    ),
                                  ],
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
            ),
          ),
        ],
      );
    }
  );
  
}

_deletePopup(BuildContext context, deleteCb, titulo) {
  showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: Text('Deseja realmente excluir o produto $titulo?'),
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

Widget _pesquisa(double maxWidth) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0, top: 8),
    child: SizedBox(
      width: maxWidth >= 800 ? 400 : null,
      child: Row(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: DropdownButtonFormField(
              value: 'nome',
              onChanged: (String? value) {
              },
              decoration: const InputDecoration(
                  labelText: 'Buscar por:',
                  border: OutlineInputBorder(), 
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                  isDense: true
                ),
                items: const [
                  DropdownMenuItem(value: 'nome', child: Text('Nome')),
                  DropdownMenuItem(value: 'descrição', child: Text('Descrição')),
                  DropdownMenuItem(value: 'categoria', child: Text('Categoria')),
                ]
            ),
          ),
          Expanded(
            flex: 2,
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
        ],
      ),
    ),
  );
}

List<Estoque> _deleteFn(BuildContext context, List<Estoque> estoques, int indexToRemove) {
  estoques.removeAt(indexToRemove);
  return estoques;
}

Estoque _editFn(BuildContext context, Estoque item) {
  return item;
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