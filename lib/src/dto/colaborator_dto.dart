class Colaborator {
  String? name;

  Colaborator({
    this.name,
  });

  factory Colaborator.fromJson(Map<String, dynamic> json) {
    return Colaborator(
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
