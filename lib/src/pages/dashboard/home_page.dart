import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: const Column(
        children: [
          Text('Home'),
        ],
      ),
    );
  }
}
