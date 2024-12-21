class ResponseDTO<T> {
  final int? status;
  final T? data;
  final String? message;

  ResponseDTO({this.status, this.data, this.message});

  @override
  String toString() {
    return 'ResponseDTO(status: $status, data: $data)';
  }
}
