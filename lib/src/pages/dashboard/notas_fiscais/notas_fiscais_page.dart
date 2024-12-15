import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:racoon_tech_panel/src/dto/nfe_dto.dart';
import 'package:racoon_tech_panel/src/layout/main_layout.dart';
import 'package:racoon_tech_panel/src/pages/dashboard/notas_fiscais/components/nfe_generated.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class NotasFiscaisPage extends StatelessWidget {
  NotasFiscaisPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool _isNfeGenerated = false;
    NFeDTO? _nfeFormValues;

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
                    Gap(20),
                    Visibility(
                      visible: !_isNfeGenerated,
                      child: _form(context, _formKey, (NFeDTO? formValues) {
                        setState(() {
                          _nfeFormValues = formValues;
                          _isNfeGenerated = true;
                        });
                      }),
                    ),
                    Visibility(
                      visible: _isNfeGenerated,
                      child: Column(
                        spacing: 20,
                        children: [
                          _nfeFormValues != null ? nfeGenerated(context, nfeDetails: _nfeFormValues!) : SizedBox(),
                          ElevatedButton(onPressed: () {
                            setState(() {
                              _isNfeGenerated = false;
                            });
                          }, child: Text("Gerar nova NF-e")),
                        ],
                      )
                    )
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

  NFeDTO formValues = NFeDTO(entradaOuSaida: NFeEntradaSaidaEnum.ENTRADA);

  final Map<String, TextEditingController> _controllers = {
    "number" : TextEditingController(text: formValues.number.toString()),
    "serie" : TextEditingController(text: formValues.serie.toString()),
    "recebimentoDate" : TextEditingController(text: formValues.recebimentoDate.length != 0 ? formValues.recebimentoDate : DateFormat('dd/MM/yyyy').format(DateTime.now())),
    "idEAssinaturaDoRecebedor" : TextEditingController(text: formValues.idEAssinaturaDoRecebedor.toString()),
    "entradaOuSaida" : TextEditingController(text: "0"),
    "folha" : TextEditingController(text: "1/1"),
  };

  String _saidaOrEntrada = "0";
  
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
                controller: _controllers["number"],
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
                controller: _controllers["serie"],
                decoration: const InputDecoration(
                  labelText: "Série",
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: _controllers["idEAssinaturaDoRecebedor"],
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
              flex: Get.width >= 800 ? 3 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  SizedBox(
                    child:InputDatePickerFormField(
                      fieldHintText: 'Data do recebimento',
                      fieldLabelText: 'Data do recebimento',
                      firstDate: DateTime(2000),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(9999),
                      onDateSaved: (value) {
                        String formatedDate = DateFormat('MM/dd/yyyy').format(value);                
                        _controllers['recebimentoDate']?.text = formatedDate;
                      },
                    )
                    // child: SfDateRangePicker(
                    //   confirmText: '',
                    //   cancelText: '',
                    //   initialSelectedDate: DateTime.now(),
                    //   onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                    //     String formatedDate = DateFormat('dd/MM/yyyy').format(args.value);                
                    //     _controllers['recebimentoDate']?.text = formatedDate;
                    //   },
                    //   selectionMode: DateRangePickerSelectionMode.single,
                    //   showActionButtons: true,
                    // ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                    child: DropdownButtonFormField<String>(
                      hint: Text("Entrada/Saída"),
                      decoration: InputDecoration(
                        labelText: 'Entrada/Saída'
                      ),
                      padding: EdgeInsets.zero,
                      value: _saidaOrEntrada,
                      items: [
                        DropdownMenuItem(
                          child: Text("Entrada"),
                          value: NFeEntradaSaidaEnum.ENTRADA.value.toString()
                        ),
                        DropdownMenuItem(
                          child: Text("Saída"),
                          value: NFeEntradaSaidaEnum.SAIDA.value.toString()
                        )
                      ], 
                      onChanged: (String? value) {
                        _saidaOrEntrada = value ?? '0';
                        _controllers['entradaOuSaida']?.text = _saidaOrEntrada;
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
          controller: _controllers['folha'],
          decoration: const InputDecoration(
            labelText: "Folha",
          ),
        ),
        ElevatedButton(onPressed: () {
          formKey.currentState?.save();

          formValues.number = _controllers['number']?.text ?? '';
          formValues.recebimentoDate = _controllers['recebimentoDate']?.text ?? DateTime.now().toString();
          formValues.serie = _controllers['serie']?.text ?? '';
          formValues.idEAssinaturaDoRecebedor = _controllers['idEAssinaturaDoRecebedor']?.text ?? '';
          String entradaOrSaida = _controllers['entradaOuSaida']?.text ?? '';
          formValues.entradaOuSaida = entradaOrSaida == "0" ? NFeEntradaSaidaEnum.ENTRADA : NFeEntradaSaidaEnum.SAIDA;
          formValues.folha = _controllers['folha']?.text ?? '';
          
          fnShowNfe(formValues);
        }, child: Text("Gerar NF-e")),
        Gap(20),
      ],
    )
  );
}