import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:racoon_tech_panel/src/View/components/loading_screen.dart';
import 'package:racoon_tech_panel/src/View/components/main_menu.dart';
import 'package:racoon_tech_panel/src/View/layout/functions/assign_colaborator.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';

class MainLayout extends StatefulWidget {
  MainLayout({super.key, required this.child, this.padding, this.isLoading, this.floatingActionButton});

  final Widget child;
  final EdgeInsets? padding;
  final bool? isLoading;
  Widget? floatingActionButton;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final _formKey = GlobalKey<FormState>();  

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = SharedTheme.isLargeScreen(context);

    return LoadingScreen(
      isLoading: widget.isLoading,
      child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton: widget.floatingActionButton,
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
                isLargeScreen ? mainMenu(context) : Container(),
              ],
            ),
            leading: isLargeScreen ? null : IconButton(
              icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
        ),
        drawer: isLargeScreen ? null : Drawer(
          child: mainMenu(context, isLargeScreen: isLargeScreen),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 15.0, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.child,
              ],
            ),
          ),
        ),
      ),
    );
  }
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
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.5,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.5,
            ),
          ),
          border: const UnderlineInputBorder(
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
                  const Gap(4),
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