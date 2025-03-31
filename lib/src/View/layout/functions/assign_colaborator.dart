import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/Model/colaborator_dto.dart';
import 'package:racoon_tech_panel/src/View/components/searchable_menu.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/colaborators_functions.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ColaboratorProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/ColaboratorRepository.dart';


ValueNotifier<Colaborator?>colaboratorAssigned = ValueNotifier<Colaborator?>(null);

Future<void> assignUserToColaboratorDialog(BuildContext context) async {
    final colaboratorModel = Provider.of<ColaboratorProvider>(context, listen: false);
    
    if(colaboratorModel.currentLogin.details!.role == 'admin') {
      colaboratorModel.setHasColaboratorAssigned(true);
      
      return;
    }
    await fetchColaborators(context, assigned: false);

    if(colaboratorModel.currentLogin.details?.colaboratorId == null) {
        colaboratorAssigned.value = null;
        colaboratorModel.setHasColaboratorAssigned(false);
    } else {
      colaboratorModel.setHasColaboratorAssigned(true);
    }


    if(colaboratorModel.hasColaboratorAssigned) return;
        
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Assinatura de colaborador'),
          content: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SelectableText('O usuário não está atribuido a nenhum colaborador, por favor assine um colaborador para continuar.'),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(onPressed: () {
                    context.pop();
                    context.go('/');
                  }, child: Text("Encerrar sessão")),
                  ElevatedButton(
                    onPressed: () {
                      context.pop();
                      assignUserToColaboratorForm(context);
                    }, 
                    child: Text("Assinar agora")
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }

Future<void> assignUserToColaboratorForm(BuildContext context) async {
  
  final colaboratorModel = Provider.of<ColaboratorProvider>(context, listen: false);

  final TextEditingController _controller = TextEditingController();

  colaboratorAssigned.addListener(() {
    if (colaboratorAssigned.value != null) {
      _controller.text = colaboratorAssigned.value!.name ?? ''; // Atualiza o texto
    }
  });
  
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Assinatura de colaborador'),
        content: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.expand_more),
                  labelText: 'Colaborador',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "Campo obrigatório";
                  }
                  return null;
                },
                style: const TextStyle(fontSize: 16),
                readOnly: true,
                controller: _controller,
                onTap: () async {
                  colaboratorAssigned.value?.name = '';
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SearchableMenu(
                        model: colaboratorModel, 
                        selectCb: (Colaborator colaborator) {
                          colaboratorAssigned.value = colaborator;
                        }, 
                        fetchCb: (String? searchTerm) async {
                          await fetchColaborators(context, searchTerm: searchTerm);
                        }, 
                        items: colaboratorModel.colaborators
                      );
                    }
                  );
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if(colaboratorAssigned.value != null) {
                    final userId = colaboratorModel.currentLogin.details!.id!;
                    final colaboratorId = colaboratorAssigned.value!.id!;
                    
                    final response = await ColaboratorRepository.assignColaboratorToUser(colaboratorId: colaboratorId, userId: userId);

                    if(response.status != 200) {
                      return;
                    }

                    colaboratorModel.setHasColaboratorAssigned(true);
                    context.pop();
                    await Future.delayed(Duration(milliseconds: 100));

                    context.go('/dashboard');
                  }
                }, 
                child: Text("Assinar")
            )
          ],
        ),
      );
    }
  );
}