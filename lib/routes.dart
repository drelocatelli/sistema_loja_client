import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/clients/clients_page.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home/home_page.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/notas_fiscais/notas_fiscais_page.dart';
import 'package:racoon_tech_panel/src/pages/login/login_page.dart';

final routes = [
  GetPage(name: '/dashboard', page: () => HomePage()),
  GetPage(name: '/dashboard/clientes', page: () => ClientsPage()),
  GetPage(name: '/dashboard/nfe', page: () => NotasFiscaisPage()),
  GetPage(name: '/login', page: () => LoginPage()),
];