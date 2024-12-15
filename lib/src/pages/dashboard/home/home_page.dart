import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home/components/previsao_fluxo.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home/components/recebimentos.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home/components/relatorios.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, bool> _isShowing = {
    "recebimentos": false,
    "pagamentos": false,
    "problemas": false,
  };
  
  bool previsaoShowing = true;
  bool relatoriosShowing = true;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Visibility(
            visible: previsaoShowing,
            child: previsaoFluxo(
              () {
                _isShowing = _isShowing.map((key, value) {
                  if (key == 'relatorios') {
                    return MapEntry(key, value);
                  }
                  // Update other keys to false
                  return MapEntry(key, false);
                });
                relatoriosShowing = !relatoriosShowing;
                setState(() {});
              }, 
              () {
                _isShowing = _isShowing.map((key, value) {
                  if (key == 'recebimentos') {
                    return MapEntry(key, value);
                  }
                  // Update other keys to false
                  return MapEntry(key, false);
                });
                _isShowing['recebimentos'] = !_isShowing['recebimentos']!;
                setState(() {});
              },
              () {
                _isShowing = _isShowing.map((key, value) {
                  if (key == 'pagamentos') {
                    return MapEntry(key, value);
                  }
                  // Update other keys to false
                  return MapEntry(key, false);
                });
                _isShowing['pagamentos'] = !_isShowing['pagamentos']!;
                setState(() {});
              },
              () {
                 _isShowing = _isShowing.map((key, value) {
                  if (key == 'problemas') {
                    return MapEntry(key, value);
                  }
                  // Update other keys to false
                  return MapEntry(key, false);
                });
                _isShowing['problemas'] = !_isShowing['problemas']!;
                setState(() {});
              }
            , relatoriosShowing, _isShowing['recebimentos']!, _isShowing['pagamentos']!, _isShowing['problemas']!),
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
            child: relatoriosShowing
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
