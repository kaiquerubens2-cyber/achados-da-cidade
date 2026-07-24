class ItemModel {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String category;
  final String? imagePath;

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.category,
    this.imagePath,
  });

  // Converter ItemModel para Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'imagePath': imagePath,
    };
  }

  // Criar ItemModel a partir de um Map (JSON)
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      category: map['category'] ?? 'Geral',
      imagePath: map['imagePath'],
    );
  }
}
