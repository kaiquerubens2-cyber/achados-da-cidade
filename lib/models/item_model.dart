class ItemModel {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String category;

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.category,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      category: map['category'] ?? '',
    );
  }
}
