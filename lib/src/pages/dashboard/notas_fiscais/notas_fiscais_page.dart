import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:racoon_tech_panel/src/dto/nfe_dto.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/notas_fiscais/nfe_generated.dart';
import 'package:racoon_tech_panel/src/utils/print_doc.dart';

class NotasFiscaisPage extends StatelessWidget {
  NotasFiscaisPage({super.key});

  final _formKey = GlobalKey<FormState>();
  bool isMinified = true;
  final bool _isPrinting = false;

  @override
  Widget build(BuildContext context) {
    bool isNfeGenerated = false;
    NFeDTO nfeFormValues = NFeDTO(entradaOuSaida: NFeEntradaSaidaEnum.ENTRADA);

    return MainLayout(
      child: SelectionArea(
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Notas Fiscais",
                style: Theme.of(context).textTheme.headlineMedium),
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    const Gap(20),
                    _form(context, _formKey, (NFeDTO? formValues) {
                      if(formValues == null) {
                          return;
                      }
                      setState(() {
                        nfeFormValues = formValues;
                        isNfeGenerated = true;
                      });
                    }),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}


Form _form(BuildContext context, GlobalKey<FormState> formKey, Function fnShowNfe) {
    final double width = MediaQuery.of(context).size.width;

  NFeDTO formValues = NFeDTO(entradaOuSaida: NFeEntradaSaidaEnum.ENTRADA);

  final Map<String, TextEditingController> controllers = {
    "number" : TextEditingController(text: formValues.number.toString()),
    "serie" : TextEditingController(text: formValues.serie.toString()),
    "recebimentoDate" : TextEditingController(text: formValues.recebimentoDate.isNotEmpty ? formValues.recebimentoDate : DateFormat('dd/MM/yyyy').format(DateTime.now())),
    "idEAssinaturaDoRecebedor" : TextEditingController(text: formValues.idEAssinaturaDoRecebedor.toString()),
    "entradaOuSaida" : TextEditingController(text: "0"),
    "folha" : TextEditingController(text: "1/1"),
  };

  String saidaOrEntrada = "0";

  selectDateRecebimento(BuildContext context) async {
    
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if(picked! != null) {
      controllers["recebimentoDate"]!.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }
  
  return Form(
    key: formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text("Gerar nota fiscal", style: Theme.of(context).textTheme.titleMedium),
        Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 50,
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly, // Allow only digits
              ],
                controller: controllers["number"],
                decoration: const InputDecoration(
                  labelText: "N°",
                ),
              ),
            ),
            SizedBox(
              width: 50,
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly, // Allow only digits
              ],
                controller: controllers["serie"],
                decoration: const InputDecoration(
                  labelText: "Série",
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controllers["idEAssinaturaDoRecebedor"],
                decoration: const InputDecoration(
                  labelText: "Identificação e assinatura do recebedor",
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            Flexible(
              flex: width >= 800 ? 3 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  // SizedBox(
                  //   child:InputDatePickerFormField(
                  //     fieldHintText: 'Data do recebimento',
                  //     fieldLabelText: 'Data do recebimento',
                  //     keyboardType: TextInputType.number,
                  //     firstDate: DateTime(2000),
                  //     initialDate: DateTime.now(),
                  //     lastDate: DateTime(9999),
                  //     onDateSaved: (value) {
                  //       String formatedDate = DateFormat('dd/MM/yyyy').format(value);                
                  //       _controllers['recebimentoDate']?.text = formatedDate;
                  //     },
                  //   )
                  // ),
                  TextFormField(
                    controller: controllers['recebimentoDate'],
                    onTap: () => selectDateRecebimento(context),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Data do recebimento",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => selectDateRecebimento(context),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                    child: DropdownButtonFormField<String>(
                      hint: const Text("Entrada/Saída"),
                      decoration: const InputDecoration(
                        labelText: 'Entrada/Saída'
                      ),
                      padding: EdgeInsets.zero,
                      value: saidaOrEntrada,
                      items: [
                        DropdownMenuItem(
                          value: NFeEntradaSaidaEnum.ENTRADA.value.toString(),
                          child: Text("Entrada")
                        ),
                        DropdownMenuItem(
                          value: NFeEntradaSaidaEnum.SAIDA.value.toString(),
                          child: Text("Saída")
                        )
                      ], 
                      onChanged: (String? value) {
                        saidaOrEntrada = value ?? '0';
                        controllers['entradaOuSaida']?.text = saidaOrEntrada;
                        setState(() {});
                      }
                    ),
                  );
                }
              ),
            ),
            
          ],
        ),
        TextFormField(
          controller: controllers['folha'],
          decoration: const InputDecoration(
            labelText: "Folha",
          ),
        ),
        ElevatedButton(onPressed: () {
          formKey.currentState?.save();

          formValues.number = controllers['number']?.text ?? '';
          formValues.recebimentoDate = controllers['recebimentoDate']?.text ?? DateTime.now().toString();

          formValues.serie = controllers['serie']?.text ?? '';
          formValues.idEAssinaturaDoRecebedor = controllers['idEAssinaturaDoRecebedor']?.text ?? '';
          String entradaOrSaida = controllers['entradaOuSaida']?.text ?? '';
          formValues.entradaOuSaida = entradaOrSaida == "0" ? NFeEntradaSaidaEnum.ENTRADA : NFeEntradaSaidaEnum.SAIDA;
          formValues.folha = controllers['folha']?.text ?? '';
          
          fnShowNfe(formValues);

          context.go('/dashboard/nfe/gerada', extra: formValues);
        }, child: const Text("Gerar NF-e")),
        const Gap(20),
      ],
    )
  );
}


