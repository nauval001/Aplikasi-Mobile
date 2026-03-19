class MahasiswaModel {
  final int id;
  final String name;
  final String email;
  final String body;

  MahasiswaModel({required this.id, required this.name, required this.email, required this.body});

  factory MahasiswaModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      body: json['body'] ?? '',
    );
  }
}