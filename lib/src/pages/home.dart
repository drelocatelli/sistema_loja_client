import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/layout/MainLayout.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          Text('Home'),
        ],
      ),
    );
  }
}
