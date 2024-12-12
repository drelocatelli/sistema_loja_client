import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:racoon_tech_panel/src/pages/home.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';

// void main() {
//   runApp(const MyApp());
// }
Future main() async {
  await dotenv.load(fileName: ".env.dev");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: SharedTheme.main(),
      title: dotenv.env['TITLE'],
      home: const Home(),
    );
  }
}
