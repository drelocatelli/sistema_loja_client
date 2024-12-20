import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home/components/pagamentos.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home/components/problems.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/home/components/recebimentos.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';

Widget previsaoFluxo(
    BuildContext context,
    VoidCallback fnRelatorios,
    VoidCallback fnRecebimentos,
    VoidCallback fnPagamentos,
    VoidCallback fnProblems,
    bool relatoriosShowing,
    bool recebimentosShowing,
    bool pagamentosShowing,
    bool problemsShowing) {
  double maxWidth = MediaQuery.of(context).size.width;

  Widget box(maxWidth, Color color, IconData icon, bool isShowing,
      {required String value,
      required String title,
      required VoidCallback fn}) {
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
                    Text(value,
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    Text(title,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w300)),
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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: InkWell(
                      onTap: fn,
                      child: Row(
                        children: [
                          Text(isShowing ? "Ocultar detalhes" : "Ver detalhes",
                              style: TextStyle(color: Colors.white)),
                          Icon(
                              isShowing
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: Colors.white),
                        ],
                      )),
                )),
          )
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 6)
        ],
        color: color.withOpacity(.8),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }

  List<Widget> columns(double maxWidth) {
    return [
      Column(
        children: [
          box(
              title: "Receita (R\$)",
              value: "R\$ 1.000,00",
              maxWidth,
              Colors.green,
              Icons.arrow_upward_sharp,
              fn: fnRecebimentos,
              recebimentosShowing),
          Visibility(visible: !SharedTheme.isLargeScreen(context), child: _recebimentosCard(recebimentosShowing, padding: EdgeInsets.only(top: 20))),
        ],
      ),
      Column(
        children: [
          box(
              title: "Despesa (R\$)",
              value: "- R\$ 324,00",
              maxWidth,
              Colors.red,
              Icons.warning,
              fn: fnProblems,
              problemsShowing),
            Visibility(visible: !SharedTheme.isLargeScreen(context), child: _problemsCard(problemsShowing, padding: EdgeInsets.only(top: 20))),
        ],
      ),
      Column(
        children: [
          box(
              title: "Saída (R\$)",
              value: "R\$ 4.089,00",
              maxWidth,
              Colors.orange,
              Icons.attach_money,
              fn: fnPagamentos,
              pagamentosShowing),
          Visibility(visible: !SharedTheme.isLargeScreen(context), child: _pagamentosCard(pagamentosShowing, padding: EdgeInsets.only(top: 20))),
        ],
      ),
    ];
  }

  return SelectionArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text("Previsão de fluxo de caixa",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
            OutlinedButton(
                onPressed: fnRelatorios,
                child: Text(relatoriosShowing
                    ? 'Ocultar relatórios'
                    : "Mostrar relatórios"))
          ],
        ),
        const Gap(20),
        LayoutBuilder(builder: (context, constraints) {
          return constraints.maxWidth >= 800
              ? Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10,
                      children: columns(constraints.maxWidth)
                          .map((element) => Expanded(child: element))
                          .toList()),
                ],
              )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: columns(constraints.maxWidth));
        }),
        Gap(20),
        Visibility(
          visible: SharedTheme.isLargeScreen(context),
          child: Column(
            children: _cardContents(recebimentosShowing: recebimentosShowing, pagamentosShowing: pagamentosShowing, problemsShowing: problemsShowing),
          ),
        ),
      ],
    ),
  );
}

Widget _recebimentosCard(bool isShowing, {EdgeInsets padding = const EdgeInsets.all(0)}) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 200),
    switchInCurve: Curves.easeIn,
    switchOutCurve: Curves.easeOut,
    transitionBuilder:
        (Widget child, Animation<double> animation) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    child: isShowing ? Padding(
      padding: padding,
      child: Recebimentos(),
    ) : SizedBox());
}

Widget _pagamentosCard(bool isShowing, {EdgeInsets padding = const EdgeInsets.all(0)}) {
  return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder:
            (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: isShowing ? Padding(
          padding: padding,
          child: Pagamentos(),
        ) : SizedBox());
}

Widget _problemsCard(bool isShowing, {EdgeInsets padding = const EdgeInsets.all(0)}) {
  return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder:
            (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: isShowing ? Padding(
          padding: padding,
          child: Problems(),
        ) : SizedBox());
}



List<Widget> _cardContents({bool recebimentosShowing = false , bool pagamentosShowing = false, bool problemsShowing = false}) {
  return [
    _pagamentosCard(pagamentosShowing),
    _problemsCard(problemsShowing),
    _recebimentosCard(recebimentosShowing),
  ];
}