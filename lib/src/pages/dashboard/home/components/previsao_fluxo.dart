import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Widget previsaoFluxo(VoidCallback fnRelatorios, bool relatoriosShowing) {
 
   Widget box(maxWidth, Color color, IconData icon, {required String value, required String title}) {
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
                child: InkWell(onTap: () {} , child: Row(
                  children: [
                    Text("Ver detalhes", style: TextStyle(color: Colors.white)),
                    Icon(Icons.arrow_right, color: Colors.white)
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
      box(title: "Recebimentos Previstos (R\$)", value: "R\$ 1.000,00", maxWidth, Colors.green, Icons.arrow_upward_sharp),
      box(title: "Pagamentos Previstos (R\$)", value: "R\$ 4.089,00", maxWidth, Colors.orange, Icons.arrow_downward_sharp),
      box(title: "Recebimentos - Pagamentos (R\$)", value: "- R\$ 324,00",maxWidth, Colors.red, Icons.warning),
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
              spacing: 10,
              children: columns(constraints.maxWidth).map((element) => Expanded(child: element)).toList()
            )
            : Column(
              spacing: 10,
              children: columns(constraints.maxWidth)
            );
          }
        ),
      ],
    ),
  );
}