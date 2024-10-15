class LocationModel {
  final int id;
  final int country_id;
  final String location;
  final String created_at;

  LocationModel({
    required this.id,
    required this.country_id,
    required this.location,
    required this.created_at,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      country_id: json['country_id'],
      location: json['location'],
      created_at: json['created_at'],
    );
  }
}
