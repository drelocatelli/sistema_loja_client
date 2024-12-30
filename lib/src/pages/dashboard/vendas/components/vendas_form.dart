import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/dto/category_dto.dart';
import 'package:racoon_tech_panel/src/functions/categories_functions.dart';
import 'package:racoon_tech_panel/src/helpers.dart';
import 'package:racoon_tech_panel/src/providers/CategoryProvider.dart';
import 'package:racoon_tech_panel/src/repository/CategoryRepository.dart';

class VendasForm extends StatefulWidget {
  const VendasForm({super.key});

  @override
  State<VendasForm> createState() => _VendasFormState();
}

class _VendasFormState extends State<VendasForm> {

  bool _isLoading = true;

  Map<String, TextEditingController> controllers = {
    "category": TextEditingController(),
    "produto": TextEditingController(),
    "responsavel": TextEditingController(),
    "valor": TextEditingController(),
  };

  String selectedCategoryId = "1";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchCategories(context);
      await Future.delayed(Duration(milliseconds: 1500));
      _isLoading = false;
      setState(() {});
    });
  }

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [
        Visibility(
          visible: !_isLoading,
          replacement: Text("Aguarde um instante...", style: Theme.of(context).textTheme.bodyLarge),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Helpers.rowOrWrap(
                  wrap: maxWidth < 800,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controllers["produto"],
                        decoration: const InputDecoration(labelText: 'Produto'),
                      ),
                    ),
                    Consumer<CategoryProvider>(
                      builder: (context, model, child) {
                        return DropdownSearch<Category>(
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            showSelectedItems: true,
                            disabledItemFn: (Category item) => item.name.startsWith('I'),
                          ),
                          selectedItem: model.categories.firstWhere(
                            (category) => category.id == selectedCategoryId,
                            orElse: () => Category(id: "-1", name: "Selecione"),
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
                  controller: controllers["valor"]!,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Valor', prefixText: 'R\$ '),
                ),
                const Gap(20),
                DropdownMenu(
                  width: double.infinity,
                  enableFilter: true,
                  controller: controllers["responsavel"]!,
                  label: const Text("Responsável"),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 1, label: "Colaborador 1"),
                    DropdownMenuEntry(value: 2, label: "Colaborador 2"),
                    DropdownMenuEntry(value: 3, label: "Colaborador 3"),
                  ],
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
          ),
        )
      ],
    );
  }
}


