import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/routes.dart';
import 'package:racoon_tech_panel/src/Model/app_mode.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/CategoryProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ClientProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ProductProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/ColaboratorProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/providers/SalesProvider.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';
import 'package:url_strategy/url_strategy.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  // set dotenv
  await dotenv.load(fileName: ".env");
  final appMode = dotenv.env['APP_MODE'] ?? AppMode.production;

  if(appMode == AppMode.development) {
    await dotenv.load(fileName: ".env.dev");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ColaboratorProvider()),
        ChangeNotifierProvider(create: (_) => ProdutoProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
