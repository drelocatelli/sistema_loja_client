class ResponseDTO<T> {
  final int? status;
  final T? data;
  final String? message;

  ResponseDTO({this.status, this.data, this.message});

  @override
  String toString() {
    return 'ResponseDTO(status: $status, data: $data)';
  }

  // Método de fábrica para converter de Map para ResponseDTO
  factory ResponseDTO.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    if (json['data'] is List) {
      // Se 'data' for uma lista, convertemos para uma lista de T
      final List<T> listData = (json['data'] as List).map((item) => fromJsonT(item)).toList();
      return ResponseDTO<T>(
        status: json['status'],
        data: listData as T, // A data agora é uma lista de T
        message: json['message'],
      );
    } else {
      // Se 'data' não for uma lista, mapeamos para um único objeto T
      return ResponseDTO<T>(
        status: json['status'],
        data: fromJsonT(json['data']),
        message: json['message'],
      );
    }
  }

}
