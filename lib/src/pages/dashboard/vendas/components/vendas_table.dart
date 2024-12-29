import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/dto/vendas_dto.dart';

class VendasTable extends StatelessWidget {
  const VendasTable({super.key});

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

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

  int sortColumnIdx = 0; // coluna de data
  bool isAscending = true;
  List<bool> selection = List<bool>.generate(vendas.length, (int index) => false);
  
  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 5,
            children: [
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
                                  vendas.removeWhere((item) {
                                    int index = vendas.indexOf(item);
                                    return selectionsIdxs.contains(index);
                                  });
                                  selection = List<bool>.generate(vendas.length, (int index) => false);
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
            visible: vendas.isNotEmpty,
            replacement: Center(
              child: Text("Nenhuma venda encontrada.", style: Theme.of(context).textTheme.bodyMedium),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: maxWidth),
                child: DataTable(
                      sortColumnIndex: sortColumnIdx,
                      sortAscending: isAscending,
                      showCheckboxColumn: true,
                      columns: [
                        DataColumn(
                          label: const Text('N°'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              vendas.sort((a, b) => isAscending ? a.numero.compareTo(b.numero) : b.numero.compareTo(a.numero));
                            }),
                        ),
                        DataColumn(
                          label: const Text('Produto'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              vendas.sort((a, b) => isAscending ? a.produto.compareTo(b.produto) : b.produto.compareTo(a.produto));
                            }),
                        ),
                        DataColumn(
                          label: const Text('Cliente'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              vendas.sort((a, b) => isAscending ? a.nome.compareTo(b.nome) : b.nome.compareTo(a.nome));
                            }),
                        ),
                        DataColumn(
                          label: const Text('Responsável'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              vendas.sort((a, b) => isAscending ? a.responsavel.compareTo(b.responsavel) : b.responsavel.compareTo(a.responsavel));
                            }),
                        ),
                        DataColumn(
                          label: const Text('Categoria'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              vendas.sort((a, b) => isAscending ? a.categoria.compareTo(b.categoria) : b.categoria.compareTo(a.categoria));
                            }),
                        ),
                        
                        DataColumn(
                          label: const Text('Valor'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              vendas.sort((a, b) => isAscending ? a.valor.compareTo(b.valor) : b.valor.compareTo(a.valor));
                            }),
                        ),
                        DataColumn(
                          label: const Text('Data'),
                          onSort: (columnIndex, ascending) => 
                            setState(() {
                              sortColumnIdx = columnIndex;
                              isAscending = ascending;
                              vendas.sort((a, b) => isAscending ? a.data.compareTo(b.data) : b.data.compareTo(a.data));
                            }),
                        ),
                        const DataColumn(
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
                            DataCell(Text(venda.produto)),
                            DataCell(Text(venda.nome)),
                            DataCell(Text(venda.responsavel)),
                            DataCell(Text(venda.categoria)),
                            DataCell(Text("R\$ ${venda.valor.toString()}")),
                            DataCell(Text(venda.data)),
                            DataCell(
                              PopupMenuButton(
                                  icon: const Icon(Icons.more_vert),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        value: 'edit',
                                        onTap: () {
                                          Venda newVenda = _editFn(context, venda);
                                          setState(() {
                                            vendas[key] = newVenda;
                                          });
                                        },
                                        child: Center(child: Icon(Icons.edit))
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        onTap: () {
                                          setState((){
                                            selection = selection.map((item) => false).toList();
                                          });
                                          _deletePopup(context, () {
                                            vendas = _deleteFn(context, vendas, key);
                                            setState(() {});
                                          }, venda.produto);
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

