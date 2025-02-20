import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:racoon_tech_panel/src/Model/category_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/functions/categories_functions.dart';
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
  void dispose() {
    categoryName.dispose();
    super.dispose();
  }
  
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
                autofocus: true,
                controller: categoryName,
                decoration: const InputDecoration(
                  label: Text("Título da categoria")
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "Campo obrigatório";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if(!_formKey.currentState!.validate()) return;
                  
                  final response = await CategoryRepository.create(categoryName.text);
                  if(response.status != 200) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Não foi possível criar categoria")));
                  }
                  
                  await fetchCategories(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Categoria criada com sucesso")));

                  _formKey.currentState!.reset();
                }, 
                child: const Text("Adicionar categoria")
              )
            ],
          )
        )
      ],
    );
  }
}