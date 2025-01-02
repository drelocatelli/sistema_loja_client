import 'package:flutter/material.dart';
import 'package:racoon_tech_panel/src/Model/cliente_dto.dart';
import 'package:racoon_tech_panel/src/Model/colaborator_dto.dart';
import 'package:racoon_tech_panel/src/Model/product_dto.dart';
import 'save_sales_dto.dart';

class SalesController {
  // Form Controllers
  final serialController = TextEditingController();
  final descricaoController = TextEditingController();
  final valorController = TextEditingController();
  final quantityController = TextEditingController();
  Produto? produto;
  Colaborator? colaborator;
  Cliente? cliente;

  // SaveSalesDTO instance
  SaveSalesDTO get dto => SaveSalesDTO(
        serial: serialController.text,
        descricao: descricaoController.text,
        produto: produto,
        colaborator: colaborator,
        cliente: cliente,
        quantity: (quantityController.text.isNotEmpty)
            ? int.parse(quantityController.text)
            : 0,
      );

  // Validation logic
  String? validateSerial(String? value) {
    if (value == null || value.isEmpty) {
      return 'Serial é obrigatorio';
    }
    return null;
  }

  String? validateDescricao(String? value) {
    if (value == null || value.isEmpty) {
      return 'Descrição é obrigatorio';
    }
    return null;
  }

  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantidade é obrigatorio';
    }
    if (int.tryParse(value) == null) {
      return 'Precisa ser valor numérico';
    }
    return null;
  }

  // Dispose method to clean up controllers
  void dispose() {
    serialController.dispose();
    descricaoController.dispose();
    valorController.dispose();
  }
}
