import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:racoon_tech_panel/src/dto/vendas_dto.dart';
import 'package:racoon_tech_panel/src/helpers.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/vendas/components/vendas_search.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';

class VendasTitle extends StatelessWidget {
  const VendasTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return 
        Row(
        spacing: 10,
        children: [
          Text('Gerenciar vendas', style: Theme.of(context).textTheme.headlineMedium),
          ElevatedButton(
            onPressed: () {
              _novaVendaDialog(context);
            }, 
            child: const Text('Adicionar nova venda')
          ),
          
      ]
    );
  }
}

_novaVendaDialog(BuildContext context) {
  final maxWidth = MediaQuery.of(context).size.width;

  Venda venda;

  Map<String, TextEditingController> controllers = {
    "data": TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now())),
    "produto": TextEditingController(),
    "responsavel": TextEditingController(),
    "valor": TextEditingController(),
    "categoria": TextEditingController(),
  };

  selectDate(BuildContext context) async {
    
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if(picked! != null) {
      controllers["data"]!.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }
  
  showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text('Nova venda'),
        content: SizedBox(
          width: maxWidth / 3,
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
                            controller: controllers["produto"],
                            decoration: const InputDecoration(labelText: 'Produto'),
                          ),
                        ),
                        DropdownMenu(
                          controller: controllers["categoria"]!,
                          width: maxWidth < 800 ? double.infinity : null,
                          enableFilter: true,
                          label: const Text("Categoria"),
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: 1, label: "Categoria 1"),
                            DropdownMenuEntry(value: 2, label: "Categoria 2"),
                            DropdownMenuEntry(value: 3, label: "Categoria 3"),
                          ],
                        ),
                      ],
                    ),
                    
                    TextFormField(
                      controller: controllers["valor"]!,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Valor', prefixText: 'R\$ '),
                    ),
                    TextFormField(
                      controller: controllers["data"]!,
                      onTap: () => selectDate(context),
                       decoration: InputDecoration(
                          labelText: "Data",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => selectDate(context),
                          ),
                        ),
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
          ),
        ),
      );
    }
  );
}