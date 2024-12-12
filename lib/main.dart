import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:racoon_tech_panel/routes.g.dart';
import 'package:racoon_tech_panel/app/dashboard/home_page.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';
import 'package:routefly/routefly.dart';

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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: SharedTheme.main(),
      title: dotenv.env['TITLE'],
      routerConfig: Routefly.routerConfig(
        routes: routes,
        initialPath: '/login',
        routeBuilder: (context, settings, child) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) => child,
            transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
          );
        }
      ),
    );
  }
}
