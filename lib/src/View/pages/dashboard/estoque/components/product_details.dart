import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/Model/product_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/BaseRepository.dart';
import 'package:widget_zoom/widget_zoom.dart';

productDetails(BuildContext context, Produto product) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(product.name!),
        content: StatefulBuilder(
          builder: (context, StateSetter setState) {
            return SizedBox(
              width: 600,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText.rich(
                      TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const TextSpan(text: 'Titulo: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: product.name!.toLowerCase() + '\n'),
                
                          const TextSpan(text: 'Categoria: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: product.category!.name!.toLowerCase() + '\n'),
                
                          const TextSpan(text: 'Quantidade: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: "${product.quantity}\n"),

                          const TextSpan(text: 'Preço unitário: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: "R\$ ${(product.price ?? 0).toStringAsFixed(2).replaceAll('.', ',')}\n"),

                          const TextSpan(text: 'Total: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: (product.quantity != null &&
                                      product.price != null &&
                                      (product.quantity!.isNaN ||
                                          product.price!.isNaN))
                                  ? "Erro"
                                  : "R\$ ${(product.quantity! * product.price!).toStringAsFixed(2).replaceAll('.', ',')}\n"),
                          
                          const TextSpan(text: 'Visualização: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: "${product.isPublished! ? 'Publicado' : 'Anotação'}\n"),
                
                          const TextSpan(text: '\nDescricao: \n', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: product.description!.toLowerCase()),
                        ]
                      )
                    ),
                   Divider(),
                    if (product.photos!.length == 0) const Text('Sem imagens') else Wrap(
                      children: List.generate(product.photos!.length, (index) => MouseRegion(cursor: SystemMouseCursors.click, child: WidgetZoom(
                        heroAnimationTag: 'tag', 
                        zoomWidget: Image.network('${BaseRepository.baseStaticUrl}/${product.photos![index]}', 
                        height: 100, 
                        width: 100)
                      )))
                    )
                  ],
                ),
              ),
            );
          }
        ),
      );
    }
  );

}