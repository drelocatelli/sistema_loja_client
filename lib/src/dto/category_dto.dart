class Category {
  final String id;
  final String name;

  // Constructor
  Category({required this.id, required this.name});

  // Factory method to create a Category from a JSON object
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }

  // Method to convert a Category object into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
