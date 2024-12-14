import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Text("Clientes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}