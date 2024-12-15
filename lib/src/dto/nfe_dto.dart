import 'dart:convert';

class NFeDTO {
  String number;
  String serie;
  String recebimentoDate;
  String idEAssinaturaDoRecebedor;
  NFeEntradaSaidaEnum entradaOuSaida;
  String folha;

  NFeDTO({
    required this.entradaOuSaida,
    this.number = '',
    this.serie = '',
    this.recebimentoDate = '',
    this.idEAssinaturaDoRecebedor = '',
    this.folha = '1/1',
  });

  // Método de desserialização: Converte um Map (JSON) em uma instância de NFeDTO
  factory NFeDTO.fromJson(Map<String, dynamic> json) {
    return NFeDTO(
      number: json['number'] ?? '',
      serie: json['serie'] ?? '',
      recebimentoDate: json['recebimentoDate'] ?? '',
      idEAssinaturaDoRecebedor: json['idEAssinaturaDoRecebedor'] ?? '',
      entradaOuSaida: NFeEntradaSaidaEnum.values
          .firstWhere((e) => e.toString() == 'NFeEntradaSaidaEnum.' + json['entradaOuSaida']),
      folha: json['folha'] ?? '1/1',
    );
  }

  // Método de serialização: Converte uma instância de NFeDTO em Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'serie': serie,
      'recebimentoDate': recebimentoDate,
      'idEAssinaturaDoRecebedor': idEAssinaturaDoRecebedor,
      'entradaOuSaida': entradaOuSaida.toString().split('.').last, // Converte o enum para string
      'folha': folha,
    };
  }
}


enum NFeEntradaSaidaEnum {
  ENTRADA(0),
  SAIDA(1);

  final int value;

  const NFeEntradaSaidaEnum(this.value);
}