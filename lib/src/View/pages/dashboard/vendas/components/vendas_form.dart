import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/category_dto.dart';
import 'package:racoon_tech_panel/src/Model/cliente_dto.dart';
import 'package:racoon_tech_panel/src/Model/colaborator_dto.dart';
import 'package:racoon_tech_panel/src/View/components/searchable_menu.dart';
import 'package:racoon_tech_panel/src/View/helpers.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/clientes_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/colaborators_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/debouncer_function.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/CategoryProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ClientProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ColaboratorProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';

class VendasForm extends StatefulWidget {
  const VendasForm({super.key});

  @override
  State<VendasForm> createState() => _VendasFormState();
}

class _VendasFormState extends State<VendasForm> {

  Map<String, TextEditingController> controllers = {
    "produto": TextEditingController(),
  };

  Colaborator? colaborator;
  Category? category;
  Cliente? cliente;
  String? serial;
  String? descricao;
  double? valor;


  @override
  void dispose() {
    super.dispose();
    controllers.forEach((key, value) {
      value.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {

  final colaboratorModel = Provider.of<ColaboratorProvider>(context, listen: true);
  final clientrModel = Provider.of<ClientProvider>(context, listen: true);


    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          Form(
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
                        labelText: 'Responsável',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      controller: TextEditingController(text: colaborator?.name ?? "Selecione"),
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
                  readOnly: true,
                  controller: TextEditingController(text: cliente?.name ?? "Selecione"),
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
                    Consumer<CategoryProvider>(
                      builder: (context, model, child) {
                        return DropdownSearch<Category>(
                          enabled: !model.isLoading,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            showSelectedItems: true,
                          ),
                          selectedItem: model.categories.firstWhere(
                            (category) => category.id == 1,
                            orElse: () => Category(id: "-1", name: model.isLoading ? "Aguarde..." : "Selecione"),
                          ),
                          items: (filter, infiniteScrollProps) => model.categories,
                          itemAsString: (Category category) => category.name!,
                          compareFn: (item1, item2) => item1.id == item2.id, // Add this line for comparison
                          decoratorProps: const DropDownDecoratorProps(
                            decoration: InputDecoration(
                              labelText: 'Categoria ',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        );
                      }
                    )
                  ],
                ),
                
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      valor = double.tryParse(value) ?? 0.0;
                    });
                  },
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Total', prefixText: 'R\$ '),
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
                        context.pop();
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


// _showModal(BuildContext context, {required debouncer, required Function cb}) async {
  
//   return showDialog(
//     context: context, 
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//         final model = Provider.of<ColaboratorProvider>(context, listen: true);

//           return AlertDialog(
//             contentPadding: const EdgeInsets.all(0),
//             content: SizedBox(
//             width: MediaQuery.of(context).size.width,
          
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       autofocus: true,
//                       decoration: const InputDecoration(
//                         labelText: 'Pesquisar',
//                         hintText: 'Buscar por nome',
//                         border: OutlineInputBorder(),
//                       ),
//                       onChanged: (value) async {
//                         model.setIsLoading(true);
//                         debouncer.run(() async {
//                           await fetchColaborators(context, searchTerm: value);
//                           model.setIsLoading(false);
//                         });
//                       },
//                     )
//                   ),
//                   Container(
//                     width: double.infinity,
//                     height: 300,
//                     child: Material(
//                       child: Scrollbar(
//                         trackVisibility: true,
//                         thumbVisibility: true,
//                         child: Visibility(
//                           visible: !model.isLoading,
//                           replacement: const Center(child: Text("Buscando dados...")),
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: model.colaborators.length,
//                             itemBuilder: (context, index) {
//                               return ListTile(
//                                 title: Text("${model.colaborators[index].name}", style: Theme.of(context).textTheme.bodyLarge),
//                                 onTap: () {
//                                   cb(model.colaborators[index]);
//                                   Navigator.of(context).pop();
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       );
//     }
//   );
// }