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

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    String selectedCategoryId = "";

    final categories = [
      {"id": "1", "name": "Categoria 1"},
      {"id": "2", "name": "Categoria 2"},
      {"id": "3", "name": "Categoria 3"},
    ];

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
                  TextFormField(
                    controller: controllers["category"],
                    decoration: const InputDecoration(labelText: 'Categoria'),
                    readOnly: true,
                    onTap: () {
                      showSelectableModal(
                        context: context,
                        mappedItems: categories,
                        keyName: 'id',
                        labelName: 'name',
                        searchBody: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Buscar por:',
                            border: OutlineInputBorder(), 
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                            isDense: true
                          ),
                        ),
                        selectCategoryCb: (String categorySelectedId) {
                            controllers["category"]!.text = categories.firstWhere((element) => element['id'] == categorySelectedId)['name'].toString();

                            selectedCategoryId = categorySelectedId;
                            setState(() {});
                        }
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
        )
      ],
    );
  }
}


