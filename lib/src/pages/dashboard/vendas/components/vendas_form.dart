import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:racoon_tech_panel/src/components/selectable_items.dart';
import 'package:racoon_tech_panel/src/helpers.dart';

class VendasForm extends StatefulWidget {
  const VendasForm({super.key});

  @override
  State<VendasForm> createState() => _VendasFormState();
}

class _VendasFormState extends State<VendasForm> {

  Map<String, TextEditingController> controllers = {
    "category": TextEditingController(),
    "produto": TextEditingController(),
    "responsavel": TextEditingController(),
    "valor": TextEditingController(),
  };

  final categories = [
    {
      "id": "1",
      "name": "categoria 1"
    },
    {
      "id": "2",
      "name": "categoria 2"
    },
    {
      "id": "3",
      "name": "categoria 3"
    }
  ];

  String selectedCategoryId = "1";

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
                      controller: controllers["produto"],
                      decoration: const InputDecoration(labelText: 'Produto'),
                    ),
                  ),
                  DropdownSearch<Map<String, String>>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      showSelectedItems: true,
                      disabledItemFn: (Map<String, String> item) => item["name"]!.startsWith('I'),
                    ),
                    selectedItem: categories.firstWhere(
                      (category) => category["id"] == selectedCategoryId,
                      orElse: () => categories[0],
                    ),
                    items: (filter, infiniteScrollProps) => categories,
                    itemAsString: (Map<String, String> category) => category["name"]!,
                    compareFn: (item1, item2) => item1["id"] == item2["id"], // Add this line for comparison
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: 'Categoria ',
                        border: OutlineInputBorder(),
                      ),
                    ),
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
        )
      ],
    );
  }
}


