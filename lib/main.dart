import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: SharedTheme.main(),
      title: dotenv.env['TITLE'] ?? 'Painel da loja',
      routerDelegate: routes.routerDelegate,
      routeInformationParser: routes.routeInformationParser,
      routeInformationProvider: routes.routeInformationProvider,
      // getPages: routes,
      locale: Locale('pt', 'BR'),
      supportedLocales: [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
