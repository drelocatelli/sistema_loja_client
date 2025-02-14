import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:racoon_tech_panel/src/Model/vendas_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';
import 'package:widget_zoom/widget_zoom.dart';

vendaDetails(BuildContext context, Venda sale) {

  showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: Text("Detalhes da venda"),
        content: SizedBox(
          width: 600,
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText.rich(
                TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(text: 'Data da venda: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: sale.date! + "\n"),
                    
                    TextSpan(text: 'Serial: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: sale.serial),

                    TextSpan(text: '\n\nProduto: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: sale.product!.name),

                    TextSpan(text: '\nCategoria: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: (sale.product!.category?.name ?? 'Sem categoria') + "\n\n"),

                    TextSpan(text: 'Cliente: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: sale.client!.name! + "\n"),

                    TextSpan(text: 'Responsável pela venda: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: sale.colaborator!.name! + "\n"),

                    TextSpan(text: '\nPreço unitário: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: (sale.product?.price != null && sale.product!.price!.isNaN) 
                      ? "Erro" 
                      : "R\$ ${(sale.product!.price ?? 0).toStringAsFixed(2).replaceAll('.', ',')}"
                    ),

                    TextSpan(text: '\nQuantidade vendida: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: (sale.total != null && sale.total!.isNaN) 
                      ? "Erro" 
                      : "${sale.total}"),

                    TextSpan(text: '\nValor total: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: (sale.product?.price != null && sale.total != null && !sale.total!.isNaN)
                          ? "R\$ ${(sale.product!.price! * sale.total!).toStringAsFixed(2).replaceAll('.', ',')}"
                          : "Erro",
                    ),

                    TextSpan(text: '\n\nDescrição: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: (sale.product?.description ?? 'Sem descrição')),
                    
                  ]
                )
              ),
              Divider(),
              if(sale.product!.photos!.length == 0) Text("Produto sem imagens") else Wrap(
                children: List.generate(sale.product!.photos!.length, (index) => MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: WidgetZoom(
                    heroAnimationTag: 'tag', 
                    zoomWidget: Image.network('${BaseRepository.baseStaticUrl}/${sale.product!.photos![index]}', 
                    height: 100, 
                    width: 100
                  )
                ))
              )
              ),
            ],
          ),
        ),
      );
    }
  );
}