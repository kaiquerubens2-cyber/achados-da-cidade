class ItemModel {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String category;
  final String? imagePath; // Campo para guardar o caminho da foto

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.category,
    this.imagePath,
  });
}
