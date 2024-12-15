import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:racoon_tech_panel/src/dto/main_menu_dto.dart';
import 'package:racoon_tech_panel/src/helpers.dart';

Widget mainMenu({bool isLargeScreen = true}) {
  final menus = [
    new MainMenuDTO(label: "Geral", fn: () => Get.toNamed('/dashboard')),
    new MainMenuDTO(
      label: "Vendas", 
      fn: () => debugPrint("Vendas"),
      submenu: [
        SubmenuDTO(label: "Notas fiscais", fn: () => Get.toNamed('/dashboard/nfe')),
        SubmenuDTO(label: "Gerenciar vendas", fn: () => debugPrint('vendas')),
      ]
    ),
    // new MainMenuDTO(label: "Notas Fiscais", fn: () => Get.offNamed('/dashboard/nfe')),
    new MainMenuDTO(label: "Estoque", fn: () => debugPrint("Estoque")),
    new MainMenuDTO(label: "Clientes", fn: () => Get.toNamed('/dashboard/clientes')),
    new MainMenuDTO(label: "Colaboradores", fn: () => debugPrint("Colaboradores")),
    new MainMenuDTO(label: "Sair", fn: () => Get.offNamed('/login'))
  ];
  
  List<Widget> buttons() {
    return menus.asMap().entries.map((entry) {
      int index = entry.key;
      String label = entry.value.label;

      // Utilize o index e o label para criar seus widgets
      return isLargeScreen 
        ? TextButton(
          onPressed: entry.value.fn,
          child: entry.value.submenu != null 
            ? PopupMenuButton(
              tooltip: '',
              child: Row(
                children: [
                  Text(label),
                  entry.value.submenu != null ? Icon(Icons.arrow_drop_down) : Container(),
                ],
              ),
              itemBuilder: (BuildContext context) => entry.value.submenu!.map((e) => PopupMenuItem(
                child: Text(e.label),
                onTap: e.fn,
              )).toList(),
              offset: Offset(0, 28),
            )
            : Row(
              children: [
                Text(label),
              ],
            )
        )
        : entry.value.submenu != null 
        ? ExpansionTile(
          title: Text(label),
          children: entry.value.submenu?.map((e) => ListTile(
            title: Text(e.label),
            onTap: e.fn,
          )).toList() ?? [],
        )
        : ListTile(
          title: Text(label),
          onTap: entry.value.fn,
        );
    }).toList();
  }
  
  return Helpers.responsiveMenu(
    isLargeScreen: isLargeScreen,
    children: buttons()
  );
}