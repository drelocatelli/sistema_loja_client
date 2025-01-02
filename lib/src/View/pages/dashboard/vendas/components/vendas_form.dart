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
import 'package:racoon_tech_panel/src/Model/sales_controller_dto.dart';
import 'package:racoon_tech_panel/src/Model/save_sales_dto.dart';
import 'package:racoon_tech_panel/src/View/components/searchable_menu.dart';
import 'package:racoon_tech_panel/src/View/helpers.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/clientes_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/colaborators_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/produtos_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ClientProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ColaboratorProvider%20copy.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ColaboratorProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/SaleRepository.dart';

class VendasForm extends StatefulWidget {
  const VendasForm({super.key});

  @override
  State<VendasForm> createState() => _VendasFormState();
}

class _VendasFormState extends State<VendasForm> {

  final _formKey = GlobalKey<FormState>();
  final SalesController _controller = SalesController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                      controller: _controller.serialController,
                      autofocus: true,
                      decoration: const InputDecoration(labelText: 'N° Série'),
                      validator: _controller.validateSerial,
                    ),
                    TextFormField(
                      controller: _controller.descricaoController,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      validator: _controller.validateDescricao,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.expand_more),
                        labelText: 'Produto',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      controller: TextEditingController(text: _controller.produto?.name),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SearchableMenu(
                              model: Provider.of<ProdutoProvider>(context, listen: true), 
                              items: produtoModel.produtos,
                              selectCb: (Produto produto) {
                                setState(() {
                                  _controller.produto = produto;
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
                        suffixIcon: const Icon(Icons.expand_more),
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
                      controller: TextEditingController(text: _controller.colaborator?.name),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SearchableMenu(
                              model: Provider.of<ColaboratorProvider>(context, listen: true), 
                              items: colaboratorModel.colaborators,
                              selectCb: (Colaborator colaborator) {
                                setState(() {
                                  _controller.colaborator = colaborator;
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
                    suffixIcon: const Icon(Icons.expand_more),
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
                  controller: TextEditingController(text: _controller.cliente?.name),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SearchableMenu(
                          model: Provider.of<ClientProvider>(context, listen: true), 
                          items: clientrModel.clientes,
                          selectCb: (Cliente cliente) {
                            setState(() {
                              _controller.cliente = cliente;
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
                  controller: _controller.quantityController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(labelText: 'Quantidade', prefixText: 'R\$ '),
                  validator: _controller.validateQuantity,
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
                      onPressed: () async {
                        if(_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          await SaleRepository.create(_controller);
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