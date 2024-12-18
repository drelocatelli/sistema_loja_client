class Estoque {
  final int id;
  final String foto_url;
  final String nome;
  final String descricao;
  final int quantidade;
  final double valor;
  int numero;

  Estoque({
    required this.foto_url,
    required this.id,
    required this.nome,
    required this.descricao,
    required this.quantidade,
    required this.valor,
    this.numero = 0
  });

  factory Estoque.fromJson(Map<String, dynamic> json) {
    return Estoque(
      foto_url: json['foto_url'],
      numero: json['numero'],
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      quantidade: json['quantidade'],
      valor: json['valor'],
    );
  }
}