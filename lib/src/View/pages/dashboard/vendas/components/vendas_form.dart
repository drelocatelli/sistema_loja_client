import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/category_dto.dart';
import 'package:racoon_tech_panel/src/Model/colaborator_dto.dart';
import 'package:racoon_tech_panel/src/View/helpers.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/CategoryProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ColaboratorProvider.dart';

class VendasForm extends StatefulWidget {
  const VendasForm({super.key});

  @override
  State<VendasForm> createState() => _VendasFormState();
}

class _VendasFormState extends State<VendasForm> {

  Map<String, TextEditingController> controllers = {
    "category": TextEditingController(),
    "produto": TextEditingController(),
    "serial": TextEditingController(),
    "responsavel": TextEditingController(),
    "valor": TextEditingController(),
    "descricao": TextEditingController(),
  };

  @override
  void dispose() {
    super.dispose();
    controllers.forEach((key, value) {
      value.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
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
                  wrap: maxWidth < 800,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controllers["serial"],
                        decoration: const InputDecoration(labelText: 'N° Série'),
                      ),
                    ),
                    TextFormField(
                      controller: controllers["descricao"]!,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                    ),
                    Consumer<ColaboratorProvider>(
                  builder: (context, model, child) {
                    return DropdownSearch<Colaborator>(
                      enabled: !model.isLoading,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        showSelectedItems: true,
                      ),
                      selectedItem: model.colaborators.firstWhere(
                        (category) => category.id == 1,
                        orElse: () => Colaborator(id: "-1", name: model.isLoading ? "Aguarde..." : "Selecione"),
                      ),
                      items: (filter, infiniteScrollProps) => model.colaborators,
                      itemAsString: (Colaborator colaborator) => colaborator.name!,
                      compareFn: (item1, item2) => item1.id == item2.id, // Add this line for comparison
                      decoratorProps: const DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Colaborador ',
                          border: OutlineInputBorder(),
                        ),
                      ),
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
                const Gap(20),
                Consumer<ColaboratorProvider>(
                  builder: (context, model, child) {
                    return DropdownSearch<Colaborator>(
                      enabled: !model.isLoading,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        showSelectedItems: true,
                      ),
                      selectedItem: model.colaborators.firstWhere(
                        (category) => category.id == 1,
                        orElse: () => Colaborator(id: "-1", name: model.isLoading ? "Aguarde..." : "Selecione"),
                      ),
                      items: (filter, infiniteScrollProps) => model.colaborators,
                      itemAsString: (Colaborator colaborator) => colaborator.name!,
                      compareFn: (item1, item2) => item1.id == item2.id, // Add this line for comparison
                      decoratorProps: const DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Colaborador ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    );
                  }
                ),
                TextFormField(
                  controller: controllers["valor"]!,
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


