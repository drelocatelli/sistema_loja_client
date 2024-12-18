class Venda {
  int id;
  String nome;
  String produto;
  String categoria;
  String responsavel;
  double valor;
  String data;
  int numero;

  Venda({required this.id, required this.nome, required this.produto, required this.categoria, required this.responsavel, required this.valor, required this.data, this.numero = 0});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'produto': produto,
      'categoria': categoria,
      'responsavel': responsavel,
      'valor': valor,
      'data': data,
      'numero': numero,
    };
  }
}

