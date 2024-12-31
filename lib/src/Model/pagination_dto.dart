class PaginationDTO {
  final int totalRecords;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  PaginationDTO({
    required this.totalRecords,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });

  // Factory constructor to create a PaginationDTO from JSON
  factory PaginationDTO.fromJson(Map<String, dynamic> json) {
    return PaginationDTO(
      totalRecords: json['totalRecords'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
    );
  }

  // Convert PaginationDTO to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      'totalRecords': totalRecords,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'pageSize': pageSize,
    };
  }

  @override
  String toString() {
    return 'PaginationDTO(totalRecords: $totalRecords, totalPages: $totalPages, currentPage: $currentPage, pageSize: $pageSize)';
  }
}
