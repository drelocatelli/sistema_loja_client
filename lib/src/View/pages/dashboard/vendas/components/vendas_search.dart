import 'package:flutter/material.dart';

class VendasSearch extends StatelessWidget {
  const VendasSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SizedBox(
          width: maxWidth >= 800 ? 400 : null,
          child: Row(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: DropdownButtonFormField(
                  value: 'produto',
                  onChanged: (String? value) {
                  },
                  decoration: const InputDecoration(
                      labelText: 'Buscar por:',
                      border: OutlineInputBorder(), 
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                      isDense: true
                    ),
                    items: const [
                      DropdownMenuItem(value: 'cliente', child: Text('Cliente')),
                      DropdownMenuItem(value: 'produto', child: Text('Produto')),
                      DropdownMenuItem(value: 'categoria', child: Text('Categoria')),
                      DropdownMenuItem(value: 'responsavel', child: Text('Responsável')),
                    ]
                ),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  autofocus: true,
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
      ),
    );
  }
}