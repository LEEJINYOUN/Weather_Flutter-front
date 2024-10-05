class LocationModel {
  final int id;
  final String location_kr;
  final String location_en;
  final String created_at;

  LocationModel({
    required this.id,
    required this.location_kr,
    required this.location_en,
    required this.created_at,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      location_kr: json['location_kr'],
      location_en: json['location_en'],
      created_at: json['created_at'],
    );
  }
}
