import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/View/helpers.dart';

class ProductTitle extends StatelessWidget {
  const ProductTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    
    return Helpers.rowOrWrap(
      wrap: maxWidth <= 800,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10,
          children: [
            Text('Gerenciar produtos', style: Theme.of(context).textTheme.headlineMedium),
            ElevatedButton(
              onPressed: () {
              }, 
              child: const Text('Adicionar produto')
            ),
          ],
        ),
        Align(alignment: Alignment.topRight, child: _pesquisa(maxWidth)),
      ],
    );
  }
}

Widget _pesquisa(double maxWidth) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0, top: 8),
    child: SizedBox(
      width: maxWidth >= 800 ? 400 : null,
      child: Row(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: DropdownButtonFormField(
              value: 'nome',
              onChanged: (String? value) {
              },
              decoration: const InputDecoration(
                  labelText: 'Buscar por:',
                  border: OutlineInputBorder(), 
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                  isDense: true
                ),
                items: const [
                  DropdownMenuItem(value: 'nome', child: Text('Nome')),
                  DropdownMenuItem(value: 'descrição', child: Text('Descrição')),
                  DropdownMenuItem(value: 'categoria', child: Text('Categoria')),
                ]
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFormField(
             decoration: const InputDecoration(
                hintText: 'Digite sua busca',
                border: OutlineInputBorder(), 
                suffixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                isDense: true
              ),
            ),
          ),
        ],
      ),
    ),
  );
}