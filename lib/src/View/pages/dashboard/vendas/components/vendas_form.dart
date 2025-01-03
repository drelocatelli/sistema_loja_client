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
  double _total = 0.0;


  @override
  void initState() {
    super.initState();
    _controller.quantityController.addListener(() {
      updateTotal();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  void updateTotal() {
    int quantity = int.tryParse(_controller.quantityController.text) ?? 0;
    double price = _controller.produto?.price ?? 0;
    if(_controller.produto != null && quantity > 0) {
      _total = price * quantity;
    } else {
      _total = 0.0;
    }
    setState(() {});
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
                      keyboardType: TextInputType.number,
                      validator: _controller.validateSerial,
                    ),
                    TextFormField(
                      controller: _controller.descricaoController,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      // validator: _controller.validateDescricao,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.expand_more),
                        labelText: 'Produto',
                        border: OutlineInputBorder(),
                      ),
                      validator: _controller.validateProduto,
                      style: const TextStyle(fontSize: 13),
                      readOnly: true,
                      controller: TextEditingController(text: _controller.produto?.name),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SearchableMenu(
                              model: Provider.of<ProdutoProvider>(context, listen: true), 
                              items: produtoModel.produtos.where((produto) => produto.quantity! > 0).toList(),
                              selectCb: (Produto produto) {
                                setState(() {
                                  _controller.produto = produto;
                                });
                                  updateTotal();
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
                      style: const TextStyle(fontSize: 13),

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
                  style: const TextStyle(fontSize: 13),
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
                  readOnly: _controller.produto?.quantity == 0,
                  maxLength: 6,
                  onChanged: (value) {
                    // put max of values
                    if(_controller.produto?.quantity != null) {
                      if (int.parse(_controller.quantityController.text) >= _controller.produto!.quantity! || _controller.quantityController.text == '0') {
                        setState(() {
                          _controller.quantityController.text = _controller.produto!.quantity!.toString();
                        });
                      }
                    }
                    updateTotal();
                  },  
                  controller: _controller.produto?.quantity != 0 ? _controller.quantityController : TextEditingController(text: ''),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Só números
                    LengthLimitingTextInputFormatter(10), // Limitar a quantidade de caracteres, se necessário
                    _NoLeadingZeroFormatter(), // Impedir número com zero à esquerda
                  ],
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(labelText: 'Quantidade', counterText: '', hintText: _controller.produto?.quantity == 0 ? 'Estoque indisponível' : ''),
                  validator: _controller.validateQuantity,
                ),
                Visibility(
                  visible: _controller.produto?.quantity != 0,
                  replacement: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("Estoque indisponível", style: const TextStyle(fontSize: 13, color: Color.fromARGB(255, 230, 29, 29)),
                    ),
                  ),
                  child: Visibility(
                    visible: _controller.produto != null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: SelectionArea(
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Em estoque.: ${_controller.produto?.quantity}", style: const TextStyle(fontSize: 13, color: Color.fromARGB(255, 105, 105, 105))),
                            Text("Valor unitário: R\$ ${_controller.produto?.price?.toStringAsFixed(2)}", style: const TextStyle(fontSize: 13, color: Color.fromARGB(255, 105, 105, 105))),
                            Text("Total: R\$ ${_total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), softWrap: true, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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

class _NoLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Impede que o número comece com zero, mas permite números como '0' isolado
    if (newValue.text.isNotEmpty && newValue.text[0] == '0' && newValue.text.length > 1) {
      return oldValue;
    }
    return newValue;
  }
}