import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:racoon_tech_panel/routes.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';
import 'package:url_strategy/url_strategy.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await dotenv.load(fileName: ".env.dev");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: SharedTheme.main(),
      title: dotenv.env['TITLE'] ?? 'Painel da loja',
      defaultTransition: Transition.native,
      transitionDuration: Duration.zero,
      initialRoute: '/dashboard',
      getPages: routes,
    );
  }
}
