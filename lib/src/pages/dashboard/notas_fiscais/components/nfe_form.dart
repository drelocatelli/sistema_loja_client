import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:racoon_tech_panel/src/dto/nfe_dto.dart';

Widget nfeForm(BuildContext context, {required NFeDTO nfeDetails}) {
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
  debugPrint('Layout: ${Get.width}');
  
  return Get.width >= 800
      ? IntrinsicHeight(
        child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children),
      )
      : Wrap(children: children);
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
