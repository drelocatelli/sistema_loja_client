import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/category_dto.dart';
import 'package:racoon_tech_panel/src/Model/cliente_dto.dart';
import 'package:racoon_tech_panel/src/Model/colaborator_dto.dart';
import 'package:racoon_tech_panel/src/Model/product_dto.dart';
import 'package:racoon_tech_panel/src/View/components/searchable_menu.dart';
import 'package:racoon_tech_panel/src/View/helpers.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/clientes_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/colaborators_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/debouncer_function.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/produtos_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/CategoryProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ClientProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ColaboratorProvider%20copy.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ColaboratorProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';

class VendasForm extends StatefulWidget {
  const VendasForm({super.key});

  @override
  State<VendasForm> createState() => _VendasFormState();
}

class _VendasFormState extends State<VendasForm> {

  final _formKey = GlobalKey<FormState>();

  Produto? produto;
  Colaborator? colaborator;
  Category? category;
  Cliente? cliente;
  String? serial;
  String? descricao;
  double? valor;


  @override
  Widget build(BuildContext context) {

  final colaboratorModel = Provider.of<ColaboratorProvider>(context, listen: true);
  final produtoModel = Provider.of<ProdutoProvider>(context, listen: true);
  final clientrModel = Provider.of<ClientProvider>(context, listen: true);


    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Helpers.rowOrWrap(
                  wrap: true,
                  children: [
                    TextFormField(
                      onChanged: (value) {
                      setState(() {
                        serial = value;
                      });
                    },
                      decoration: const InputDecoration(labelText: 'N° Série'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          descricao = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      
                    ),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Produto',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                      readOnly: true,
                      controller: TextEditingController(text: produto?.name),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SearchableMenu(
                              model: Provider.of<ProdutoProvider>(context, listen: true), 
                              items: produtoModel.produtos,
                              selectCb: (Produto produto) {
                                setState(() {
                                  this.produto = produto;
                                });
                              },
                              fetchCb: (String? searchTerm) async {
                                await fetchProdutos(context, searchTerm: searchTerm);
                              }
                            );
                          },
                        );
                      }
                    ),
                    
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Responsável',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                      readOnly: true,
                      controller: TextEditingController(text: colaborator?.name),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SearchableMenu(
                              model: Provider.of<ColaboratorProvider>(context, listen: true), 
                              items: colaboratorModel.colaborators,
                              selectCb: (Colaborator colaborator) {
                                setState(() {
                                  this.colaborator = colaborator;
                                });
                              },
                              fetchCb: (String? searchTerm) async {
                                await fetchColaborators(context, searchTerm: searchTerm);
                              }
                            );
                          },
                        );
                      }
                    ),
                const Gap(20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Cliente',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                  readOnly: true,
                  controller: TextEditingController(text: cliente?.name),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SearchableMenu(
                          model: Provider.of<ClientProvider>(context, listen: true), 
                          items: clientrModel.clientes,
                          selectCb: (Cliente cliente) {
                            setState(() {
                              this.cliente = cliente;
                            });
                          },
                          fetchCb: (String? searchTerm) async {
                            await fetchClientes(context, searchTerm: searchTerm);
                          }
                        );
                      },
                    );
                  }
                    ),
                  ],
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      valor = double.tryParse(value) ?? 0.0;
                    });
                  },
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(labelText: 'Total', prefixText: 'R\$ '),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    final doubleValue = double.tryParse(value);
                    if (doubleValue == null) {
                      return 'Por favor insira um valor decimal';
                    }
                    return null;
                  },
                ),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                      }, 
                      child: 
                      const Text("Cancelar")
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {

                          
                          Logger().i("Venda salva com sucesso");
                          context.pop();
                        }
                      }, 
                      child: 
                      const Text("Salvar venda")
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
