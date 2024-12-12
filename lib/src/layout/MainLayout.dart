import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:sistema_loja/src/Helpers.dart';
import 'package:sistema_loja/src/shared/SharedTheme.dart';

class MainLayout extends StatefulWidget {
  MainLayout({super.key, required this.child});

  final Widget child;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final _formKey = GlobalKey<FormState>();  

  void _submitForm() {
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Nada encontrado... Por enquanto'),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return Scaffold(
        key: _scaffoldKey,
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/img/logo.png',
                    height: 40,
                  ),
                  const Gap(10),
                  SelectableText(dotenv.env['TITLE'] ?? 'Sistema da loja'),
                ],
              ),
              isLargeScreen ? mainMenu() : Container(),
            ],
          ),
          leading: isLargeScreen ? null : IconButton(
            icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
      ),
      drawer: isLargeScreen ? null : Drawer(
        child: mainMenu(isLargeScreen: isLargeScreen),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: isLargeScreen ? 50 : null,
            color: Color.fromRGBO(197, 197, 197, 1),
            child: isLargeScreen 
              ? Row(
                children: [
                  TextButton(onPressed: () {}, child: Text("MAIS VENDIDOS")),
                  busca(isLargeScreen, _formKey, _submitForm)
                ],
              ) 
              : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(onPressed: () { debugPrint('Mais vendidos'); }, child: Text("MAIS VENDIDOS")),
                  busca(isLargeScreen, _formKey, _submitForm),
                ],
              ),
          ),
          widget.child,
        ],
      ),
    );
  }
}


Widget mainMenu({bool isLargeScreen = true}) {
  final List<String> labels = ["Vendas", "Cadastro", "Clientes", "Produtos"];
  List<VoidCallback> links(index) {
    return [
      () {
        debugPrint("botão $index clicado!");
      },
      () {
        debugPrint("botão $index clicado!");
      },
      () {
        debugPrint("botão $index clicado!");
      },
      () {
        debugPrint("botão $index clicado!");
      },
    ];
  }
  List<Widget> buttons() {
    return labels.asMap().entries.map((entry) {
      int index = entry.key;
      String label = entry.value;

      // Utilize o index e o label para criar seus widgets
      return isLargeScreen 
        ? TextButton(
          onPressed: links(index)[index],
          child: Text(label),
        )
        : ListTile(
          title: Text(label),
          onTap: links(index)[index],
        );
    }).toList();
  }
  
  return Helpers.responsiveMenu(
    isLargeScreen: isLargeScreen,
    children: buttons()
  );
}

Widget busca(isLargeScreen, formKey, submitForm) {
  Widget containerForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 5 : 20, vertical: 8.0),
      height: 34,
      width: isLargeScreen ? 300 : null,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: !isLargeScreen ? "Pesquisar..." : "",
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.5,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
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
        onEditingComplete: submitForm,
      ),
    );
  }
  
 return Form(
    key: formKey,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              !isLargeScreen ? Container() : Row(
                children: [
                  Text("PESQUISAR:", style: TextStyle(color: SharedTheme.secondaryColor, fontWeight: FontWeight.bold)),
                  Gap(4),
                ],
              ),
              isLargeScreen ? containerForm() : Expanded(
                child: containerForm()
              ),
            ],
          ),
        ],
      ),
    )
  );
}