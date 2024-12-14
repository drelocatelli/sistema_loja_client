import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home/components/previsao_fluxo.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home/components/relatorios.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, bool> _isShowing = {
    "previsao": true,
    "relatorios": true,
  };

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Visibility(
            visible: _isShowing['previsao']!,
            child: previsaoFluxo(() {
              _isShowing['relatorios'] = !_isShowing['relatorios']!;
              setState(() {});
            }, _isShowing['relatorios']!),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: _isShowing['relatorios']!
                ? Container(
                    key: ValueKey(
                        'relatorios'), // Chave única para diferenciar os estados
                    child: relatorios(),
                  )
                : SizedBox(
                    key: ValueKey('empty'), // Chave para o widget vazio
                  ),
          ),
        ],
      ),
    );
  }
}
