import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home/components/pagamentos.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home/components/problems.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home/components/recebimentos.dart';

Widget previsaoFluxo(VoidCallback fnRelatorios, VoidCallback fnRecebimentos, VoidCallback fnPagamentos, VoidCallback fnProblems, bool relatoriosShowing, bool recebimentosShowing, bool pagamentosShowing, bool problemsShowing) {
 
   Widget box(maxWidth, Color color, IconData icon, bool isShowing, {required String value, required String title, required VoidCallback fn}) {
    return Container(
      width: maxWidth,
      height: 110,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 8,
                  children: [
                    Text(value, style: TextStyle(fontSize: 20, color: Colors.white)),
                    Text(title, style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w300)),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            width: maxWidth,
            height: 40,
            child: Container(
              color: color,
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: InkWell(onTap: fn , child: Row(
                  children: [
                    Text(isShowing ? "Ocultar detalhes" :  "Ver detalhes", style: TextStyle(color: Colors.white)),
                    Icon(isShowing ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.white),
                  ],
                )),
              )
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 6)],
        color: color.withOpacity(.8),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }

  List<Widget> columns(double maxWidth) {
    return [
      box(title: "Recebimentos Previstos (R\$)", value: "R\$ 1.000,00", maxWidth, Colors.green, Icons.arrow_upward_sharp, fn: fnRecebimentos, recebimentosShowing),
      box(title: "Pagamentos Previstos (R\$)", value: "R\$ 4.089,00", maxWidth, Colors.orange, Icons.arrow_downward_sharp, fn: fnPagamentos, pagamentosShowing),
      box(title: "Recebimentos - Pagamentos (R\$)", value: "- R\$ 324,00",maxWidth, Colors.red, Icons.warning, fn: fnProblems, problemsShowing),
    ];
  }

  return SelectionArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text("Previsão de fluxo de caixa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
            OutlinedButton(onPressed: fnRelatorios, child: Text(relatoriosShowing ? 'Ocultar relatórios' : "Mostrar relatórios"))
          ],
        ),
        const Gap(20),
        LayoutBuilder(
          builder: (context, constraints) {
            debugPrint(constraints.maxWidth.toString());
            return constraints.maxWidth >= 800 
            ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: columns(constraints.maxWidth).map((element) => Expanded(child: element)).toList()
            )
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: columns(constraints.maxWidth)
            );
          }
        ),
        Gap(20),
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
            child:  recebimentosShowing 
              ? Recebimentos()
              : SizedBox()
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
            child:  pagamentosShowing 
              ? Pagamentos()
              : SizedBox()
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
            child:  problemsShowing 
              ? Problems()
              : SizedBox()
          ),

      ],
    ),
  );
}