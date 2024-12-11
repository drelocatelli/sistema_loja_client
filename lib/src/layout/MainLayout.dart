import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:sistema_loja/src/shared/SharedTheme.dart';

class MainLayout extends StatefulWidget {
  MainLayout({super.key, required this.child});

  final Widget child;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final _formKey = GlobalKey<FormState>();  

  void _submitForm() {
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Nada encontrado... Por enquanto'),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/img/logo.png',
                height: 40,
              ),
              const Gap(10),
              SelectableText(dotenv.env['TITLE'] ?? 'Sistema da loja'),
            ],
          ),
          actions: [
            TextButton(onPressed: () {}, child: Text("Vendas")),
            TextButton(onPressed: () {}, child: Text("Cadastro")),
            TextButton(onPressed: () {}, child: Text("Clientes")),
            TextButton(onPressed: () {}, child: Text("Produtos")),
          ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: Color.fromRGBO(197, 197, 197, 1),
            child: Row(
              children: [
                TextButton(onPressed: () {}, child: Text("MAIS VENDIDOS")),
                Gap(10),
                Text("PESQUISAR:", style: TextStyle(color: SharedTheme.secondaryColor, fontWeight: FontWeight.bold)),
                Gap(5),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Gap(4),
                            Container(
                              width: 200,
                              height: 34,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                    ),
                                  ),
                                ),
                                onEditingComplete: _submitForm,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                )
              ],
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}
