import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:racoon_tech_panel/src/Model/nfe_dto.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/clients/clients_page.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/estoque/product_page.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/home/home_page.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/logs/logs.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/notas_fiscais/nfe_generated.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/notas_fiscais/notas_fiscais_page.dart';
import 'package:racoon_tech_panel/src/View/pages/dashboard/vendas/vendas_page.dart';
import 'package:racoon_tech_panel/src/View/pages/login/login_page.dart';

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
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/', 
      pageBuilder: (context, state) =>  _noTransitionRoute(LoginPage())
    ),
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) => _noTransitionRoute(HomePage()),
      routes: [
        GoRoute(
            path: 'clientes',
            pageBuilder: (context, state) => _noTransitionRoute(const ClientsPage()),
          ),
          GoRoute(
            path: 'nfe',
            pageBuilder: (context, state) => _noTransitionRoute(NotasFiscaisPage()),
            routes: [
              GoRoute(
                path: 'gerada',
                pageBuilder: (context, state) {
                  final nfeDetails = state.extra as NFeDTO?;
                  return _noTransitionRoute(NFeGenerated(context, nfeDetails: nfeDetails));
                }
              ),
            ]
          ),
          GoRoute(
            path: 'vendas',
            pageBuilder: (context, state) => _noTransitionRoute(const VendasPage()),
          ),
          GoRoute(
            path: 'produtos',
            pageBuilder: (context, state) => _noTransitionRoute(const ProductPage()),
          ),
          GoRoute(
            path: 'logs',
            builder: (context, state) => LogsPage(),
            // pageBuilder: (context, state) => _noTransitionRoute(const VendasLogs()),
          )
        ],
    ),
    
  ]
);