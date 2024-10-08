class ClothesModel {
  final int id;
  final String category;
  final String name;
  final int startTemp;
  final int endTemp;
  final String image;
  final String created_at;

  ClothesModel({
    required this.id,
    required this.category,
    required this.name,
    required this.startTemp,
    required this.endTemp,
    required this.image,
    required this.created_at,
  });

  factory ClothesModel.fromJson(Map<String, dynamic> json) {
    return ClothesModel(
      id: json['id'],
      category: json['category'],
      name: json['name'],
      startTemp: json['startTemp'],
      endTemp: json['endTemp'],
      image: json['image'],
      created_at: json['created_at'],
    );
  }
}
