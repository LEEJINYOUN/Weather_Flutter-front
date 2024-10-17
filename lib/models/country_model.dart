class CountryModel {
  final int id;
  final String name;
  final String created_at;

  CountryModel({
    required this.id,
    required this.name,
    required this.created_at,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      name: json['name'],
      created_at: json['created_at'],
    );
  }
}
