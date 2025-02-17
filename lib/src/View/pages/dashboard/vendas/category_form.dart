import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/CategoryRepository.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({super.key});

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {

  TextEditingController categoryName = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: categoryName,
                decoration: const InputDecoration(
                  label: Text("Título")
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final response = await CategoryRepository.create(categoryName.text);
                  if(response.status != 200) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Não foi possível criar categoria")));
                  }
                  context.pop();
                }, 
                child: const Text("Salvar categoria")
              )
            ],
          )
        )
      ],
    );
  }
}