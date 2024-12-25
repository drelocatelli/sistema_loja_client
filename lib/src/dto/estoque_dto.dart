class Estoque {
  final int id;
  final String foto_url;
  final String nome;
  final String descricao;
  final int quantidade;
  final double valor;
  String categoria;
  bool publicado;
  late double total;
  int numero;

  Estoque({
    required this.foto_url,
    required this.id,
    required this.nome,
    required this.descricao,
    required this.quantidade,
    required this.valor,
    this.categoria = 'Sem categoria',
    this.numero = 0,
    this.publicado = false,
  }) {
    total = valor * quantidade;
  }

  factory Estoque.fromJson(Map<String, dynamic> json) {
    return Estoque(
      categoria: json['categoria'],
      publicado: json['publicado'],
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