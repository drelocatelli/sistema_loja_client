import 'package:racoon_tech_panel/src/Model/cliente_dto.dart';
import 'package:racoon_tech_panel/src/Model/colaborator_dto.dart';
import 'package:racoon_tech_panel/src/Model/product_dto.dart';

class SaveSalesDTO {
  String? serial;
  String? descricao;
  double? valor;
  Produto? produto;
  Colaborator? colaborator;
  Cliente? cliente;
  int? quantity;

  SaveSalesDTO({
    this.serial,
    this.descricao,
    this.produto,
    this.colaborator,
    this.cliente,
    this.quantity,
  });

  SaveSalesDTO.fromJson(Map<String, dynamic> json) {
    serial = json['serial'];
    descricao = json['descricao'];
    produto = json['produto'];
    colaborator = json['colaborator'];
    cliente = json['cliente'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serial'] = serial;
    data['descricao'] = descricao;
    data['produto'] = produto;
    data['colaborator'] = colaborator;
    data['cliente'] = cliente;
    data['quantity'] = quantity;
    return data;
  }
}