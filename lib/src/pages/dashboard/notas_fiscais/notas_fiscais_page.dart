import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/dto/nfe_dto.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/notas_fiscais/components/nfe_form.dart';

class NotasFiscaisPage extends StatelessWidget {
  const NotasFiscaisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SelectionArea(
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Notas Fiscais",
                style: Theme.of(context).textTheme.headlineMedium),
            nfeForm(context, nfeDetails: NFeDTO(number: "693983", serie: "25", entradaOuSaida: NFeEntradaSaidaEnum.ENTRADA))
          ],
        ),
      ),
    );
  }
}

