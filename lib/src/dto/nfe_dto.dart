class NFeDTO {
  String number;
  String serie;
  String recebimentoDate;
  String idEAssinaturaDoRecebedor;
  NFeEntradaSaidaEnum entradaOuSaida;

  NFeDTO({
    this.number = '',
    this.serie = '',
    this.recebimentoDate = '',
    this.idEAssinaturaDoRecebedor = '',
    required this.entradaOuSaida
  });

}


enum NFeEntradaSaidaEnum {
  ENTRADA(0),
  SAIDA(1);

  final int value;

  const NFeEntradaSaidaEnum(this.value);
}