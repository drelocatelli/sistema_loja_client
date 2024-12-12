import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home_page.dart';
import 'package:racoon_tech_panel/src/pages/login/login_page.dart';

final routes = [
  GetPage(name: '/', page: () => HomePage()),
  GetPage(name: '/login', page: () => LoginPage()),
];