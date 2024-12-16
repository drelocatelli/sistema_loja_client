import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:racoon_tech_panel/src/components/dotted_line.dart';
import 'package:racoon_tech_panel/src/dto/nfe_dto.dart';

Widget nfeGenerated(BuildContext context, {required NFeDTO nfeDetails}) {
  debugPrint(jsonEncode(nfeDetails));
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _nfeHeader(context, nfeDetails: nfeDetails),
      Gap(18),
      DottedLine(width: Get.width),
      Gap(10),
      _nfeBody(context, nfeDetails: nfeDetails),
    ],
  );
}

Widget _nfeBody(BuildContext context, {required NFeDTO nfeDetails}) {
  return rowOrWrap(
    children: [
      Container(
        width: Get.width >= 800 ? Get.width / 2 : Get.width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: Get.width <= 800 ? 10 : 0),
        child: SelectableText.rich(
          TextSpan(
            text: dotenv.env['TITLE'] ?? 'Sistema da loja',
            children: [
              TextSpan(text:  "\n${dotenv.env['ENDERECO']}".toUpperCase(),  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
            ],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
          )
        ),
      ),
      SizedBox(
        width: Get.width >= 800 ? 200 : null,
        child: box(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("DANFE", style: Theme.of(context).textTheme.headlineMedium),
              smallText("DOCUMENTO AUXILIAR DA NOTA FISCAL ELETRÔNICA"),
              Row(
                spacing: 10,
                mainAxisAlignment: Get.width >= 800 ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallText("0 - ENTRADA"),
                      smallText("1 - SAÍDA"),
                    ],
                  ),
                  box(child: Text(nfeDetails.entradaOuSaida.value.toString()))
                ],
              ),
              Gap(5),
              SelectableText.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "N° ${nfeDetails.number}\n"),
                    TextSpan(text: "Série ${nfeDetails.serie}\n"),
                    TextSpan(text: "Folha ${nfeDetails.folha}"),
                  ],
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ),
            ],
          )
        ),
      )
    ],
  );
}

Widget _nfeHeader(BuildContext context, {required NFeDTO nfeDetails}) {
return Column(
    children: [
      rowOrWrap(
        children: [
          Expanded(
            flex: Get.width >= 800 ? 6 : 1,
            child: box(
              child: smallText(
                  "RECEBEMOS DE ${dotenv.env["TITLE"]?.toUpperCase() ?? 'Sistema da loja'} OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA ABAIXO"),
            ),
          ),
          Expanded(
            flex: Get.width >= 800 ? 1 : 1,
            child: box(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Get.width >= 800 ? Alignment.center : Alignment.centerLeft,
                      child: Text('NF-e',
                          style: Theme.of(context).textTheme.headlineMedium)),
                  SelectableText.rich(
                    TextSpan(
                      style: TextStyle(
                          fontSize: 16, color: Colors.black), // Default style
                      children: [
                        TextSpan(
                            text: "N°: ${nfeDetails.number}\n",
                            style: TextStyle(fontSize: 12)),
                        TextSpan(
                            text: "Série: ${nfeDetails.serie}",
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            box(
                child: Column(
              children: [
                smallText("DATA DE RECEBIMENTO"),
                smallText(nfeDetails.recebimentoDate)
              ],
            )),
            Expanded(
              child: box(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  smallText("IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR"),
                  smallText(nfeDetails.idEAssinaturaDoRecebedor)
                ],
              )),
            )
          ],
        ),
      ),
    ],
  );
}

Widget rowOrWrap({required List<Widget> children}) {
  final wrapChildren = children.map((widget) {
    if (widget is Expanded) {
      return widget.child; // Return the child of the `Expanded` widget
    }
    return widget; // Return the widget as-is if it's not `Expanded`
  }).toList();
  
  return Get.width >= 800
      ? IntrinsicHeight(
        child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children),
      )
      : Wrap(children: wrapChildren);
}

Widget smallText(String text) {
  return Text(text, style: TextStyle(fontSize: 12));
}

Widget box({required Widget child}) {
  return Container(
    child: child,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
    ),
    padding: EdgeInsets.all(10),
  );
}
