import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/clients/clients_page.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home/home_page.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/notas_fiscais/notas_fiscais_page.dart';
import 'package:racoon_tech_panel/src/pages/login/login_page.dart';

_fadeRoute(Widget page) {
  return CustomTransitionPage(
    transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
      opacity: animation,
      child: child
    ),
    child: page, 
  );
}

_scaleRoute(Widget page) {
  return CustomTransitionPage(
    transitionsBuilder: (context, animation, secondaryAnimation, child) => ScaleTransition(
      scale: animation,
      child: child
    ),
    child: page, 
  );
}

_noTransitionRoute(Widget page) {
  return CustomTransitionPage(
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    child: page, 
  );
}

final GoRouter routes = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
    path: '/dashboard',
    pageBuilder: (context, state) => _noTransitionRoute(HomePage()),
    routes: [
      GoRoute(
          path: 'clientes',
          pageBuilder: (context, state) => _noTransitionRoute(ClientsPage()),
        ),
        GoRoute(
          path: 'nfe',
          pageBuilder: (context, state) => _noTransitionRoute(NotasFiscaisPage()),
        ),
      ],
    ),
    GoRoute(
      path: '/login', 
      pageBuilder: (context, state) =>  _noTransitionRoute(LoginPage())
    ),
  ]
);